this.perk_bh_speedster <- this.inherit("scripts/skills/skill", {
	m = {
		ActionPointsSpentOnMovement = 0,
		ActionPointsBeforeMovement = 0,
		HasTriggered = false,
		HasMoved = false,
		TilesMoved = 0
	},
	function create()
	{
		this.m.ID = "perk.bh_speedster";
		this.m.Name = "Speedster";
		this.m.Description = ::Brotherhood.getMobilityPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_36.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.m.HasTriggered && this.m.ActionPointsSpentOnMovement == 0;
	}

	function recordMovementAPSpent( _apSpent )
	{
		if (this.m.HasTriggered || _apSpent <= 0) return;

		this.m.ActionPointsSpentOnMovement += _apSpent;

		if (this.m.ActionPointsSpentOnMovement >= ::Brotherhood.SpeedsterActionPointThreshold)
		{
			local actor = this.getContainer().getActor();
			actor.setActionPoints(::Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 2));
			actor.setDirty(true);
			this.m.HasTriggered = true;
		}
	}

	function onMovementStarted( _tile, _numTiles )
	{
		this.m.ActionPointsBeforeMovement = this.getContainer().getActor().getActionPoints();
		this.m.HasMoved = _numTiles > 0;
		this.m.TilesMoved = _numTiles;
	}

	function onMovementFinished()
	{
		this.m.HasMoved = false;
		this.m.TilesMoved = 0;
	}

	function onTurnStart()
	{
		this.m.ActionPointsSpentOnMovement = 0;
		this.m.ActionPointsBeforeMovement = 0;
		this.m.HasTriggered = false;
		this.m.HasMoved = false;
		this.m.TilesMoved = 0;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.ActionPointsSpentOnMovement = 0;
		this.m.ActionPointsBeforeMovement = 0;
		this.m.HasTriggered = false;
		this.m.HasMoved = false;
		this.m.TilesMoved = 0;
	}
});
