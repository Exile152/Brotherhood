this.perk_bh_steady_rhythm <- this.inherit("scripts/skills/skill", {
	m = { WeaponSkillsUsed = 0 },

	function create()
	{
		this.m.ID = "perk.bh_steady_rhythm";
		this.m.Name = "Steady Rhythm";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.recover", "ui/perks/perk_25.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill != null && _skill.m.IsWeaponSkill) ++this.m.WeaponSkillsUsed;
	}

	function onTurnStart() { this.m.WeaponSkillsUsed = 0; }

	function onTurnEnd()
	{
		local actor = this.getContainer().getActor();
		if (this.m.WeaponSkillsUsed == 1)
		{
			local before = actor.getFatigue();
			actor.setFatigue(::Math.max(0, before - 10));
			actor.setDirty(true);
			::Brotherhood.logFleshcraftMechanic("STEADY RHYTHM", actor, "Used exactly one weapon skill and recovered " + (before - actor.getFatigue()) + " Fatigue.");
		}
		this.m.WeaponSkillsUsed = 0;
	}

	function onCombatStarted() { this.m.WeaponSkillsUsed = 0; }
	function onCombatFinished() { this.m.WeaponSkillsUsed = 0; this.skill.onCombatFinished(); }
});
