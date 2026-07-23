this.pg_bh_dragon <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_dragon";
		this.m.Name = "Dragon";
		this.m.Description = "A gunpowder specialist who turns the Handgonne into a line of fire and ruin.";
		this.m.Icon = "ui/perk_groups/rf_vicious.png";
		this.m.Tree = [
			[],
			[],
			[],
			["perk.bh_gunpowder_mastery"],
			["perk.bh_dragons_breath"],
			[],
			["perk.bh_fearsome"]
		];
	}
});
