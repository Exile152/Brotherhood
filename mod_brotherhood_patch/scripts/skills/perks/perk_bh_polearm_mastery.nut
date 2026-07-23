this.perk_bh_polearm_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_polearm_mastery";
		this.m.Name = "Polearm Mastery";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.mastery.polearm", "ui/perks/perk_10.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onUpdate( _properties ) { _properties.IsSpecializedInPolearms = true; }
	function onAdded()
	{
		::Brotherhood.logLatestObsidianTest("POLEARM MASTERY", this.getContainer().getActor(), "Brotherhood polearm specialization enabled without Bolster.");
	}
});
