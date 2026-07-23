this.pg_bh_marksman <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID = "pg.bh_marksman";
		this.m.Name = "Marksman";
		this.m.Description = "A ranged specialist who reads lines of fire and turns superior vision into punishing shots.";
		this.m.Icon = "ui/perk_groups/rf_marksmanship.png";
		this.m.Tree = [[], ["perk.bh_bullseye"], ["perk.bh_anticipation"], ["perk.bh_bow_mastery"], [], ["perk.bh_eagle_eyesight"], []];
	}

	function getTree()
	{
		if (::Brotherhood.TestingMode && ::Brotherhood.DebugIncludeBothMarksmanMasteries)
		{
			return [[], ["perk.bh_bullseye"], ["perk.bh_anticipation"], ["perk.bh_bow_mastery", "perk.bh_crossbow_mastery"], [], ["perk.bh_eagle_eyesight"], []];
		}

		local mastery = ::Math.rand(0, 1) == 0 ? "perk.bh_bow_mastery" : "perk.bh_crossbow_mastery";
		return [[], ["perk.bh_bullseye"], ["perk.bh_anticipation"], [mastery], [], ["perk.bh_eagle_eyesight"], []];
	}
});
