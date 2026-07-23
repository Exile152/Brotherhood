this.perk_bh_cleaver_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_cleaver_mastery";
		this.m.Name = "Cleaver Mastery";
		this.m.Description = ::Brotherhood.getExecutionerTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.mastery.cleaver", "ui/perks/perk_47.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function isCleaverSkill( _skill )
	{
		return _skill != null && _skill.isAttack() && ::Brotherhood.isWeaponSkillType(_skill, this.Const.Items.WeaponType.Cleaver);
	}
	function targetIsInjuredOrBleeding( _target )
	{
		return _target != null && (_target.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury) || _target.getSkills().hasSkill("effects.bleeding"));
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (!this.isCleaverSkill(_skill)) return;
		if (this.targetIsInjuredOrBleeding(_target)) _properties.DamageDirectAdd += 0.15;
	}
	function onTargetHit( _skill, _target, _bodyPart, _damageHitpoints, _damageArmor )
	{
		if (!this.isCleaverSkill(_skill) || _target == null || !_target.isAlive()) return;
		if (_damageHitpoints < ::Const.Combat.MinDamageToApplyBleeding || _target.getCurrentProperties().IsImmuneToBleeding) return;
		if (!this.RF_isNewSkillUseOrEntity(_target)) return;
		_target.getSkills().add(this.new("scripts/skills/effects/bleeding_effect"));
		::Brotherhood.logExecutionerTest(this.getContainer().getActor(), "Cleaver Mastery applied an additional Bleeding stack to " + _target.getName() + ".");
	}
});
