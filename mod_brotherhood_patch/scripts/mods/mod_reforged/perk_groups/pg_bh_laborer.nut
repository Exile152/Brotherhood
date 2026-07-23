this.pg_bh_laborer <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_laborer";
		this.m.Name = "Laborer";
		this.m.Description = "A tireless worker whose endurance and practiced repetition turn hard labor into battlefield skill.";
		this.m.Icon = "ui/perk_groups/rf_laborer.png";
		this.m.Tree = [["perk.bh_fruits_of_labor"], ["perk.bh_hard_boiled_egg"], ["perk.bh_repetitive_work"], ["perk.bh_hammer_mastery"], [], [], []];
	}
});
