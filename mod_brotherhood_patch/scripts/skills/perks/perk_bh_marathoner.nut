this.perk_bh_marathoner <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_marathoner";
		this.m.Name = "Marathoner";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_23.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= 1.10;
		_properties.StaminaMult *= 1.05;
		_properties.Initiative += 5;
	}
});
