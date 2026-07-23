this.pg_bh_fencer <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_fencer";
		this.m.Name = "Fencer";
		this.m.Description = "A swift melee fighter who stays ahead of the enemy and punishes poor timing.";
		this.m.Icon = "ui/perk_groups/rf_swift.png";
		this.m.Tree = [[], ["perk.dodge", "perk.bh_feint"], ["perk.bh_en_garde"], ["perk.bh_fencing_mastery"], ["perk.bh_contre_attaque"], [], []];
	}
});
