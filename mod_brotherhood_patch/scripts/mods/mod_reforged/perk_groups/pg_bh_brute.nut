this.pg_bh_brute <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_brute";
		this.m.Name = "Brute";
		this.m.Description = "A crushing melee combatant who overwhelms armor, bodies, and shields through raw strength.";
		this.m.Icon = "ui/perk_groups/rf_vicious.png";
		this.m.Tree = [["perk.bh_brute_force"], [], ["perk.bh_too_strong_to_miss"], ["perk.bh_axe_mastery"], ["perk.bh_brutality"], ["perk.bh_splitter"], []];
	}
	function getTree()
	{
		local masteries = ["perk.bh_axe_mastery", "perk.bh_cleaver_mastery", "perk.bh_mace_mastery"];
		local mastery = masteries[::Math.rand(0, masteries.len() - 1)];
		return [["perk.bh_brute_force"], [], ["perk.bh_too_strong_to_miss"], [mastery], ["perk.bh_brutality"], ["perk.bh_splitter"], []];
	}
});
