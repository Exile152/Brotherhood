this.perk_bh_mind_over_matter <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_mind_over_matter";
		this.m.Name = "Will";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_will.png";
		this.m.IconDisabled = "ui/perks/bh_will_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.Hitpoints += this.Math.floor(actor.getBaseProperties().getBravery() * 0.50);
	}
});
