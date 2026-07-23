this.perk_bh_flail_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_flail_mastery";
		this.m.Name = "Flail Mastery";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.mastery.flail", "ui/perks/perk_10.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAdded()
	{
		::Brotherhood.logLatestObsidianTest("FLAIL MASTERY", this.getContainer().getActor(), "Standalone Brotherhood mastery active; no unlisted Reforged mastery effects inherited.");
	}
});
