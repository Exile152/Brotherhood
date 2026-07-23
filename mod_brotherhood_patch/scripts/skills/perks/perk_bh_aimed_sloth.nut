this.perk_bh_aimed_sloth <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_aimed_sloth";
		this.m.Name = "Aimed Sloth";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.overwhelm", "ui/perks/perk_42.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onTargetHit( _skill, _target, _bodyPart, _damage, _armorDamage )
	{
		if (_skill == null || !_skill.isAttack() || _target == null || _damage <= 0) return;
		local id = "effects.bh_aimed_sloth." + _target.getID();
		if (_target.getSkills().hasSkill(id)) return;
		local effect = this.new("scripts/skills/effects/bh_aimed_sloth_effect");
		effect.m.ID = id;
		_target.getSkills().add(effect);
		_target.setFatigue(_target.getFatigue() + 10);
		::Brotherhood.logFleshcraftMechanic("AIMED SLOTH", this.getContainer().getActor(), "Built 10 Fatigue on " + _target.getName() + ".");
	}
});
