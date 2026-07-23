this.perk_bh_little_devil <- this.inherit("scripts/skills/skill", {
	m = {
		IsSlipping = false,
		IsSpent = false,
		ActionPointsBeforeMovement = 0,
		FatigueBeforeMovement = 0,
		StartingTile = null,
		TilesMoved = 0,
		HasDiscountedThisMove = false
	},
	function create()
	{
		this.m.ID = "perk.bh_little_devil";
		this.m.Name = "Little Devil";
		this.m.Description = ::Brotherhood.getMobilityPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_26.png";
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function canSlipFromTile( _tile )
	{
		local actor = this.getContainer().getActor();
		return _tile != null && _tile.hasZoneOfControlOtherThan(actor.getAlliedFactions());
	}

	function canSlipBetweenTiles( _fromTile, _toTile )
	{
		return this.canSlipFromTile(_fromTile) && this.canSlipFromTile(_toTile);
	}

	function onUpdate( _properties )
	{
		if (this.m.IsSlipping)
		{
			local actor = this.getContainer().getActor();
			_properties.MeleeDefense += ::Math.floor(actor.getInitiative() * 0.20);
		}
	}

	function onMovementStarted( _tile, _numTiles )
	{
		local actor = this.getContainer().getActor();
		this.m.ActionPointsBeforeMovement = actor.getActionPoints();
		this.m.FatigueBeforeMovement = actor.getFatigue();
		this.m.StartingTile = _tile;
		this.m.TilesMoved = _numTiles;
		this.m.HasDiscountedThisMove = false;
		this.m.IsSlipping = _numTiles > 0 && actor.isPlacedOnMap() && this.canSlipFromTile(_tile);

		if (this.m.IsSlipping)
		{
			::Brotherhood.logObsidianTest("LITTLE DEVIL", actor, "Movement began inside enemy Zones of Control; +" + ::Math.floor(actor.getInitiative() * 0.20) + " Melee Defense active while slipping.");
			this.getContainer().update();
		}
		else ::Brotherhood.logObsidianTest("LITTLE DEVIL", actor, "Movement began without an enemy Zone of Control; no slipping defense.");
	}

	function onMovementFinished()
	{
		if (!this.m.IsSlipping) return;

		this.m.IsSlipping = false;
		this.m.TilesMoved = 0;
		this.m.HasDiscountedThisMove = false;
		this.getContainer().update();
		::Brotherhood.logObsidianTest("LITTLE DEVIL", this.getContainer().getActor(), "Movement finished; slipping defense cleared.");
	}

	function onTurnStart()
	{
		this.m.IsSlipping = false;
		this.m.IsSpent = false;
		this.m.TilesMoved = 0;
		this.m.HasDiscountedThisMove = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSlipping = false;
		this.m.IsSpent = false;
		this.m.TilesMoved = 0;
		this.m.HasDiscountedThisMove = false;
	}
});
