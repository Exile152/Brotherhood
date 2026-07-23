this.perk_bh_en_garde <- this.inherit("scripts/skills/skill", {
	m = { WasActive = false },
	function create() { this.m.ID = "perk.bh_en_garde"; this.m.Name = "En Garde"; this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID); this.m.Icon = "ui/perks/perk_rf_en_garde.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; }
	function isEnabledOutsideOwnTurn()
	{
		local active = this.Tactical.isActive() ? this.Tactical.TurnSequenceBar.getActiveEntity() : null;
		return active == null || active.getID() != this.getContainer().getActor().getID();
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local enabled = this.isEnabledOutsideOwnTurn();
		if (enabled != this.m.WasActive) ::Brotherhood.logDuelistTest(actor, "En Garde " + (enabled ? "activated." : "deactivated for own turn."));
		if (enabled != this.m.WasActive) ::Brotherhood.logFencerTest(actor, "En Garde " + (enabled ? "activated outside own turn: +10 Melee Attack, +10 Melee Defense, +10% damage." : "deactivated for own turn."));
		this.m.WasActive = enabled;
		if (enabled) _properties.MeleeDefense += 10;
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != null && _skill.isAttack() && this.isEnabledOutsideOwnTurn())
		{
			_properties.MeleeSkill += 10;
			_properties.DamageTotalMult *= 1.10;
		}
	}
});
