this.perk_bh_spear_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_spear_mastery";
		this.m.Name = "Spear Mastery";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.mastery.spear", "ui/perks/perk_10.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onUpdate( _properties ) { _properties.IsSpecializedInSpears = true; }
	function onAdded()
	{
		::Brotherhood.logLatestObsidianTest("SPEAR MASTERY", this.getContainer().getActor(), "Brotherhood spear specialization enabled without the old free first attack.");
	}
});
