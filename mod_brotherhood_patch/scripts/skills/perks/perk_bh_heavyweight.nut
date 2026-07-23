this.perk_bh_heavyweight <- this.inherit("scripts/skills/skill", {
	m = { LastBonus = -1 },
	function create()
	{
		this.m.ID = "perk.bh_heavyweight";
		this.m.Name = "Heavyweight";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.brawny", "ui/perks/perk_09.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function getWeaponWeightBonus()
	{
		local actor = this.getContainer().getActor();
		local weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (weapon == null || !weapon.isItemType(this.Const.Items.ItemType.Weapon)) return 0;
		return ::Math.min(12, ::Math.floor(::Math.max(0, -weapon.getStaminaModifier()) * 0.5));
	}
	function onUpdate( _properties )
	{
		local bonus = this.getWeaponWeightBonus();
		_properties.MeleeSkill += bonus;
		_properties.RangedSkill += bonus;
		if (bonus != this.m.LastBonus)
		{
			this.m.LastBonus = bonus;
			::Brotherhood.logFleshcraftMechanic("HEAVYWEIGHT", this.getContainer().getActor(), "Current weapon weight grants +" + bonus + " Attack Skill.");
		}
	}
});
