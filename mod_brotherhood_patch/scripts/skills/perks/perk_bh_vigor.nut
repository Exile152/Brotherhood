this.perk_bh_vigor <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_vigor";
		this.m.Name = "Vigor";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_vigor.png";
		this.m.IconDisabled = "ui/perks/bh_vigor_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += 20;
	}
});
