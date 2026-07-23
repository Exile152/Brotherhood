this.perk_bh_unadaptive_opening <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_unadaptive_opening";
		this.m.Name = "Unadaptive Opening";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.fast_adaption", "ui/perks/perk_04.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function isFreshTarget( _target )
	{
		return _target != null && _target.getHitpoints() >= _target.getHitpointsMax() && _target.getArmor() >= _target.getArmorMax();
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack() || !this.isFreshTarget(_target)) return;
		_properties.MeleeSkill += 15;
		_properties.RangedSkill += 15;
		::Brotherhood.logFleshcraftMechanic("UNADAPTIVE OPENING", this.getContainer().getActor(), "Applied +15% hit chance against a fresh " + _target.getName() + ".");
	}
});
