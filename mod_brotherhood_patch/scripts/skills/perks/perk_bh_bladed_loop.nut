// Deactivated for now: save-compatible stub only. Old saves keep the perk id without runtime behavior.
this.perk_bh_bladed_loop <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_bladed_loop";
		this.m.Name = "Bladed Loop";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.duelist", "ui/perks/perk_05.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}
});
