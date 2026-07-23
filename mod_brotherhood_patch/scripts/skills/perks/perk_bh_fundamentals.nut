this.perk_bh_fundamentals <- this.inherit("scripts/skills/skill", {
	m = { WasActive = false },

	function create()
	{
		this.m.ID = "perk.bh_fundamentals";
		this.m.Name = "Fundamentals";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.gifted", "ui/perks/perk_21.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onUpdate( _properties )
	{
		if (!this.Tactical.isActive()) return;
		local actor = this.getContainer().getActor();
		local isActive = actor.getFatigue() <= 20;
		if (isActive != this.m.WasActive)
		{
			this.m.WasActive = isActive;
			::Brotherhood.logFleshcraftMechanic("FUNDAMENTALS", actor, isActive ? "Activated at " + actor.getFatigue() + " accumulated Fatigue." : "Deactivated at " + actor.getFatigue() + " accumulated Fatigue.");
		}
		if (!isActive) return;

		local talents = actor.getTalents();
		for (local attribute = 0; attribute < this.Const.Attributes.COUNT; ++attribute)
		{
			if (talents[attribute] < 1) continue;
			switch (attribute)
			{
				case this.Const.Attributes.Hitpoints: _properties.Hitpoints += 7; break;
				case this.Const.Attributes.Bravery: _properties.Bravery += 7; break;
				case this.Const.Attributes.Fatigue: _properties.Stamina += 7; break;
				case this.Const.Attributes.Initiative: _properties.Initiative += 7; break;
				case this.Const.Attributes.MeleeSkill: _properties.MeleeSkill += 7; break;
				case this.Const.Attributes.RangedSkill: _properties.RangedSkill += 7; break;
				case this.Const.Attributes.MeleeDefense: _properties.MeleeDefense += 7; break;
				case this.Const.Attributes.RangedDefense: _properties.RangedDefense += 7; break;
			}
		}
	}

	function onCombatStarted() { this.m.WasActive = false; }
	function onCombatFinished() { this.m.WasActive = false; this.skill.onCombatFinished(); }
});
