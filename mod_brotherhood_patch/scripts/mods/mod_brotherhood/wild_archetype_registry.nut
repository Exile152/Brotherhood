// Explicit archetype registry. Every real archetype is Wild-eligible when it
// was not chosen as one of the character's native archetypes. "Wild" describes
// when/how the package was assigned; it is not a separate archetype class.
// Fleshcraft star Wild/Chaos fills to FINAL. Chaos rolls 1-2 per recruit
// (see star_layer.nut); RESERVED_CHAOS_SLOTS is the max reserved for legacy
// archetype Chaos and for computing the default pre-Chaos floor.
::Brotherhood.FINAL_PERK_TARGET <- 40;
::Brotherhood.RESERVED_CHAOS_SLOTS <- 2;
::Brotherhood.PRE_CHAOS_PERK_TARGET <- ::Brotherhood.FINAL_PERK_TARGET - ::Brotherhood.RESERVED_CHAOS_SLOTS;

::Brotherhood.WildArchetypeRegistry <- [
	{ ID = "pg.bh_duelist", Name = "Duelist", WildEligible = true },
	{ ID = "pg.bh_fencer", Name = "Fencer", WildEligible = true },
	{ ID = "pg.bh_executioner", Name = "Executioner", WildEligible = true },
	{ ID = "pg.bh_swashbuckler", Name = "Swashbuckler", WildEligible = true },
	{ ID = "pg.bh_plague_doctor", Name = "Plague Doctor", WildEligible = true },
	{ ID = "pg.bh_knave", Name = "Knave", WildEligible = true },
	{ ID = "pg.bh_brute", Name = "Brute", WildEligible = true },
	{ ID = "pg.bh_nobody", Name = "Nobody", WildEligible = true },
	{ ID = "pg.bh_artillerist", Name = "Artillerist", WildEligible = true },
	{ ID = "pg.bh_braggart", Name = "Braggart", WildEligible = true },
	{ ID = "pg.bh_gladiator", Name = "Gladiator", WildEligible = true },
	{ ID = "pg.bh_prodigy", Name = "Prodigy", WildEligible = true },
	{ ID = "pg.bh_marksman", Name = "Marksman", WildEligible = true },
	{ ID = "pg.bh_opportunist", Name = "Opportunist", WildEligible = true },
	{ ID = "pg.bh_bard", Name = "Bard", WildEligible = true },
	{ ID = "pg.bh_brawler", Name = "Brawler", WildEligible = true },
	{ ID = "pg.bh_impish", Name = "Impish", WildEligible = true },
	{ ID = "pg.bh_dragon", Name = "Dragon", WildEligible = true },
	{ ID = "pg.bh_flagellant", Name = "Flagellant", WildEligible = true },
	{ ID = "pg.bh_berserker", Name = "Berserker", WildEligible = true },
	{ ID = "pg.bh_improviser", Name = "Improviser", WildEligible = true }
	,{ ID = "pg.bh_blackguard", Name = "Blackguard", WildEligible = true }
	,{ ID = "pg.bh_blueblood", Name = "Blueblood", WildEligible = true }
	,{ ID = "pg.bh_conqueror", Name = "Conqueror", WildEligible = true }
	,{ ID = "pg.bh_devout", Name = "Devout", WildEligible = true }
	,{ ID = "pg.bh_hunter", Name = "Hunter", WildEligible = true }
	,{ ID = "pg.bh_man_at_arms", Name = "Man-At-Arms", WildEligible = true }
	,{ ID = "pg.bh_strongman", Name = "Strongman", WildEligible = true }
	,{ ID = "pg.bh_wildling", Name = "Wildling", WildEligible = true }
];
