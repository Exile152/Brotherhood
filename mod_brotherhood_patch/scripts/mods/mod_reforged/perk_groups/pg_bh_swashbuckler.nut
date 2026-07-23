this.pg_bh_swashbuckler <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_swashbuckler";
		this.m.Name = "Swashbuckler";
		this.m.Description = "An elusive showman who turns movement, missed blows, and shaken morale into openings for a dramatic finish.";
		this.m.Icon = "ui/perk_groups/rf_swift.png";
		this.m.Tree = [[], ["perk.bh_feint"], ["perk.bh_reentering_stage"], [], ["perk.bh_change_of_tempo", "perk.bh_panache"], ["perk.bh_stolen"], ["perk.bh_you_missed_again"]];
	}
});
