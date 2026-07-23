this.perk_bh_lightweight <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_lightweight";
		this.m.Name = "Lightweight";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.executioner", "ui/perks/perk_16.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsHidden = false;
	}
	function getWeaponDamageBonus()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return 0;
		local weapon = actor.getMainhandItem();
		if (weapon == null || !weapon.isItemType(this.Const.Items.ItemType.Weapon)) return 0;
		local weight = ::Math.max(0, -weapon.getStaminaModifier());
		return ::Math.min(15, ::Math.max(0, 5 - weight) * 3);
	}
	function isHidden()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor == null || !this.Tactical.isActive() || !actor.isPlacedOnMap() || this.getWeaponDamageBonus() <= 0;
	}
	function getTooltip()
	{
		local bonus = this.getWeaponDamageBonus();
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "Deal more damage with lighter weapons." },
			{ id = 10, type = "text", icon = "ui/icons/damage_dealt.png", text = "Current damage bonus: [color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "%[/color]" }
		];
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;
		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isItemType(this.Const.Items.ItemType.Weapon)) return;
		local weight = ::Math.max(0, -weapon.getStaminaModifier());
		local bonus = ::Math.min(15, ::Math.max(0, 5 - weight) * 3);
		_properties.DamageTotalMult *= 1.0 + bonus * 0.01;
	}
});
