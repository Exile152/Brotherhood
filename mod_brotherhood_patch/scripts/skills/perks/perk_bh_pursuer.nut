this.perk_bh_pursuer <- this.inherit("scripts/skills/skill", {
	m = { PendingRefund = false, HasTriggered = false },
	function create()
	{
		this.m.ID = "perk.bh_pursuer";
		this.m.Name = "Pursuer";
		this.m.Description = ::Brotherhood.getMobilityPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.pathfinder", "ui/perks/bh_pursuer.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function isHidden() { return !this.m.PendingRefund; }
	function getTooltip()
	{
		if (!this.m.PendingRefund) return null;
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "Your next movement step refunds up to 2 Action Points." },
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "Movement refund is [color=" + this.Const.UI.Color.PositiveValue + "]ready[/color]." }
		];
	}
	function trigger()
	{
		if (this.m.HasTriggered) return;
		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap() || !::Tactical.TurnSequenceBar.isActiveEntity(actor)) return;
		this.m.PendingRefund = true;
		this.m.HasTriggered = true;
		actor.setDirty(true);
	}
	function onTargetKilled( _targetEntity, _skill ) { this.trigger(); }
	function onOtherActorDeath( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
	{
		local actor = this.getContainer().getActor();
		if (_killer != null && actor != null && _killer.getID() == actor.getID()) this.trigger();
	}
	function consumeMovementStep( _actualAPSpent )
	{
		if (!this.m.PendingRefund) return 0;
		this.m.PendingRefund = false;
		local actor = this.getContainer().getActor();
		local refund = ::Math.min(2, ::Math.max(0, _actualAPSpent));
		actor.setActionPoints(::Math.min(actor.getActionPointsMax(), actor.getActionPoints() + refund));
		actor.setDirty(true);
		return refund;
	}
	function onTurnStart() { this.m.PendingRefund = false; this.m.HasTriggered = false; }
	function onTurnEnd() { this.m.PendingRefund = false; }
	function onCombatFinished() { this.m.PendingRefund = false; this.m.HasTriggered = false; this.skill.onCombatFinished(); }
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeBool(this.m.PendingRefund); _out.writeBool(this.m.HasTriggered); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.PendingRefund = _in.readBool(); this.m.HasTriggered = _in.readBool(); }
});
