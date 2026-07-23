this.perk_bh_magna_medicina <- this.inherit("scripts/skills/skill", {
	function create() { this.m.ID = "perk.bh_magna_medicina"; this.m.Name = "Magna Medicina"; this.m.Description = ::Brotherhood.getPlagueDoctorTooltip(this.m.ID); this.m.Icon = "ui/perks/perk_21.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; this.m.IsActive = false; }
	function onAdded() { if (!this.getContainer().hasSkill("actives.bh_magna_medicina")) this.getContainer().add(this.new("scripts/skills/actives/bh_magna_medicina_skill")); }
});
