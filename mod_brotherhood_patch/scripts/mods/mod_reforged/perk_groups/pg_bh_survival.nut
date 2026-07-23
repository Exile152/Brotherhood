this.pg_bh_survival <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_survival";
		this.m.Name = "Survivability";
		this.m.Icon = "ui/perk_groups/rf_tough.png";
		this.m.Tree = [
			[
				"perk.colossus",
				"perk.nine_lives",
				"perk.bh_mind_over_matter",
				"perk.bh_vigor"
			]
		];
	}
});
