this.perk_bh_face_the_dragon <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_face_the_dragon";
		this.m.Name = "Face the Dragon";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_34.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;
		local actor = this.getContainer().getActor();
		local count = 0;
		foreach (enemy in ::Brotherhood.getAdjacentEnemies(actor)) if (enemy.getMoraleState() <= this.Const.MoraleState.Wavering) ++count;
		local bonus = ::Math.min(25, count * 10);
		_properties.DamageTotalMult *= 1.0 + bonus * 0.01;
		if (_target != null) ::Brotherhood.logObsidianTest("FACE THE DRAGON", actor, count + " adjacent Wavering-or-worse enemies granted +" + bonus + "% damage to " + _skill.getName() + ".");
	}
});
