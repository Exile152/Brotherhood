this.perk_bh_footwork <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_footwork";
		this.m.Name = "Footwork";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.footwork", "ui/perks/perk_25.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.bh_footwork")) this.getContainer().add(this.new("scripts/skills/actives/bh_footwork_skill"));
	}
	function onRemoved()
	{
		this.getContainer().removeByID("actives.bh_footwork");
	}
});
