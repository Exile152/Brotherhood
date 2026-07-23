this.pg_bh_prodigy <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_prodigy";
		this.m.Name = "Prodigy";
		this.m.Description = "A naturally gifted student who adapts through practice, study, and difficult battles.";
		this.m.Icon = "ui/perk_groups/rf_student.png";
		this.m.Tree = [["perk.bh_fast_adaptation", "perk.bh_student"], ["perk.bh_gifted"], [], ["perk.bh_knowledge_mastery"], [], [], []];
	}
});
