this.bh_change_of_tempo_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "actives.bh_change_of_tempo"; this.m.Name = "Change of Tempo"; this.m.Description = "Switch places with an adjacent ally or enemy."; this.m.Icon = "ui/perks/perk_11_active.png"; this.m.IconDisabled = "ui/perks/perk_11_active_sw.png"; this.m.Overlay = "perk_11_active"; this.m.Type = this.Const.SkillType.Active; this.m.Order = this.Const.SkillOrder.Any - 1; this.m.IsActive = true; this.m.IsTargeted = true; this.m.IsIgnoredAsAOO = true; this.m.IsUsingHitchance = false; this.m.ActionPointCost = 3; this.m.FatigueCost = 20; this.m.MinRange = 1; this.m.MaxRange = 1; }
	function getTooltip() { return this.getDefaultUtilityTooltip(); }
	function getCursorForTile( _tile ) { return this.Const.UI.Cursor.Rotation; }
	function isUsable() { return this.skill.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted; }
	function onVerifyTarget( _originTile, _targetTile ) { if (!_targetTile.IsOccupiedByActor) return false; local t = _targetTile.getEntity(); return this.skill.onVerifyTarget(_originTile, _targetTile) && t.getCurrentProperties().IsMovable && !t.getCurrentProperties().IsRooted && !t.getCurrentProperties().IsStunned && !t.getCurrentProperties().IsImmuneToRotation; }
	function onUse( _user, _targetTile ) { local target = _targetTile.getEntity(); local enemy = !target.isAlliedWith(_user); this.Tactical.getNavigator().switchEntities(_user, target, null, null, 1.0); if (enemy) this.getContainer().add(this.new("scripts/skills/effects/bh_change_of_tempo_effect")); ::Brotherhood.logSwashbucklerTest(_user, "Change of Tempo used on " + (enemy ? "an enemy; free Zone of Control exit enabled." : "an ally.")); return true; }
});
