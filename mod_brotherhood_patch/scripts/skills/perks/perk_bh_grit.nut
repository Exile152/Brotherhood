this.perk_bh_grit <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_grit";
		this.m.Name = "Grit";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_23.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		local actor = this.getContainer().getActor();
		if (!::Brotherhood.isUnarmedSkill(_skill, actor)) return;
		local bonus = ::Math.floor(actor.getFatigue() * 0.25);
		_properties.DamageRegularMin += bonus;
		_properties.DamageRegularMax += bonus;
		_properties.DamageDirectAdd += bonus * 0.01;
		if (_target != null) ::Brotherhood.logObsidianTest("GRIT", actor, "Accumulated Fatigue " + actor.getFatigue() + " granted +" + bonus + " damage and +" + bonus + "% armor penetration to " + _skill.getName() + ".");
	}
});
