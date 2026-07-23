this.perk_bh_change_of_tempo <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "perk.bh_change_of_tempo"; this.m.Name = "Change of Tempo"; this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID); this.m.Icon = "ui/perks/bh_change_of_tempo.png"; this.m.IconDisabled = "ui/perks/bh_change_of_tempo_sw.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; }
	function onAdded() { if (!this.getContainer().hasSkill("actives.bh_change_of_tempo")) this.getContainer().add(this.new("scripts/skills/actives/bh_change_of_tempo_skill")); }
	function onRemoved() { this.getContainer().removeByID("actives.bh_change_of_tempo"); }
});
