this.bh_magna_medicina_skill <- this.inherit("scripts/skills/skill", {
	m = { UsedTargets = [] },
	function create()
	{
		this.m.ID = "actives.bh_magna_medicina";
		this.m.Name = "Magna Medicina";
		this.m.Description = "Cure the most recently suffered temporary injury of yourself or an adjacent ally.";
		this.m.Icon = "skills/active_105.png";
		this.m.IconDisabled = "skills/active_105_sw.png";
		this.m.Overlay = "active_105";
		this.m.SoundOnUse = [
			"sounds/combat/first_aid_01.wav",
			"sounds/combat/first_aid_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any - 1;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
	}
	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Cures the most recently suffered temporary [injury|Concept.InjuryTemporary] of yourself or an adjacent ally")
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/health.png",
			text = ::Reforged.Mod.Tooltips.parseString("The first time it is used on each ally per battle, restores " + ::MSU.Text.colorPositive("30%") + " of that ally's maximum [Hitpoints|Concept.Hitpoints]")
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can only target yourself or an adjacent ally suffering a temporary injury"
		});
		ret.push({
			id = 13,
			type = "text",
			icon = "ui/tooltips/warning.png",
			text = "The user and patient must not be engaged in melee"
		});

		return ret;
	}
	function isUsable()
	{
		if (!this.skill.isUsable()) return false;
		local actor = this.getContainer().getActor();
		return !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions());
	}
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsOccupiedByActor || _originTile.getDistanceTo(_targetTile) > 1) return false;
		local target = _targetTile.getEntity();
		return target.isAlive() && !target.isDying()
			&& this.getContainer().getActor().isAlliedWith(target)
			&& !_originTile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())
			&& !_targetTile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())
			&& target.getSkills().getAllSkillsOfType(this.Const.SkillType.TemporaryInjury).len() > 0;
	}
	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local injuries = target.getSkills().getAllSkillsOfType(this.Const.SkillType.TemporaryInjury);
		if (injuries.len() == 0) return false;

		target.getSkills().remove(injuries[injuries.len() - 1]);
		local targetID = target.getID();
		if (this.m.UsedTargets.find(targetID) == null)
		{
			this.m.UsedTargets.push(targetID);
			local healing = this.Math.floor(target.getHitpointsMax() * 0.30);
			target.setHitpoints(this.Math.min(target.getHitpointsMax(), target.getHitpoints() + healing));
		}

		return true;
	}
	function onCombatFinished(){this.skill.onCombatFinished();this.m.UsedTargets.clear();}
});
