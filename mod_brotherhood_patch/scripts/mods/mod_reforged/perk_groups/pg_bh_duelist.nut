this.pg_bh_duelist <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_duelist";
		this.m.Name = "Duelist";
		this.m.Description = "A disciplined one-on-one fighter who masters swordplay, precise timing, and attacks that pierce through armor.";
		this.m.Icon = "ui/perk_groups/rf_swift.png";
		this.m.Tree = [[], ["perk.bh_feint"], ["perk.bh_en_garde"], ["perk.bh_sword_mastery"], ["perk.bh_double_strike", "perk.bh_panache"], [], ["perk.bh_duelist"]];
	}
});
