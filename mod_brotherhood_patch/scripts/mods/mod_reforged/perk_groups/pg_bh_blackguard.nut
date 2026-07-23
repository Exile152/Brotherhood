this.pg_bh_blackguard <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_blackguard";
		this.m.Name = "Blackguard";
		this.m.Description = "An isolated heavy fighter who abandons allies and breaks enemy morale.";
		this.m.Icon = "ui/perk_groups/rf_vicious.png";
		this.m.Tree = [[], [], ["perk.bh_forsworn"], ["perk.bh_mace_mastery"], ["perk.lone_wolf"], [], ["perk.bh_fearsome"]];
	}
	function getTree()
	{
		local pool = ["perk.bh_mace_mastery", "perk.bh_axe_mastery", "perk.bh_hammer_mastery", "perk.bh_flail_mastery"];
		return [[], [], ["perk.bh_forsworn"], [pool[::Math.rand(0, pool.len() - 1)]], ["perk.lone_wolf"], [], ["perk.bh_fearsome"]];
	}
});
