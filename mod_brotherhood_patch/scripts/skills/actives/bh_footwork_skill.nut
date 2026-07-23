this.bh_footwork_skill <- this.inherit("scripts/skills/actives/footwork", {
	m = {},
	function create()
	{
		this.footwork.create();
		this.m.ID = "actives.bh_footwork";
		this.m.Name = "Footwork";
		this.m.Description = "Move through or out of an enemy Zone of Control without triggering a free attack.";
		this.m.Order = this.Const.SkillOrder.Any - 1;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 20;
	}
	function onAfterUpdate( _properties )
	{
		this.m.ActionPointCost = 2;
		this.m.FatigueCostMult = _properties.IsFleetfooted ? 0.5 : 1.0;
	}
});
