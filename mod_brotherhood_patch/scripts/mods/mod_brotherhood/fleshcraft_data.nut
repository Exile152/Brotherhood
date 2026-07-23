// Authored parent content only. Selection/scoring belongs to parent_resolver;
// generic half construction belongs to fleshcraft_engine.
::Brotherhood.FleshcraftTemplates <- {};
::Brotherhood.DormantFleshcraftParentIDs <- { ["dancer"] = true };
::Brotherhood.FleshcraftParentRegistry <- [];
::Brotherhood.FleshcraftPerkMeta <- {};
::Brotherhood.FleshcraftBackgroundMeta <- {};
::Brotherhood.FleshcraftPerkTiers <- {};
::Brotherhood.FleshcraftPatchUpPerks <- ["perk.bh_student", "perk.bh_gifted", "perk.bh_fine_balance", "perk.bh_fundamentals"];

::Brotherhood.addFleshcraftPerkData <- function( _id, _tier, _familyPlus = null, _familyMinus = null, _fitPredicate = null )
{
	if (_id in ::Brotherhood.FleshcraftPerkTiers && ::Brotherhood.FleshcraftPerkTiers[_id] != _tier) throw "Brotherhood Fleshcraft perk has conflicting authored tiers: " + _id;
	::Brotherhood.FleshcraftPerkTiers[_id] <- _tier;
	::Brotherhood.FleshcraftPerkMeta[_id] <- { family_plus=_familyPlus, family_minus=_familyMinus, fit_predicate=_fitPredicate };
}

