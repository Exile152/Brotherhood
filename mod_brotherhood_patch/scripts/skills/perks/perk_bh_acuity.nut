this.perk_bh_acuity <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_acuity";
		this.m.Name = "Acuity";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.dodge", "ui/perks/perk_05.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= 1.20;
	}
});
