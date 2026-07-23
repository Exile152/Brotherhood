this.bh_change_of_tempo_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "effects.bh_change_of_tempo"; this.m.Name = "Change of Tempo"; this.m.Description = "Can leave enemy zones of control without triggering free attacks."; this.m.Icon = "ui/perks/bh_change_of_tempo.png"; this.m.IconDisabled = "ui/perks/bh_change_of_tempo_sw.png"; this.m.Type = this.Const.SkillType.StatusEffect; this.m.IsActive = false; this.m.IsRemovedAfterBattle = true; }
	function onUpdate( _properties ) { _properties.IsImmuneToZoneOfControl = true; }
	function onTurnEnd() { this.removeSelf(); }
});
