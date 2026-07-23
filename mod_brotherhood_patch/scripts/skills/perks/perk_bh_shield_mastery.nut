this.perk_bh_shield_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_shield_mastery";
		this.m.Name = "Shield Mastery";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.shield_expert", "ui/perks/perk_10.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAdded()
	{
		::Brotherhood.logLatestObsidianTest("SHIELD MASTERY", this.getContainer().getActor(), "Standalone Brotherhood mastery active; Cover Ally and miss-fatigue effects are not inherited.");
	}
});