// Shared, vanilla, Reforged, and already-implemented Brotherhood material.
::Brotherhood.addFleshcraftPerkData("perk.pathfinder", 1, "cunning", "noble");
::Brotherhood.addFleshcraftPerkData("perk.bags_and_belts", 1);
::Brotherhood.addFleshcraftPerkData("perk.bh_small_head", 1);
::Brotherhood.addFleshcraftPerkData("perk.bh_fast_adaptation", 1, "scholar");
::Brotherhood.addFleshcraftPerkData("perk.bh_crippling_strikes", 1, "cunning");
::Brotherhood.addFleshcraftPerkData("perk.fortified_mind", 2, "scholar");
::Brotherhood.addFleshcraftPerkData("perk.bh_quick_hands", 2, "cunning");
::Brotherhood.addFleshcraftPerkData("perk.steel_brow", 2, "soldier");
::Brotherhood.addFleshcraftPerkData("perk.bh_executioner", 2, "barbarian");
::Brotherhood.addFleshcraftPerkData("perk.bh_bullseye", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_feint", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_easy_target", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_examination", 2);
::Brotherhood.addFleshcraftPerkData("perk.dodge", 2, "cunning");
::Brotherhood.addFleshcraftPerkData("perk.brawny", 3, "soldier", "cunning");
::Brotherhood.addFleshcraftPerkData("perk.bh_steady_rhythm", 3, "soldier");
::Brotherhood.addFleshcraftPerkData("perk.bh_lightweight", 3, "cunning");
::Brotherhood.addFleshcraftPerkData("perk.bh_relentless", 3, "barbarian");
::Brotherhood.addFleshcraftPerkData("perk.bh_pursuer", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_ghost_pain", 3, "scholar");
::Brotherhood.addFleshcraftPerkData("perk.bh_torture", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_shock", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_hammer_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_mace_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_axe_mastery", 4, null, "scholar");
::Brotherhood.addFleshcraftPerkData("perk.bh_cleaver_mastery", 4, "barbarian");
::Brotherhood.addFleshcraftPerkData("perk.bh_sword_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_dagger_mastery", 4, "cunning");
::Brotherhood.addFleshcraftPerkData("perk.bh_bow_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_underdog", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_disrupt", 5, "barbarian");
::Brotherhood.addFleshcraftPerkData("perk.bh_lunge", 5, "barbarian");
::Brotherhood.addFleshcraftPerkData("perk.bh_overwhelm", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_perfect_thrust", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_footwork", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_medieval_medicine", 5);
::Brotherhood.addFleshcraftPerkData("perk.berserk", 6, "barbarian");
::Brotherhood.addFleshcraftPerkData("perk.head_hunter", 6, "cunning");
::Brotherhood.addFleshcraftPerkData("perk.bh_finesse", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_crimson", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_duelist", 7);
::Brotherhood.addFleshcraftPerkData("perk.killing_frenzy", 7, "barbarian");
::Brotherhood.addFleshcraftPerkData("perk.bh_flow_state", 7);
::Brotherhood.addFleshcraftPerkData("perk.bh_outmatched", 7);
::Brotherhood.addFleshcraftPerkData("perk.bh_fearsome", 7, "barbarian", "cunning");

// Newly authored current parent material.
::Brotherhood.addFleshcraftPerkData("perk.bh_preparation", 1);
::Brotherhood.addFleshcraftPerkData("perk.bh_bloodloaded", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_desperation", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_porcupine", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_versatile_defense", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_juggling_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_skirmishing_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_volley_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_asymmetry", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_exceptional_skill", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_malice", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_omnivorous", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_steady_aim", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_windreaver", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_cooking_up_trouble", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_distracted", 7);
::Brotherhood.addFleshcraftPerkData("perk.bh_over_dexterous", 7);

// Batch 2 parent material.
::Brotherhood.addFleshcraftPerkData("perk.bh_bully", 1);
::Brotherhood.addFleshcraftPerkData("perk.bh_acuity", 1);
::Brotherhood.addFleshcraftPerkData("perk.bh_unadaptive_opening", 1);
::Brotherhood.addFleshcraftPerkData("perk.bh_determination", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_off_guard", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_anticipation", 3);
::Brotherhood.addFleshcraftPerkData("perk.rally_the_troops", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_lead_by_example", 3);
::Brotherhood.addFleshcraftPerkData("perk.rotation", 3);
::Brotherhood.addFleshcraftPerkData("perk.taunt", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_heavyweight", 3);
::Brotherhood.addFleshcraftPerkData("perk.bh_polearm_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_shield_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_gunpowder_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_crossbow_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_consumable_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_spear_mastery", 4);
::Brotherhood.addFleshcraftPerkData("perk.bh_breach", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_twin_discipline", 5);
::Brotherhood.addFleshcraftPerkData("perk.bh_snapping_turtle", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_sentinel", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_nidhogg", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_ragnarok", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_aerial_dance", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_bladed_loop", 6);
::Brotherhood.addFleshcraftPerkData("perk.bh_overkill", 7);
::Brotherhood.addFleshcraftPerkData("perk.bh_nerves_of_steel", 7);
::Brotherhood.addFleshcraftPerkData("perk.bh_zenith", 7);
::Brotherhood.addFleshcraftPerkData("perk.bh_opening_metal", 7);
::Brotherhood.addFleshcraftPerkData("perk.bh_aimed_sloth", 7);
::Brotherhood.addFleshcraftPerkData("perk.indomitable", 7);

// Universal Patch Up. Forbidden inside every parent template by validation.
::Brotherhood.addFleshcraftPerkData("perk.bh_student", 1, "scholar");
::Brotherhood.addFleshcraftPerkData("perk.bh_gifted", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_fine_balance", 2);
::Brotherhood.addFleshcraftPerkData("perk.bh_fundamentals", 2, "soldier");

::Brotherhood.FleshcraftTemplates["archer"] <- {
	id="archer", name="Archer",
	spine_pool=["perk.bh_bow_mastery", "perk.bh_porcupine", "perk.bh_windreaver"],
	flesh_pool=["perk.bh_desperation", "perk.bh_executioner", "perk.bh_fast_adaptation", "perk.bh_bullseye", "perk.bh_small_head", "perk.berserk", "perk.head_hunter", "perk.killing_frenzy", "perk.bh_steady_aim", "perk.bh_exceptional_skill"],
	seats=[
		{ id="precision", candidates=["perk.bh_small_head", "perk.bh_bullseye"] },
		{ id="damage", candidates=["perk.bh_executioner", "perk.bh_desperation"] },
		{ id="kill_reward", candidates=["perk.killing_frenzy", "perk.berserk"] }
	], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["duelist"] <- {
	id="duelist", name="Duelist",
	spine_pool=["perk.bh_flow_state", "perk.bh_duelist", "perk.bh_outmatched"],
	flesh_pool=["perk.bh_fast_adaptation", "perk.pathfinder", "perk.bh_executioner", "perk.dodge", "perk.bh_lightweight", "perk.bh_pursuer", "perk.bh_finesse", "perk.bh_mace_mastery", "perk.bh_sword_mastery", "perk.bh_axe_mastery", "perk.bh_cleaver_mastery"],
	seats=[
		{ id="damage", candidates=["perk.bh_executioner", "perk.bh_lightweight"] },
		{ id="mastery", candidates=["perk.bh_mace_mastery", "perk.bh_sword_mastery", "perk.bh_axe_mastery", "perk.bh_cleaver_mastery"] }
	], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["hybrid"] <- {
	id="hybrid", name="Hybrid",
	spine_pool=["perk.bh_asymmetry", "perk.bh_omnivorous", "perk.bh_malice"],
	flesh_pool=["perk.bh_quick_hands", "perk.bags_and_belts", "perk.bh_fast_adaptation", "perk.bh_bloodloaded", "perk.bh_cooking_up_trouble", "perk.bh_versatile_defense", "perk.bh_over_dexterous", "perk.bh_easy_target"],
	seats=[{ id="chance_to_hit", candidates=["perk.bh_easy_target", "perk.bh_fast_adaptation"] }], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["injury_specialist"] <- {
	id="injury_specialist", name="Injury Specialist",
	spine_pool=["perk.bh_crippling_strikes", "perk.bh_medieval_medicine", "perk.bh_crimson"],
	flesh_pool=["perk.bh_easy_target", "perk.bh_examination", "perk.bh_executioner", "perk.bh_quick_hands", "perk.bh_ghost_pain", "perk.bh_torture", "perk.bh_shock", "perk.bh_cleaver_mastery", "perk.bh_axe_mastery"],
	seats=[
		{ id="chance_to_hit", candidates=["perk.bh_examination", "perk.bh_easy_target"] },
		{ id="mastery", candidates=["perk.bh_cleaver_mastery", "perk.bh_axe_mastery"] }
	], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["pure_thrower"] <- {
	id="pure_thrower", name="Pure Thrower",
	spine_pool=["perk.bh_skirmishing_mastery", "perk.bh_volley_mastery", "perk.bh_juggling_mastery"],
	flesh_pool=["perk.bh_quick_hands", "perk.bags_and_belts", "perk.bh_fast_adaptation", "perk.bh_desperation", "perk.bh_preparation", "perk.bh_distracted", "perk.bh_footwork"],
	seats=[], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["qatal_duelist"] <- {
	id="qatal_duelist", name="Qatal Duelist",
	spine_pool=["perk.bh_overwhelm", "perk.bh_perfect_thrust", "perk.bh_dagger_mastery"],
	flesh_pool=["perk.bh_fast_adaptation", "perk.dodge", "perk.bh_executioner", "perk.bh_feint", "perk.bh_lightweight", "perk.bh_relentless", "perk.berserk", "perk.head_hunter", "perk.bh_duelist", "perk.killing_frenzy"],
	seats=[
		{ id="damage", candidates=["perk.bh_lightweight", "perk.bh_executioner"] },
		{ id="miss_economy", candidates=["perk.bh_feint", "perk.bh_fast_adaptation"] },
		{ id="kill_reward", candidates=["perk.killing_frenzy", "perk.berserk"] }
	], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["support_frontliner"] <- {
	id="support_frontliner", name="Support Frontliner",
	spine_pool=["perk.bh_steady_rhythm", "perk.bh_hammer_mastery", "perk.bh_mace_mastery", "perk.bh_axe_mastery"],
	flesh_pool=["perk.pathfinder", "perk.fortified_mind", "perk.bh_executioner", "perk.bh_quick_hands", "perk.steel_brow", "perk.brawny", "perk.bh_underdog", "perk.bh_disrupt", "perk.bh_lunge", "perk.bh_fearsome"],
	seats=[
		{ id="weapon_choice", candidates=["perk.bh_hammer_mastery", "perk.bh_mace_mastery", "perk.bh_axe_mastery"] },
		{ id="no_damage_function", candidates=["perk.bh_disrupt", "perk.bh_fearsome"] },
		{ id="gap_closer", candidates=["perk.bh_lunge", "perk.bh_quick_hands"] }
	], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["attack_banner"] <- {
	id="attack_banner", name="Attack Banner",
	spine_pool=["perk.rally_the_troops", "perk.bh_lead_by_example", "perk.bh_polearm_mastery"],
	flesh_pool=["perk.fortified_mind", "perk.bh_determination", "perk.bh_anticipation", "perk.bh_bully", "perk.bh_breach", "perk.berserk", "perk.bh_fearsome"],
	seats=[], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["tank_banner"] <- {
	id="tank_banner", name="Tank Banner",
	spine_pool=["perk.rally_the_troops", "perk.bh_snapping_turtle", "perk.bh_nerves_of_steel"],
	flesh_pool=["perk.bh_shield_mastery", "perk.rotation", "perk.fortified_mind", "perk.bh_determination", "perk.brawny", "perk.taunt", "perk.indomitable"],
	seats=[], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["tank"] <- {
	id="tank", name="Tank",
	spine_pool=["perk.taunt", "perk.bh_sentinel", "perk.indomitable"],
	flesh_pool=["perk.bh_shield_mastery", "perk.bh_underdog", "perk.fortified_mind", "perk.pathfinder", "perk.steel_brow", "perk.brawny", "perk.rotation"],
	seats=[], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["dancer"] <- {
	id="dancer", name="Dancer",
	// Dormant parent: kept for save compatibility; not in FleshcraftParentRegistry.
	spine_pool=["perk.bh_twin_discipline", "perk.bh_zenith"],
	flesh_pool=["perk.dodge", "perk.bh_lightweight", "perk.bh_relentless", "perk.bh_pursuer", "perk.bh_lunge", "perk.bh_acuity", "perk.bh_aerial_dance"],
	seats=[], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["fatigue_carry"] <- {
	id="fatigue_carry", name="Fatigue Carry",
	spine_pool=["perk.berserk", "perk.bh_nidhogg", "perk.bh_ragnarok"],
	flesh_pool=["perk.bh_lunge", "perk.steel_brow", "perk.brawny", "perk.bh_pursuer", "perk.bh_heavyweight", "perk.bh_cleaver_mastery", "perk.bh_axe_mastery", "perk.bh_mace_mastery", "perk.bh_sword_mastery", "perk.bh_hammer_mastery", "perk.killing_frenzy", "perk.bh_overkill"],
	seats=[
		{ id="mastery", candidates=["perk.bh_cleaver_mastery", "perk.bh_axe_mastery", "perk.bh_mace_mastery", "perk.bh_sword_mastery", "perk.bh_hammer_mastery"] },
		{ id="damage", candidates=["perk.killing_frenzy", "perk.bh_overkill"] }
	], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["reload_ranged"] <- {
	id="reload_ranged", name="Reload Ranged",
	spine_pool=["perk.bh_gunpowder_mastery", "perk.bh_crossbow_mastery", "perk.bh_consumable_mastery"],
	flesh_pool=["perk.bh_exceptional_skill", "perk.bh_overwhelm", "perk.bh_fearsome", "perk.bh_desperation", "perk.bh_preparation", "perk.bags_and_belts", "perk.bh_unadaptive_opening", "perk.bh_footwork"],
	seats=[{ id="utility", candidates=["perk.bh_overwhelm", "perk.bh_fearsome"] }], parent_fit_hooks={}
};

::Brotherhood.FleshcraftTemplates["tempo"] <- {
	id="tempo", name="Tempo",
	spine_pool=["perk.bh_opening_metal", "perk.bh_fearsome", "perk.bh_aimed_sloth"],
	flesh_pool=["perk.bh_fast_adaptation", "perk.bh_easy_target", "perk.dodge", "perk.pathfinder", "perk.bh_unadaptive_opening", "perk.bh_off_guard", "perk.steel_brow", "perk.rotation", "perk.bh_heavyweight", "perk.bh_lightweight", "perk.bh_sword_mastery", "perk.bh_spear_mastery"],
	seats=[
		{ id="chance_to_hit", candidates=["perk.bh_easy_target", "perk.bh_off_guard", "perk.bh_unadaptive_opening"] },
		{ id="weapon_weight", candidates=["perk.rotation", "perk.bh_heavyweight", "perk.bh_lightweight"] },
		{ id="mastery", candidates=["perk.bh_sword_mastery", "perk.bh_spear_mastery"] }
	], parent_fit_hooks={}
};

::Brotherhood.FleshcraftParentRegistry = [
	{ ID="archer", Name="Archer" },
	{ ID="duelist", Name="Duelist" },
	{ ID="hybrid", Name="Hybrid" },
	{ ID="injury_specialist", Name="Injury Specialist" },
	{ ID="pure_thrower", Name="Pure Thrower" },
	{ ID="qatal_duelist", Name="Qatal Duelist" },
	{ ID="support_frontliner", Name="Support Frontliner" },
	{ ID="attack_banner", Name="Attack Banner" },
	{ ID="tank_banner", Name="Tank Banner" },
	{ ID="tank", Name="Tank" },
	{ ID="fatigue_carry", Name="Fatigue Carry" },
	{ ID="reload_ranged", Name="Reload Ranged" },
	{ ID="tempo", Name="Tempo" }
];
