this.perk_bh_axe_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_axe_mastery";
		this.m.Name = "Axe Mastery";
		this.m.Description = ::Brotherhood.getBruteLaborerTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_10.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAdded(){::Brotherhood.logArchetypeTest("AXE MASTERY",this.getContainer().getActor(),"Standalone Brotherhood mastery active; no Reforged bonus skills inherited.");}
});
