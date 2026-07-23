this.perk_bh_you_missed_again <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "perk.bh_you_missed_again"; this.m.Name = "You Missed, Again"; this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID); this.m.Icon = "ui/perks/perk_41.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; this.m.IsActive = false; }
	function onMissed( _attacker, _skill ) { if (_attacker != null && !_attacker.isAlliedWith(this.getContainer().getActor()) && this.Math.rand(1, 100) <= 33) { local succeeded = _attacker.checkMorale(-1, 0); ::Brotherhood.logSwashbucklerTest(this.getContainer().getActor(), "You Missed, Again forced a negative morale check on " + _attacker.getName() + (succeeded ? "." : "; morale did not drop.")); } }
});
