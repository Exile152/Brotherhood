this.perk_bh_dagger_mastery <- this.inherit("scripts/skills/skill", {
	m = { HasLoggedInitiative = false, LoggedAPCosts = {} },
	function create()
	{
		this.m.ID = "perk.bh_dagger_mastery";
		this.m.Name = "Dagger Mastery";
		this.m.Description = ::Brotherhood.getNewArchetypeTooltip(this.m.ID);
		local p = ::Const.Perks.findById("perk.mastery.dagger");
		this.m.Icon = p == null ? "ui/perks/perk_46.png" : p.Icon;
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += 10;
		if (!this.m.HasLoggedInitiative)
		{
			this.m.HasLoggedInitiative = true;
			::Brotherhood.logArchetypeTest("DAGGER MASTERY", this.getContainer().getActor(), "Applied +10 Initiative.");
		}
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		local actor = this.getContainer().getActor();
		local skillID = _skill == null ? "null" : _skill.getID();
		local item = _skill == null ? null : _skill.getItem();
		if (item == null)
		{
			::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Rejected skill " + skillID + ": it has no associated weapon item.");
			return;
		}
		local isDaggerSkill = skillID == "actives.stab" || skillID == "actives.puncture" || skillID == "actives.deathblow" || skillID == "actives.deathblow_skill" || skillID == "actives.bh_perfect_thrust";
		local isDaggerWeapon = "isWeaponType" in item && item.isWeaponType(this.Const.Items.WeaponType.Dagger);
		if (!isDaggerWeapon && !isDaggerSkill)
		{
			::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Rejected skill " + skillID + ": " + item.getName() + " is not detected as a dagger.");
			return;
		}
		if (!isDaggerWeapon && isDaggerSkill) ::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Accepted dagger skill " + skillID + " by skill ID because " + item.getName() + " lacks Reforged's dagger weapon tag.");
		local oldFatigueMult = _properties.FatigueEffectMult;
		_properties.FatigueEffectMult *= 0.75;
		::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Accepted dagger skill " + skillID + "; FatigueEffectMult " + oldFatigueMult + " -> " + _properties.FatigueEffectMult + ".");
		if (_target == null)
		{
			::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Damage bonus not evaluated for " + skillID + ": no target (usually tooltip preview).");
		}
		else if (actor.getInitiative() > _target.getInitiative())
		{
			local oldDamageMult = _properties.DamageTotalMult;
			_properties.DamageTotalMult *= 1.10;
			::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Applied +10% damage against " + _target.getName() + " (Initiative " + actor.getInitiative() + " > " + _target.getInitiative() + "); DamageTotalMult " + oldDamageMult + " -> " + _properties.DamageTotalMult + ".");
		}
		else ::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Rejected damage bonus against " + _target.getName() + " (Initiative " + actor.getInitiative() + " <= " + _target.getInitiative() + ").");
	}

	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		foreach (skill in this.getContainer().getAllSkillsOfType(this.Const.SkillType.Active))
		{
			if (skill == null) continue;
			local id = skill.getID();
			if (id != "actives.stab" && id != "actives.puncture" && id != "actives.deathblow" && id != "actives.deathblow_skill") continue;
			local before = skill.m.ActionPointCost;
			if (before > 0) skill.m.ActionPointCost = before - 1;
			local logKey = id + ":" + before + ":" + skill.m.ActionPointCost;
			if (actor != null && !(logKey in this.m.LoggedAPCosts))
			{
				this.m.LoggedAPCosts[logKey] <- true;
				::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Live " + id + " ActionPointCost " + before + " -> " + skill.m.ActionPointCost + ".");
			}
		}
	}

	function onCombatFinished()
	{
		this.m.HasLoggedInitiative = false;
		this.m.LoggedAPCosts = {};
		this.skill.onCombatFinished();
	}
});
