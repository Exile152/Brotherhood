this.perk_bh_double_strike <- this.inherit("scripts/skills/skill", {
	m = { HasDamageBonus = false, LastWeaponInstanceID = null },
	function create()
	{
		this.m.ID = "perk.bh_double_strike";
		this.m.Name = "Double Strike";
		this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_double_strike.png";
		this.m.IconDisabled = "ui/perks/bh_double_strike_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}
	function reset( _reason = null ) { if (this.m.HasDamageBonus && _reason != null) ::Brotherhood.logDuelistTest(this.getContainer().getActor(), "Double Strike deactivated: " + _reason + "."); this.m.HasDamageBonus = false; }
	function getWeaponInstanceID()
	{
		local weapon = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return weapon == null ? null : weapon.getInstanceID();
	}
	function onUpdate( _properties )
	{
		local current = this.getWeaponInstanceID();
		if (this.m.LastWeaponInstanceID != current) this.reset("weapon changed");
		this.m.LastWeaponInstanceID = current;
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties ) { if (_skill.isAttack() && this.m.HasDamageBonus) _properties.DamageTotalMult *= 1.25; }
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) { if (_skill.isAttack()) { if (!this.m.HasDamageBonus) ::Brotherhood.logDuelistTest(this.getContainer().getActor(), "Double Strike activated; subsequent attacks deal +25% damage."); this.m.HasDamageBonus = true; } }
	function onTargetMissed( _skill, _targetEntity ) { if (_skill.isAttack()) this.reset("attack missed"); }
	function onMovementStep( _tile, _levelDifference ) { this.reset("moved"); }
	function onWaitTurn() { this.reset("waited"); }
	function onTurnEnd() { this.reset("turn ended"); }
});
