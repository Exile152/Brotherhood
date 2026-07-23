this.perk_bh_crippling_strikes <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_crippling_strikes";
		this.m.Name = "Crippling Strikes";
		this.m.Description = ::Brotherhood.getExecutionerTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.crippling_strikes", "ui/perks/perk_14.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.BH_ArmorHitInfo <- null;
	}
	function onUpdate( _properties )
	{
		_properties.ThresholdToInflictInjuryMult *= 0.66;
	}
	function onAdded() { ::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Perk added; injury threshold reduction is available for melee and ranged attacks."); }
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;
		local targetName = _targetEntity == null ? "no target" : _targetEntity.getName();
		local mult = "ThresholdToInflictInjuryMult" in _properties ? _properties.ThresholdToInflictInjuryMult : -1.0;
		::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Attack evaluated with " + _skill.getName() + " against " + targetName + "; effective injury-threshold multiplier=" + mult + ".");
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		this.m.BH_ArmorHitInfo = null;
		if (_skill == null || !_skill.isAttack() || _targetEntity == null || !_targetEntity.getCurrentProperties().IsAffectedByInjuries || _hitInfo.Injuries == null)
		{
			::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Armor-injury setup rejected: invalid attack, target immune, or attack has no injury pool.");
			return;
		}

		this.m.BH_ArmorHitInfo = clone _hitInfo;
		::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Armor-injury check prepared against " + _targetEntity.getName() + ".");
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.BH_ArmorHitInfo == null) return;
		local hitInfo = this.m.BH_ArmorHitInfo;
		this.m.BH_ArmorHitInfo = null;

		if (_targetEntity == null || !_targetEntity.isAlive() || _damageInflictedArmor <= 0 || _damageInflictedHitpoints > 0)
		{
			::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Armor-injury check ineligible: HP damage=" + _damageInflictedHitpoints + ", armor damage=" + _damageInflictedArmor + ".");
			return;
		}

		if (!this.RF_isNewSkillUseOrEntity(_targetEntity))
		{
			::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Armor-injury application skipped as duplicate skill-use processing.");
			return;
		}

		if (::Math.rand(1, 100) > 50)
		{
			::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Armor-injury check failed its 50% roll.");
			return;
		}

		local injuriesBeforeList = _targetEntity.getSkills().getAllSkillsOfType(::Const.SkillType.TemporaryInjury);
		local injuriesBefore = injuriesBeforeList.len();
		local injuryIDsBefore = injuriesBeforeList.map(@(_injury) _injury.getID());
		local armorInjuryDamage = _damageInflictedArmor;
		hitInfo.DamageInflictedHitpoints = armorInjuryDamage;
		_targetEntity.MV_applyInjury(_skill, hitInfo);
		local injuriesAfterList = _targetEntity.getSkills().getAllSkillsOfType(::Const.SkillType.TemporaryInjury);
		local injuriesAfter = injuriesAfterList.len();
		local appliedInjury = null;
		foreach (injury in injuriesAfterList)
		{
			if (injuryIDsBefore.find(injury.getID()) == null)
			{
				appliedInjury = injury;
				break;
			}
		}
		local result = appliedInjury == null ? "; no injury met the threshold." : ", and it suffers " + appliedInjury.getName() + ".";
		::Brotherhood.logCripplingTest(this.getContainer().getActor(), "Armor injury check used " + armorInjuryDamage + " armor damage against " + _targetEntity.getName() + result);
		if (appliedInjury != null && ::Tactical.isActive())
		{
			::Tactical.EventLog.log(_targetEntity.getName() + "'s armor is hit for " + _damageInflictedArmor + " damage and suffers " + appliedInjury.getName() + "!");
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.BH_ArmorHitInfo = null;
	}
});
