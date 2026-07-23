// Wheel of Fortune profile data. Selection logic lives in wheel_selector.nut so
// designers can tune eligibility and weights without touching the algorithm.
::Brotherhood.WheelProfiles <- [];

::Brotherhood.addWheelProfile <- function( _profile )
{
	if (!("Requirements" in _profile)) _profile.Requirements <- [];
	if (!("Stats" in _profile)) _profile.Stats <- [];
	if (!("Backgrounds" in _profile)) _profile.Backgrounds <- [];
	if (!("Traits" in _profile)) _profile.Traits <- [];
	if (!("NegativeTraits" in _profile)) _profile.NegativeTraits <- [];
	if (!("Exclusions" in _profile)) _profile.Exclusions <- [];
	if (!("BaseWeight" in _profile)) _profile.BaseWeight <- 1.0;
	::Brotherhood.WheelProfiles.push(_profile);
}

::Brotherhood.wheelStat <- function( _key, _role, _thresholds, _talentWeight = 0.0 )
{
	return { Key = _key, Role = _role, Thresholds = _thresholds, TalentWeight = _talentWeight };
}

::Brotherhood.wheelRequirement <- function( _key, _minimum )
{
	return { Key = _key, Minimum = _minimum };
}

// Weights use the Artillerist Canvas scale: Very Low 0.5, Low 1,
// Low+ 1.5, Medium 2, Strong 3, Horrible -3.
::Brotherhood.addWheelProfile({
	ID="pg.bh_artillerist", Name="Artillerist", Fantasy="handgonne artillery",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.RangedSkill, 70)],
	Stats=[
		::Brotherhood.wheelStat(::Const.Attributes.RangedSkill, "Primary", [[90,3.0],[80,2.0],[70,1.5]], 0.75),
		::Brotherhood.wheelStat(::Const.Attributes.RangedDefense, "TieBreaker", [[20,3.0],[15,2.0],[10,1.0]]),
		::Brotherhood.wheelStat(::Const.Attributes.Hitpoints, "TieBreaker", [[75,0.5]]),
		::Brotherhood.wheelStat(::Const.Attributes.Fatigue, "TieBreaker", [[75,0.5]]),
		::Brotherhood.wheelStat(::Const.Attributes.Bravery, "TieBreaker", [[50,0.5]]),
		::Brotherhood.wheelStat(::Const.Attributes.Initiative, "TieBreaker", [[100,2.0]])
	],
	Backgrounds=[["southern",3.0],["nomad",3.0],["assassin",1.0],["noble",1.0]],
	Traits=[["eagle_eyes",3.0],["swift",2.0],["tiny",2.0]], NegativeTraits=[["short_sighted",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_bard", Name="Bard", Fantasy="morale and music support",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Primary",[[60,3.0],[50,2.0],[42,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[100,1.0],[85,0.5]])],
	Backgrounds=[["minstrel",3.0],["monk",2.0],["historian",1.0]], Traits=[["brave",3.0],["bright",1.0],["optimist",1.0]], NegativeTraits=[["fainthearted",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_berserker", Name="Berserker", Fantasy="kill-chain rage melee",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,68)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[75,1.5],[68,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[135,3.0],[115,2.0],[100,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"TieBreaker",[[100,1.5],[85,1.0]])],
	Backgrounds=[["barbarian",3.0],["raider",2.0],["hedge_knight",2.0]], Traits=[["bloodthirsty",2.0],["iron_lungs",2.0],["strong",1.5]], NegativeTraits=[["fainthearted",-2.0],["fragile",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_blackguard", Name="Blackguard", Fantasy="isolated heavy fear fighter",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,70)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[70,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Secondary",[[60,2.0],[50,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"TieBreaker",[[30,1.5],[20,1.0]]),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[110,1.0]])],
	Backgrounds=[["deserter",3.0],["raider",2.0],["hedge_knight",2.0],["sellsword",1.5]], Traits=[["brave",2.0],["bloodthirsty",1.5],["iron_lungs",1.0]], NegativeTraits=[["fainthearted",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_blueblood", Name="Blueblood", Fantasy="confident noble sword fighter and trait amplifier",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[88,3.0],[80,2.0],[70,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Primary",[[60,3.0],[50,2.0],[42,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"TieBreaker",[[30,1.0],[20,0.5]])],
	Backgrounds=[["adventurous_noble",3.0],["disowned_noble",3.0],["regent",3.0],["noble",2.0],["squire",1.5]], Traits=[["brave",2.0],["determined",2.0],["confident",2.0]], NegativeTraits=[["fainthearted",-3.0],["dastard",-3.0],["insecure",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_braggart", Name="Braggart", Fantasy="challenge and ego fighter",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,68)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[75,1.5],[68,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Primary",[[60,3.0],[50,2.0],[42,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"TieBreaker",[[90,1.0]])],
	Backgrounds=[["gladiator",3.0],["raider",2.0],["adventurous_noble",2.0]], Traits=[["cocky",3.0],["brave",2.0],["bloodthirsty",1.0]], NegativeTraits=[["dastard",-3.0],["fainthearted",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_brawler", Name="Brawler", Fantasy="unarmed martial fighter",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,65)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[88,3.0],[80,2.0],[70,1.5],[65,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"Secondary",[[120,2.0],[100,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[120,2.0],[100,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"TieBreaker",[[25,1.0]])],
	Backgrounds=[["brawler",3.0],["graverobber",1.0],["farmhand",1.0]], Traits=[["strong",2.0],["athletic",2.0],["iron_lungs",1.5]], NegativeTraits=[["clumsy",-3.0],["fragile",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_brute", Name="Brute", Fantasy="high-impact armor-breaking bruiser",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,70)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[70,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"Secondary",[[110,3.0],[95,2.0],[80,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[130,3.0],[110,2.0],[95,1.0]],0.5)],
	Backgrounds=[["hedge_knight",3.0],["lumberjack",2.0],["farmhand",1.5],["mason",1.0]], Traits=[["brute",3.0],["strong",3.0],["iron_lungs",2.0]], NegativeTraits=[["tiny",-3.0],["weak",-3.0],["fragile",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_conqueror", Name="Conqueror", Fantasy="armored-target breaker and morale pressure",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,72)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[72,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Primary",[[65,3.0],[55,2.0],[45,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[125,2.0],[105,1.0]])],
	Backgrounds=[["hedge_knight",3.0],["sellsword",2.0],["officer",2.0],["raider",1.5],["noble",1.0]], Traits=[["brave",2.0],["determined",2.0],["bloodthirsty",1.5]], NegativeTraits=[["fainthearted",-3.0],["dastard",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_devout", Name="Devout", Fantasy="faith and resolve mace-hammer fighter",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Primary",[[65,3.0],[55,2.0],[45,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Secondary",[[85,2.0],[75,1.5],[68,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"TieBreaker",[[25,1.0]])],
	Backgrounds=[["monk",3.0],["cultist",3.0],["crusader",3.0],["flagellant",1.5]], Traits=[["brave",2.0],["determined",2.0],["superstitious",1.0]], NegativeTraits=[["fainthearted",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_dragon", Name="Dragon", Fantasy="close-range handgonne fear fighter",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.RangedSkill,70)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.RangedSkill,"Primary",[[90,3.0],[80,2.0],[70,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Secondary",[[60,2.0],[50,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"TieBreaker",[[90,1.0]]),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"TieBreaker",[[110,1.0]])],
	Backgrounds=[["southern",3.0],["nomad",2.0],["gladiator",1.5]], Traits=[["eagle_eyes",2.0],["brave",2.0],["swift",1.0]], NegativeTraits=[["short_sighted",-3.0],["fainthearted",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_duelist", Name="Duelist", Fantasy="one-handed sword tempo fighter",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,74)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[92,3.0],[84,2.0],[74,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"Secondary",[[35,2.0],[25,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"Secondary",[[120,2.0],[100,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[110,1.0]])],
	Backgrounds=[["swordmaster",3.0],["assassin",3.0],["sellsword",2.0]], Traits=[["dexterous",3.0],["swift",2.0],["athletic",1.0]], NegativeTraits=[["clumsy",-3.0],["slow",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_executioner", Name="Executioner", Fantasy="injury and cleaver finisher",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,70)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[70,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[125,2.0],[105,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"TieBreaker",[[90,1.0]])],
	Backgrounds=[["butcher",3.0],["killer",3.0],["raider",2.0],["executioner",3.0]], Traits=[["bloodthirsty",3.0],["brute",2.0],["strong",1.5]], NegativeTraits=[["compassionate",-3.0],["clumsy",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_fencer", Name="Fencer", Fantasy="initiative sword counterattacker",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.Initiative,115),::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,72)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Initiative,"Primary",[[140,3.0],[130,2.5],[115,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[92,3.0],[84,2.0],[72,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"TieBreaker",[[30,1.0]],0.25)],
	Backgrounds=[["swordmaster",3.0],["assassin",3.0],["thief",2.0]], Traits=[["swift",3.0],["dexterous",2.0],["athletic",1.5]], NegativeTraits=[["slow",-3.0],["clumsy",-3.0],["fat",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_flagellant", Name="Flagellant", Fantasy="pain and injury attrition",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"Primary",[[115,3.0],[100,2.0],[85,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Primary",[[65,2.0],[50,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[110,1.0]]),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"TieBreaker",[[25,0.5]])],
	Backgrounds=[["flagellant",3.0],["monk",1.5],["cultist",1.5]], Traits=[["tough",3.0],["iron_jaw",2.0],["brave",1.0]], NegativeTraits=[["fragile",-3.0],["ailing",-3.0],["fainthearted",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_gladiator", Name="Gladiator", Fantasy="surrounded showman with throwing and nets",
	Stats=[::Brotherhood.wheelStat("BestAttack","Primary",[[90,3.0],[82,2.0],[72,1.0]],0.0),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"Primary",[[35,2.0],[25,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[125,2.0],[105,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"TieBreaker",[[95,1.0]])],
	Backgrounds=[["gladiator",3.0],["juggler",2.0],["sellsword",1.0]], Traits=[["brave",2.0],["athletic",1.5],["iron_lungs",1.5]], NegativeTraits=[["fainthearted",-3.0],["fragile",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_hunter", Name="Hunter", Fantasy="versatile ranged hunter",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.RangedSkill,70)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.RangedSkill,"Primary",[[92,3.0],[82,2.0],[70,1.5]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"TieBreaker",[[115,1.0]]),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[105,1.0]])],
	Backgrounds=[["hunter",3.0],["poacher",3.0],["beast_hunter",2.0],["bowyer",1.5]], Traits=[["eagle_eyes",3.0],["sure_shot",2.0],["swift",1.0]], NegativeTraits=[["short_sighted",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_impish", Name="Impish", Fantasy="evasive zone-control trickster",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Initiative,"Primary",[[140,3.0],[125,2.0],[105,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"Secondary",[[35,2.0],[25,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"TieBreaker",[[78,0.5]])],
	Backgrounds=[["thief",3.0],["ratcatcher",2.0],["juggler",2.0]], Traits=[["swift",3.0],["tiny",2.0],["athletic",1.0]], NegativeTraits=[["slow",-3.0],["fat",-2.0],["clumsy",-1.5]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_improviser", Name="Improviser", Fantasy="item and support generalist",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[120,1.5],[100,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"TieBreaker",[[50,0.5]])],
	Backgrounds=[["peddler",3.0],["caravan_hand",2.0],["servant",1.5],["ratcatcher",1.0]], Traits=[["athletic",1.5],["bright",1.0],["iron_lungs",1.0]], NegativeTraits=[["asthmatic",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_knave", Name="Knave", Fantasy="dagger and misdirection thief",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,68)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[72,1.5],[68,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"Primary",[[135,3.0],[120,2.0],[100,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"TieBreaker",[[30,1.0]])],
	Backgrounds=[["thief",3.0],["assassin",3.0],["killer",2.0],["servant",1.0]], Traits=[["dexterous",3.0],["swift",2.0],["tiny",1.0]], NegativeTraits=[["clumsy",-3.0],["slow",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_man_at_arms", Name="Man-At-Arms", Fantasy="shielded multiweapon veteran",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[90,3.0],[82,2.0],[72,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"Primary",[[38,3.0],[30,2.0],[20,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[130,2.0],[110,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"TieBreaker",[[50,0.5]])],
	Backgrounds=[["retired_soldier",3.0],["militia",2.0],["sellsword",2.0],["squire",2.0],["hedge_knight",1.5]], Traits=[["sure_footing",2.0],["iron_lungs",1.5],["strong",1.0]], NegativeTraits=[["clumsy",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_marksman", Name="Marksman", Fantasy="precision bow and crossbow shooter",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.RangedSkill,70)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.RangedSkill,"Primary",[[95,3.0],[85,2.0],[75,1.5],[70,1.0]],1.0),::Brotherhood.wheelStat(::Const.Attributes.RangedDefense,"TieBreaker",[[20,0.5]]),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"TieBreaker",[[110,0.5]])],
	Backgrounds=[["hunter",3.0],["poacher",3.0],["bowyer",2.0],["sellsword",1.0]], Traits=[["eagle_eyes",3.0],["sure_shot",2.0]], NegativeTraits=[["short_sighted",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_nobody", Name="Nobody", Fantasy="weak-recruit potential lottery", BaseWeight=0.75,
	Stats=[::Brotherhood.wheelStat("LowProjectedTotal","Primary",[[180,3.0],[120,2.0],[60,1.0]]),::Brotherhood.wheelStat("LowTotalStars","Secondary",[[7,2.0],[5,1.0]])],
	Backgrounds=[["beggar",3.0],["cripple",3.0],["daytaler",2.0],["refugee",2.0],["servant",1.0]], Traits=[["bright",1.0],["optimist",1.0]], NegativeTraits=[["talented",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_opportunist", Name="Opportunist", Fantasy="late-action flexible exploiter",
	Stats=[::Brotherhood.wheelStat("BestAttack","Secondary",[[88,2.0],[78,1.0]],0.0),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[120,2.0],[100,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"TieBreaker",[[0,0.5]])],
	Backgrounds=[["gambler",3.0],["thief",2.0],["peddler",1.5]], Traits=[["patient",2.0],["iron_lungs",1.0]], NegativeTraits=[["impatient",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_plague_doctor", Name="Plague Doctor", Fantasy="medicine and injury support",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Bravery,"Primary",[[60,2.0],[50,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"Secondary",[[100,1.5],[85,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[110,1.0]]),::Brotherhood.wheelStat("BestAttack","TieBreaker",[[82,1.0],[72,0.5]])],
	Backgrounds=[["anatomist",3.0],["monk",2.0],["historian",2.0],["apothecary",2.0]], Traits=[["bright",3.0],["determined",1.0]], NegativeTraits=[["dumb",-3.0],["ailing",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_prodigy", Name="Prodigy", Fantasy="accelerated learner and stat growth",
	Stats=[::Brotherhood.wheelStat("TotalStars","Primary",[[8,3.0],[6,2.0],[4,1.0]]),::Brotherhood.wheelStat("LowProjectedTotal","TieBreaker",[[120,1.0],[60,0.5]])],
	Backgrounds=[["apprentice",3.0],["historian",2.0],["student",2.0],["monk",1.0]], Traits=[["bright",3.0],["talented",3.0]], NegativeTraits=[["dumb",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_strongman", Name="Strongman", Fantasy="durable armor and stun anchor",
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.Hitpoints,"Primary",[[120,3.0],[105,2.0],[90,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Primary",[[140,3.0],[120,2.0],[105,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"Secondary",[[35,2.0],[25,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"TieBreaker",[[78,0.5]])],
	Backgrounds=[["farmhand",3.0],["lumberjack",3.0],["mason",2.0],["hedge_knight",2.0]], Traits=[["strong",3.0],["tough",2.0],["iron_lungs",2.0],["huge",1.5]], NegativeTraits=[["weak",-3.0],["fragile",-3.0],["tiny",-2.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_swashbuckler", Name="Swashbuckler", Fantasy="mobile sword showman",
	Requirements=[::Brotherhood.wheelRequirement(::Const.Attributes.MeleeSkill,70)],
	Stats=[::Brotherhood.wheelStat(::Const.Attributes.MeleeSkill,"Primary",[[92,3.0],[84,2.0],[76,1.5],[70,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"Primary",[[140,3.0],[120,2.0],[100,1.0]],0.75),::Brotherhood.wheelStat(::Const.Attributes.MeleeDefense,"Secondary",[[35,2.0],[25,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"TieBreaker",[[110,1.0]])],
	Backgrounds=[["swordmaster",3.0],["assassin",2.0],["juggler",2.0],["sellsword",1.0]], Traits=[["swift",3.0],["dexterous",2.0],["athletic",1.0]], NegativeTraits=[["slow",-3.0],["clumsy",-3.0]]
});

::Brotherhood.addWheelProfile({
	ID="pg.bh_wildling", Name="Wildling", Fantasy="mobile isolated throwing-melee hybrid",
	Stats=[::Brotherhood.wheelStat("BestAttack","Primary",[[90,3.0],[82,2.0],[72,1.0]]),::Brotherhood.wheelStat(::Const.Attributes.Fatigue,"Secondary",[[130,2.0],[110,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Initiative,"Secondary",[[125,2.0],[105,1.0]],0.5),::Brotherhood.wheelStat(::Const.Attributes.Bravery,"TieBreaker",[[50,0.5]])],
	Backgrounds=[["wildman",3.0],["barbarian",3.0],["beast_hunter",2.0],["hunter",1.0]], Traits=[["athletic",2.0],["iron_lungs",2.0],["eagle_eyes",1.0]], NegativeTraits=[["asthmatic",-2.0]]
});
