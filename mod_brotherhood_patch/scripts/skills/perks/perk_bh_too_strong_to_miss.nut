this.perk_bh_too_strong_to_miss <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_too_strong_to_miss";
		this.m.Name = "Too Strong to Miss";
		this.m.Description = ::Brotherhood.getBruteLaborerTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_51.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onTargetMissed( _skill, _target )
	{
		if (_target == null || _skill == null || !_skill.isAttack() || _skill.isRanged()) return;
		local weapon = _skill.getItem();
		if (weapon == null || weapon.getBlockedSlotType() == null) return;

		local properties = this.getContainer().buildPropertiesForUse(_skill, _target);
		local rolledDamage = ::Math.rand(properties.DamageRegularMin, properties.DamageRegularMax);
		local armorDamage = ::Math.max(1, ::Math.floor(rolledDamage * properties.DamageArmorMult * properties.DamageTotalMult * properties.MeleeDamageMult * 0.25));
		local bodyPart = ::Math.rand(1, 100) <= properties.getHitchance(this.Const.BodyPart.Head) ? this.Const.BodyPart.Head : this.Const.BodyPart.Body;
		local armorBefore = _target.getArmor(bodyPart);

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = 0;
		hitInfo.DamageArmor = armorDamage;
		hitInfo.DamageDirect = 0.0;
		hitInfo.DamageFatigue = 0;
		hitInfo.DamageMinimum = 0;
		hitInfo.BodyPart = bodyPart;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		hitInfo.Injuries = null;
		hitInfo.InjuryThresholdMult = 1.0;
		hitInfo.Tile = _target.getTile();

		_target.onDamageReceived(this.getContainer().getActor(), _skill, hitInfo);
		local dealt = armorBefore - _target.getArmor(bodyPart);
		::Brotherhood.logArchetypeTest("TOO STRONG TO MISS", this.getContainer().getActor(), "Miss rolled " + armorDamage + " armor-only damage and dealt " + dealt + " to " + _target.getName() + ".");
	}
});
