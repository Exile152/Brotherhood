this.pg_bh_executioner <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_executioner";
		this.m.Name = "Executioner";
		this.m.Description = "A brutal finisher who cripples enemies and turns wounds into certain death.";
		this.m.Icon = "ui/perk_groups/rf_vicious.png";
		this.m.Tree = [["perk.bh_crippling_strikes"], ["perk.bh_executioner"], [], ["perk.bh_cleaver_mastery"], [], ["perk.bh_heads_will_roll"], []];
	}
});
