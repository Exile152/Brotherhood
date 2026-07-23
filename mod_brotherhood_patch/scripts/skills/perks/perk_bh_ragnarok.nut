this.perk_bh_ragnarok <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_ragnarok";
		this.m.Name = "Ragnarok";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.berserk", "ui/perks/perk_03.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.bh_ragnarok"))
		{
			this.getContainer().add(this.new("scripts/skills/actives/bh_ragnarok_skill"));
			::Brotherhood.logFleshcraftMechanic("RAGNAROK", this.getContainer().getActor(), "Granted the Ragnarok active skill.");
		}
	}
	function onRemoved()
	{
		::Brotherhood.logFleshcraftMechanic("RAGNAROK", this.getContainer().getActor(), "Removed the Ragnarok active skill.");
		this.getContainer().removeByID("actives.bh_ragnarok");
	}
});
