this.perk_bh_medicine_mastery <- this.inherit("scripts/skills/skill", {
	function create() { this.m.ID = "perk.bh_medicine_mastery"; this.m.Name = "Medicine Mastery"; this.m.Description = ::Brotherhood.getPlagueDoctorTooltip(this.m.ID); this.m.Icon = "ui/perks/bh_medicine_mastery.png"; this.m.IconDisabled = "ui/perks/bh_medicine_mastery_sw.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; this.m.IsActive = false; }
});
