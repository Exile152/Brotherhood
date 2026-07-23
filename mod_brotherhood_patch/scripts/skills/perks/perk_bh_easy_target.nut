this.perk_bh_easy_target <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_easy_target";
		this.m.Name = "Easy Target";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function hasNegativeStatus( _target )
	{
		foreach (effect in _target.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true))
		{
			if (effect.isType(this.Const.SkillType.TemporaryInjury)) return true;
			if (("IsNegative" in effect.m && effect.m.IsNegative) || effect.getID().find("effects.net") != null) return true;
		}
		return false;
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _targetEntity == null) return;
		if (_targetEntity.getHitpointsPct() >= 0.5 && !this.hasNegativeStatus(_targetEntity)) return;
		_properties.MeleeSkill += 10;
		_properties.RangedSkill += 10;
	}
});
