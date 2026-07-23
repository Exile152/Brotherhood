this.perk_bh_ghost_pain <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "perk.bh_ghost_pain";
		this.m.Name = "Ghost Pain";
		this.m.Description = ::Brotherhood.getPlagueDoctorTooltip(this.m.ID);
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
});
