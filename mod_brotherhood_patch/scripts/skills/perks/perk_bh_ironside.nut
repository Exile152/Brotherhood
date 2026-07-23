this.perk_bh_ironside <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_ironside";
		this.m.Name = "Ironside";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_03.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;
		_properties.DamageArmorReduction += 5;
		_hitInfo.DamageArmor = this.Math.max(6, _hitInfo.DamageArmor);
	}
});
