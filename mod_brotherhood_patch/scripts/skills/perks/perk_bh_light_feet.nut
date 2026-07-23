this.perk_bh_light_feet <- this.inherit("scripts/skills/skill", {
	m = {
		MovementTilesThisTurn = 0,
		HasTriggered = false
	},
	function create()
	{
		this.m.ID = "perk.bh_light_feet";
		this.m.Name = "Light Feet";
		this.m.Description = ::Brotherhood.getMobilityPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_01.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return true;
	}

	function onUpdate( _properties )
	{
		_properties.MovementFatigueCostMult *= 0.7;
	}

	function recordMovementTile( _triggered )
	{
		this.m.MovementTilesThisTurn += 1;
		if (_triggered) this.m.HasTriggered = true;
	}

	function onCostsPreview( _costsPreview )
	{
		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPreviewing()) return;

		::Brotherhood.applyMovementPreviewCostsToCostsPreview(actor, _costsPreview);

		local movement = actor.getPreviewMovement();
		if (movement == null || movement.Tiles <= 0) return;
		if (this.m.HasTriggered) return;

		local costs = actor.getCostsPreview();
		if (costs == null || !("ActionPoints" in costs)) return;

		// Keep this UI fallback narrow: only refund paths made entirely of 2 AP tiles.
		if (costs.ActionPoints != movement.Tiles * 2) return;
		if (!("actionPointsPreview" in _costsPreview)) return;

		local adjustedCost = ::Math.max(0, ::Brotherhood.getMovementPreviewNormalActionPointCost(actor, costs.ActionPoints) - 1);
		_costsPreview.actionPointsPreview = ::Math.max(0, actor.getActionPoints() - adjustedCost);
	}

	function onTurnStart()
	{
		this.m.MovementTilesThisTurn = 0;
		this.m.HasTriggered = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.MovementTilesThisTurn = 0;
		this.m.HasTriggered = false;
	}
});
