// Retained Obsidian archetypes available to the Wheel of Fortune.
//
// Every entry references an existing Brotherhood perk group. The referenced
// group's getTree() is the archetype package: it owns the perk list and the
// tier/row of every perk. Keep this manifest separate from selection logic so
// the pool can be replaced or expanded without changing the generator.
::Brotherhood.TemporaryArchetypeTestPool <- [
	{ ID = "pg.bh_duelist", Name = "Duelist" },
	{ ID = "pg.bh_fencer", Name = "Fencer" },
	{ ID = "pg.bh_executioner", Name = "Executioner" },
	{ ID = "pg.bh_swashbuckler", Name = "Swashbuckler" },
	{ ID = "pg.bh_plague_doctor", Name = "Plague Doctor" },
	{ ID = "pg.bh_knave", Name = "Knave" },
	{ ID = "pg.bh_nobody", Name = "Nobody" },
	{ ID = "pg.bh_brute", Name = "Brute" },
	{ ID = "pg.bh_artillerist", Name = "Artillerist" },
	{ ID = "pg.bh_braggart", Name = "Braggart" },
	{ ID = "pg.bh_gladiator", Name = "Gladiator" },
	{ ID = "pg.bh_prodigy", Name = "Prodigy" },
	{ ID = "pg.bh_marksman", Name = "Marksman" },
	{ ID = "pg.bh_opportunist", Name = "Opportunist" }
	,{ ID = "pg.bh_bard", Name = "Bard" }
	,{ ID = "pg.bh_brawler", Name = "Brawler" }
	,{ ID = "pg.bh_impish", Name = "Impish" }
	,{ ID = "pg.bh_dragon", Name = "Dragon" }
	,{ ID = "pg.bh_flagellant", Name = "Flagellant" }
	,{ ID = "pg.bh_berserker", Name = "Berserker" }
	,{ ID = "pg.bh_improviser", Name = "Improviser" }
	,{ ID = "pg.bh_blackguard", Name = "Blackguard" }
	,{ ID = "pg.bh_blueblood", Name = "Blueblood" }
	,{ ID = "pg.bh_conqueror", Name = "Conqueror" }
	,{ ID = "pg.bh_devout", Name = "Devout" }
	,{ ID = "pg.bh_hunter", Name = "Hunter" }
	,{ ID = "pg.bh_man_at_arms", Name = "Man-At-Arms" }
	,{ ID = "pg.bh_strongman", Name = "Strongman" }
	,{ ID = "pg.bh_wildling", Name = "Wildling" }
];

// One replaceable debug-spawn function. Updating the current Obsidian batch no
// longer leaves older forced-spawn arrays active beside it.
::Brotherhood.getCurrentObsidianDebugSpawn <- function()
{
	return {
		ArchetypeIDs = ["pg.bh_artillerist", "pg.bh_bard", "pg.bh_berserker", "pg.bh_blackguard", "pg.bh_blueblood"],
		DuoPerks = []
	};
}

::Brotherhood.GeneratedArchetypeCount <- 5;
