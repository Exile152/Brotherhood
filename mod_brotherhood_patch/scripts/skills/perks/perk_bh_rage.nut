this.perk_bh_rage <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_rage";
		this.m.Name = "Rage";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_36.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _skill.isRanged()) return;
		local actor = this.getContainer().getActor();
		local hp = actor.getHitpointsPct();
		local steps = hp <= 0.20 ? 5 : ::Math.floor((1.0 - hp) * 5.0);
		_properties.DamageTotalMult *= 1.0 + steps * 0.05;
		if (_target != null) ::Brotherhood.logObsidianTest("RAGE", actor, ::Math.floor(hp * 100) + "% HP granted +" + (steps * 5) + "% melee damage to " + _skill.getName() + ".");
	}
});
