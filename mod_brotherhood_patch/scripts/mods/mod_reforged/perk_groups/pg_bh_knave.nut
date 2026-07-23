this.pg_bh_knave <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_knave";
		this.m.Name = "Knave";
		this.m.Description = "A slippery dagger fighter who wins with distraction, footwork, and stolen steel.";
		this.m.Icon = "ui/perk_groups/rf_swift.png";
		this.m.Tree = [["perk.bh_misdirect", "perk.bags_and_belts"], ["perk.bh_backstabber"], [], ["perk.bh_dagger_mastery"], ["perk.bh_disengage"], ["perk.bh_stolen"], []];
	}
});
