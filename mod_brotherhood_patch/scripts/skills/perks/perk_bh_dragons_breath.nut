this.perk_bh_dragons_breath <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "perk.bh_dragons_breath";
		this.m.Name = "Dragon's Breath";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_dragons_breath.png";
		this.m.IconDisabled = "ui/perks/bh_dragons_breath_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onTargetHit( _skill, _target, _bodyPart, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();
		if (_skill == null || _skill.getID() != "actives.fire_handgonne" || _target == null) return;
		if (_target.isAlliedWith(actor))
		{
			::Brotherhood.logObsidianTest("DRAGONS BREATH", actor, "Hit allied target " + _target.getName() + "; Burning was not applied.");
			return;
		}
		if (!_target.isAlive() || _target.isDying())
		{
			::Brotherhood.logObsidianTest("DRAGONS BREATH", actor, "Hit " + _target.getName() + ", but the target did not survive to receive Burning.");
			return;
		}

		_target.getSkills().removeByID("effects.bh_dragons_breath_burning");
		_target.getSkills().add(this.new("scripts/skills/effects/bh_dragons_breath_burning_effect"));
		::Brotherhood.logObsidianTest("DRAGONS BREATH", actor, "Set " + _target.getName() + " Burning until the start of their next turn.");
	}
});
