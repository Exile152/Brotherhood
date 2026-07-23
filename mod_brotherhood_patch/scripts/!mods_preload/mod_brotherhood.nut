::Brotherhood <- {
	Version = "0.2.96",
	ID = "mod_brotherhood",
	Name = "Brotherhood",
	Mod = null,
	CustomItemSwapping = false,
	TestingMode = true,
	// Log current Obsidian perks to Documents/Battle Brothers/log.html.
	// The exact live allowlist is defined in active_obsidian_perks.nut.
	PerkDebugLogging = true,
	PerkDebugMirrorToCombatLog = false,
	// The real Fleshcraft generator replaces Reforged player perk-tree rolls.
	// Disable this one flag to restore Reforged generation without touching data.
	FleshcraftGenerationEnabled = true,
	// Temporary integration controls. Parent generation remains live, while
	// Wild, Chaos, and the untracked Armor Doctrine layer stay dormant.
	WildGenerationEnabled = false,
	ChaosGenerationEnabled = false,
	ArmorDoctrineGenerationEnabled = false,
	ParentGenerationDebugLogging = true,
	ParentGenerationDetailedDebugLogging = true,
	ParentGenerationDebugShowOnCharacter = true,
	ParentGenerationRunParityFixture = true,
	// Legacy blank-slate recruiting test: beggar-only backgrounds with no
	// traits or talent stars. Keep this off while retaining other debug hooks.
	OldBlankSlateTesting = false,
	// Fleshcraft seat/tree diagnostics. Parent selection itself is never forced.
	FleshcraftDebugLogging = true,
	// Archetypes and their Wheel/Wild/Chaos output are dormant. Survivability,
	// Armor Doctrines, and Debug are deliberately independent and remain active.
	ArchetypesEnabled = false,
	EnabledArchetypeIDs = [
		"pg.bh_artillerist", "pg.bh_bard", "pg.bh_berserker", "pg.bh_blackguard", "pg.bh_blueblood",
		"pg.bh_braggart", "pg.bh_brawler", "pg.bh_brute", "pg.bh_conqueror", "pg.bh_devout",
		"pg.bh_dragon", "pg.bh_duelist", "pg.bh_executioner", "pg.bh_fencer", "pg.bh_flagellant",
		"pg.bh_gladiator", "pg.bh_hunter", "pg.bh_impish", "pg.bh_improviser", "pg.bh_knave",
		"pg.bh_man_at_arms", "pg.bh_marksman", "pg.bh_nobody", "pg.bh_opportunist", "pg.bh_plague_doctor",
		"pg.bh_prodigy", "pg.bh_strongman", "pg.bh_swashbuckler", "pg.bh_wildling"
	],
	// Debug-only: every newly generated test beggar receives the current
	// Obsidian archetypes. Their new DUOs are injected directly for testing.
	// Set this to false to restore the random five-archetype test pool.
	DebugForceCurrentObsidianArchetypes = false,
	// Legacy Marksman branch testing is disabled for this debug spawn.
	DebugIncludeBothMarksmanMasteries = false,
	AddTestingGearOnStart = false,
	SpeedsterActionPointThreshold = 7
};

::Brotherhood.HooksMod <- ::Hooks.register(::Brotherhood.ID, ::Brotherhood.Version, ::Brotherhood.Name);
::Brotherhood.HooksMod.require([
	"mod_msu >= 1.9.0",
	"mod_modern_hooks >= 0.4.10",
	"mod_reforged >= 0.9.2"
]);

::Brotherhood.isCustomItemSwappingEnabled <- function()
{
	if (::Brotherhood.Mod == null || ::MSU.isNull(::Brotherhood.Mod)) return ::Brotherhood.CustomItemSwapping;
	local setting = ::Brotherhood.Mod.ModSettings.getSetting("CustomItemSwapping");
	return setting == null ? ::Brotherhood.CustomItemSwapping : setting.getValue();
}

// Reforged adjusts many weapon-skill costs per weapon when the skill is added.
// Normalize at item.addSkill so those final per-weapon adjustments are replaced
// while later vanilla mechanics (mastery and FatigueOnSkillUse) still apply.
::Brotherhood.VanillaWeaponSkillCosts <- {};
::Brotherhood.VanillaWeaponSkillCosts["actives.aimed_shot"] <- [7, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.assault"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.bash"] <- [4, 13];
::Brotherhood.VanillaWeaponSkillCosts["actives.batter"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.cascade"] <- [4, 13];
::Brotherhood.VanillaWeaponSkillCosts["actives.censer_castigate"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.censer_strike"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.chop"] <- [4, 13];
::Brotherhood.VanillaWeaponSkillCosts["actives.cleave"] <- [4, 12];
::Brotherhood.VanillaWeaponSkillCosts["actives.coat_with_poison"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.coat_with_spider_poison"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.crumble"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.crush_armor"] <- [4, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.cudgel"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.deathblow"] <- [4, 10];
::Brotherhood.VanillaWeaponSkillCosts["actives.decapitate"] <- [4, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.demolish_armor"] <- [6, 35];
::Brotherhood.VanillaWeaponSkillCosts["actives.disarm"] <- [5, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.estoc_stab"] <- [5, 11];
::Brotherhood.VanillaWeaponSkillCosts["actives.execute"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.exesword_decapitate"] <- [6, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.fire_handgonne"] <- [3, 5];
::Brotherhood.VanillaWeaponSkillCosts["actives.fire_mortar"] <- [6, 0];
::Brotherhood.VanillaWeaponSkillCosts["actives.flail"] <- [4, 13];
::Brotherhood.VanillaWeaponSkillCosts["actives.flesh_pull"] <- [6, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.gash"] <- [4, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.goblin_whip"] <- [3, 5];
::Brotherhood.VanillaWeaponSkillCosts["actives.hail"] <- [4, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.hammer"] <- [4, 14];
::Brotherhood.VanillaWeaponSkillCosts["actives.hook"] <- [6, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.ignite_firelance"] <- [4, 5];
::Brotherhood.VanillaWeaponSkillCosts["actives.impale"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.knock_out"] <- [4, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.knock_over"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.lash"] <- [4, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.lunge"] <- [4, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.overhead_strike"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.perforate"] <- [6, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.pound"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.prong"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.puncture"] <- [4, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.quick_shot"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.reap"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.reload_bolt"] <- [4, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.reload_handgonne"] <- [9, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.repel"] <- [6, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.riposte"] <- [2, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.round_swing"] <- [6, 35];
::Brotherhood.VanillaWeaponSkillCosts["actives.rupture"] <- [5, 12];
::Brotherhood.VanillaWeaponSkillCosts["actives.serpent_hook"] <- [6, 20];
::Brotherhood.VanillaWeaponSkillCosts["actives.shatter"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.shoot_bolt"] <- [3, 5];
::Brotherhood.VanillaWeaponSkillCosts["actives.shoot_stake"] <- [3, 5];
::Brotherhood.VanillaWeaponSkillCosts["actives.skewer"] <- [6, 25];
::Brotherhood.VanillaWeaponSkillCosts["actives.slash"] <- [4, 10];
::Brotherhood.VanillaWeaponSkillCosts["actives.slash_lightning"] <- [4, 10];
::Brotherhood.VanillaWeaponSkillCosts["actives.sling_stone"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.smite"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.spearwall"] <- [4, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.split"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.split_axe"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.split_man"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.split_shield"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.stab"] <- [4, 7];
::Brotherhood.VanillaWeaponSkillCosts["actives.strike"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.strike_down"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.swing"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.thresh"] <- [6, 35];
::Brotherhood.VanillaWeaponSkillCosts["actives.throw_axe"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.throw_balls"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.throw_javelin"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.throw_spear"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.thrust"] <- [4, 10];
::Brotherhood.VanillaWeaponSkillCosts["actives.whip"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.throw_net"] <- [4, 25];

// Reforged-only weapon skills use the nearest vanilla-shaped cost profile.
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_sword_thrust"] <- [4, 10];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_heavy_cleave"] <- [4, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_great_cleave"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_cleaving_split"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_cleaving_swing"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_voulge_cleave"] <- [6, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_gouge"] <- [6, 30];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_flail_pole"] <- [5, 15];
::Brotherhood.VanillaWeaponSkillCosts["actives.rf_lash_pole"] <- [5, 25];

::Brotherhood.getVanillaWeaponSkillCost <- function( _item, _skill )
{
	if (_item == null || _skill == null || !("m" in _skill) || !("ID" in _skill.m)) return null;

	local skillID = _skill.m.ID;
	if (!(skillID in ::Brotherhood.VanillaWeaponSkillCosts)) return null;

	local itemID = ("getID" in _item) ? _item.getID() : "";
	local isTwoHanded = ("isItemType" in _item) && _item.isItemType(::Const.Items.ItemType.TwoHanded);

	// Preserve vanilla's heavier two-handed variants.
	if (isTwoHanded && skillID == "actives.slash") return [4, 13];
	if (isTwoHanded && skillID == "actives.cleave") return [4, 15];
	if (isTwoHanded && skillID == "actives.spearwall") return [6, 35];
	if (isTwoHanded && skillID == "actives.split_shield") return [4, 20];

	// Preserve exact vanilla item-specific exceptions.
	if (itemID == "weapon.goedendag")
	{
		if (skillID == "actives.thrust") return [6, 15];
		if (skillID == "actives.knock_out") return [6, 30];
	}

	if (itemID == "weapon.warbrand" || itemID == "weapon.named_warbrand" || itemID == "weapon.rhomphaia")
	{
		if (skillID == "actives.split" || skillID == "actives.swing") return [5, 30];
	}

	if ((itemID == "weapon.longaxe" || itemID == "weapon.named_longaxe") && skillID == "actives.split_shield") return [4, 25];
	if ((itemID == "weapon.rf_poleaxe" || itemID == "weapon.named_rf_poleaxe") && skillID == "actives.chop") return [6, 15];
	if ((itemID == "weapon.rf_halberd" || itemID == "weapon.named_rf_halberd") && skillID == "actives.strike") return [6, 25];

	return ::Brotherhood.VanillaWeaponSkillCosts[skillID];
}

::Brotherhood.restoreVanillaWeaponSkillCost <- function( _item, _skill )
{
	local cost = ::Brotherhood.getVanillaWeaponSkillCost(_item, _skill);
	if (cost == null) return;

	local oldActionPointCost = _skill.m.ActionPointCost;
	local oldFatigueCost = _skill.m.FatigueCost;
	_skill.m.ActionPointCost = cost[0];
	_skill.m.FatigueCost = cost[1];

	if (::Brotherhood.TestingMode && (oldActionPointCost != cost[0] || oldFatigueCost != cost[1]))
	{
		::logInfo("[Brotherhood][VANILLA WEAPON COST] " + _item.getID() + " / " + _skill.m.ID + ": " + oldActionPointCost + "/" + oldFatigueCost + " -> " + cost[0] + "/" + cost[1]);
	}
}

::Brotherhood.SurvivalPerks <- [
	"perk.colossus",
	"perk.nine_lives",
	"perk.bh_mind_over_matter",
	"perk.bh_vigor"
];

::Brotherhood.BardPerks <- [
	"perk.bh_not_important"
];

::Brotherhood.MobilityPerks <- [
	"perk.pathfinder",
	"perk.bh_pursuer",
	"perk.bh_vantage",
	"perk.bh_prepared",
	"perk.bh_little_devil",
	"perk.bh_light_feet"
];

::Brotherhood.SurvivalOnlyPerks <- [
	"perk.colossus",
	"perk.nine_lives"
];

::Brotherhood.MobilityOnlyPerks <- [
];

::Brotherhood.isSurvivalOnlyPerk <- function( _perkID )
{
	return ::Brotherhood.SurvivalOnlyPerks.find(_perkID) != null;
}

::Brotherhood.isMobilityOnlyPerk <- function( _perkID )
{
	return ::Brotherhood.MobilityOnlyPerks.find(_perkID) != null;
}

::Brotherhood.getOnlyPerkGroupID <- function( _perkID )
{
	if (::Brotherhood.isSurvivalOnlyPerk(_perkID)) return "pg.bh_survival";
	if (::Brotherhood.isMobilityOnlyPerk(_perkID)) return "pg.bh_mobility";
	return null;
}

::Brotherhood.isOnlyPerk <- function( _perkID )
{
	return ::Brotherhood.getOnlyPerkGroupID(_perkID) != null;
}

::Brotherhood.keepOnlyTestingPerkGroupIDs <- function( _perkData )
{
	if (_perkData == null || !("ID" in _perkData) || !("PerkGroupIDs" in _perkData)) return;

	local groupID = ::Brotherhood.getOnlyPerkGroupID(_perkData.ID);
	if (groupID == null) return;

	_perkData.PerkGroupIDs = _perkData.PerkGroupIDs.filter(@(_, _id) _id == groupID);
	if (_perkData.PerkGroupIDs.find(groupID) == null)
	{
		_perkData.PerkGroupIDs.push(groupID);
	}
}

::Brotherhood.keepOnlySurvivalPerkGroupIDs <- ::Brotherhood.keepOnlyTestingPerkGroupIDs;

::Brotherhood.clonePerkDefWithScript <- function( _perkID, _script )
{
	local existing = ::Const.Perks.findById(_perkID);
	local ret = {};

	foreach (key, value in existing)
	{
		ret[key] <- value;
	}

	ret.Script = _script;

	if ("PerkGroupIDs" in ret) ret.PerkGroupIDs = [];
	else ret.PerkGroupIDs <- [];

	return ret;
}

::Brotherhood.stripConceptLinks <- function( _text )
{
	if (typeof _text != "string") return _text;
	local ret = "";
	local searchFrom = 0;
	while (searchFrom < _text.len())
	{
		local open = _text.find("[", searchFrom);
		if (open == null)
		{
			ret += _text.slice(searchFrom);
			break;
		}
		local separator = _text.find("|Concept.", open);
		local close = separator == null ? null : _text.find("]", separator);
		if (separator == null || close == null)
		{
			ret += _text.slice(searchFrom, open + 1);
			searchFrom = open + 1;
			continue;
		}
		ret += _text.slice(searchFrom, open) + _text.slice(open + 1, separator);
		searchFrom = close + 1;
	}
	return ret;
}

::Brotherhood.formatSurvivalPerkTooltip <- function( _definition )
{
	local definition = clone _definition;
	// Flavor text is presentation-only and must never contain clickable concepts.
	if ("Fluff" in definition) definition.Fluff = ::Brotherhood.stripConceptLinks(definition.Fluff);
	return ::Reforged.Mod.Tooltips.parseString(::UPD.getDescription(definition));
}

::Brotherhood.getSurvivalPerkTooltip <- function( _perkID )
{
	switch (_perkID)
	{
		case "perk.bh_marathoner":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "Some men are fast and some men are strong. You happened to be both.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Increases maximum [Hitpoints|Concept.Hitpoints] by " + ::MSU.Text.colorPositive("10%") + ", maximum [Fatigue|Concept.MaximumFatigue] by " + ::MSU.Text.colorPositive("5%") + ", and [Initiative|Concept.Initiative] by " + ::MSU.Text.colorPositive("5") + "."
					]
				}]
			});

		case "perk.bh_brace":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "They can't all hit you at once.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"While adjacent to three or more enemies, you take " + ::MSU.Text.colorPositive("15%") + " less damage from attacks, plus " + ::MSU.Text.colorPositive("5%") + " less for each additional adjacent enemy."
					]
				}]
			});

		case "perk.bh_sturdy":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "They can't knock you out that quickly.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"The first attack each round to damage your [Hitpoints|Concept.Hitpoints] cannot deal more than " + ::MSU.Text.colorPositive("40%") + " of your maximum [Hitpoints|Concept.Hitpoints] in damage."
					]
				}]
			});

		case "perk.bh_ironside":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "Shining armor or dirty rags, you know how to make it last.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Attacks against you deal " + ::MSU.Text.colorPositive("5") + " less damage to armor, to a minimum of " + ::MSU.Text.colorPositive("1") + "."
					]
				}]
			});

		case "perk.bh_mind_over_matter":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "The hopeful shall survive.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Maximum [Hitpoints|Concept.Hitpoints] are increased by " + ::MSU.Text.colorPositive("50%") + " of base [Resolve|Concept.Bravery], rounded down."
					]
				}]
			});

		case "perk.bh_vigor":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "Dying is for cowards.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Maximum [Hitpoints|Concept.Hitpoints] are increased by " + ::MSU.Text.colorPositive("20") + "."
					]
				}]
			});

		case "perk.bh_habituated":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "I shall last.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Starting on round " + ::MSU.Text.colorPositive("4") + ", gain " + ::MSU.Text.colorPositive("+5") + " [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense]. If you lost [Hitpoints|Concept.Hitpoints] during the first three rounds, gain " + ::MSU.Text.colorPositive("+10") + " instead."
					]
				}]
			});

	}
}

// Prepared for a future perk-tree pass. This definition is intentionally not
// registered with Dynamic Perks and is not present in any perk group or picker.
::Brotherhood.getExecutionerPerkTooltip <- function()
{
	return ::Brotherhood.formatSurvivalPerkTooltip({
		Fluff = "Off with their heads!",
		Effects = [{
			Type = ::UPD.EffectType.Passive,
			Description = [
				"Deal " + ::MSU.Text.colorPositive("20%") + " more damage against [injured|Concept.Injury] or [rooted|Concept.Rooted] characters."
			]
		}]
	});
}

::Brotherhood.getBardPerkTooltip <- function( _perkID )
{
	switch (_perkID)
	{
		case "perk.bh_not_important":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "Who are you again? And why are you here?",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"While this character bears no weapon, enemies are half as likely to target him. If an ally carrying a weapon stands within the attacker's attack range, this character will not be targeted at all."
					]
				}]
			});
	}
}

::Brotherhood.getMobilityPerkTooltip <- function( _perkID )
{
	switch (_perkID)
	{
		case "perk.bh_pursuer":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "The hunt is on!",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"After you kill an enemy, your next movement this turn refunds up to " + ::MSU.Text.colorPositive("2") + " [Action Points|Concept.ActionPoints]."
					]
				}]
			});

		case "perk.bh_vantage":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "The high ground is mine!",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Each time this character moves to a different height level, that tile costs " + ::MSU.Text.colorPositive("1") + " less [Action Point|Concept.ActionPoints], to a minimum of " + ::MSU.Text.colorPositive("2") + ", and costs no [Fatigue|Concept.Fatigue].",
						"The next movement tile that turn costs " + ::MSU.Text.colorPositive("1") + " less [Action Point|Concept.ActionPoints], to a minimum of " + ::MSU.Text.colorPositive("1") + ", and costs half [Fatigue|Concept.Fatigue].",
						"The next attack that turn against an enemy on lower ground gains " + ::MSU.Text.colorPositive("+10%") + " chance to hit."
					]
				}]
			});

		case "perk.bh_prepared":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "Either by anxiety or true readiness, you are always prepared.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						::MSU.Text.colorPositive("+25") + " [Initiative|Concept.Initiative] at round one."
					]
				}]
			});

		case "perk.bh_little_devil":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "This is also my domain.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"While moving between enemy [zones of control|Concept.ZoneOfControl], gain [Melee Defense|Concept.MeleeDefense] equal to " + ::MSU.Text.colorPositive("20%") + " of current [Initiative|Concept.Initiative]."
					]
				}]
			});

		case "perk.bh_light_feet":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "Why be quicker in worse terrain when you can be quicker in better terrain?",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Movement costs " + ::MSU.Text.colorPositive("30%") + " less [Fatigue|Concept.Fatigue]. The first movement tile each turn that costs " + ::MSU.Text.colorPositive("2") + " [Action Points|Concept.ActionPoints] instead costs " + ::MSU.Text.colorPositive("1") + " [Action Point|Concept.ActionPoints]."
					]
				}]
			});

		case "perk.bh_speedster":
			return ::Brotherhood.formatSurvivalPerkTooltip({
				Fluff = "Somewhere past the burning lungs you reach further than most.",
				Effects = [{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"After spending " + ::MSU.Text.colorPositive(::Brotherhood.SpeedsterActionPointThreshold) + " [Action Points|Concept.ActionPoints] on movement in one turn, immediately regain " + ::MSU.Text.colorPositive("2") + " [Action Points|Concept.ActionPoints]. Once per turn."
					]
				}]
			});
	}
}

::Brotherhood.registerSurvivalPerks <- function()
{
	::DynamicPerks.Perks.addPerks([
		::Brotherhood.clonePerkDefWithScript("perk.colossus", "scripts/skills/perks/perk_bh_colossus"),
		::Brotherhood.clonePerkDefWithScript("perk.nine_lives", "scripts/skills/perks/perk_bh_nine_lives"),
		{
			ID = "perk.bh_mind_over_matter",
			Script = "scripts/skills/perks/perk_bh_mind_over_matter",
			Name = "Will",
			Tooltip = ::Brotherhood.getSurvivalPerkTooltip("perk.bh_mind_over_matter"),
			Icon = "ui/perks/bh_will.png",
			IconDisabled = "ui/perks/bh_will_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_vigor",
			Script = "scripts/skills/perks/perk_bh_vigor",
			Name = "Vigor",
			Tooltip = ::Brotherhood.getSurvivalPerkTooltip("perk.bh_vigor"),
			Icon = "ui/perks/bh_vigor.png",
			IconDisabled = "ui/perks/bh_vigor_sw.png",
			PerkGroupIDs = []
		}
	]);
}

::Brotherhood.registerBardPerks <- function()
{
	::DynamicPerks.Perks.addPerks([
		{
			ID = "perk.bh_not_important",
			Script = "scripts/skills/perks/perk_bh_not_important",
			Name = "Harmless",
			Tooltip = ::Brotherhood.getBardPerkTooltip("perk.bh_not_important"),
			Icon = "ui/perks/perk_17.png",
			IconDisabled = "ui/perks/perk_17_sw.png",
			PerkGroupIDs = []
		}
	]);
}

::Brotherhood.getPlagueDoctorTooltip <- function(_id)
{
	local d = {
		"perk.bh_ghost_pain": {
			Fluff = "You felt it too, didn't you?",
			Type = ::UPD.EffectType.Passive,
			Description = [
				"Whenever you inflict an [injury|Concept.InjuryTemporary], another enemy adjacent to the target may receive a Ghost Injury lasting for the remainder of combat but with halved effects.",
				"The chance of this happening is based on that enemy's [Resolve|Concept.Bravery].",
				"This can happen to any number of enemies adjacent to the target."
			]
		},
		"perk.bh_medicine_mastery": {
			Fluff = "Master the study of medicine.",
			Type = ::UPD.EffectType.Passive,
			Description = [
				"Bandages now cost " + ::MSU.Text.colorPositive("1") + " [Action Point|Concept.ActionPoints].",
				"Bandages can be used on targets that are not bleeding, restoring " + ::MSU.Text.colorPositive("10%") + " of their maximum [Hitpoints|Concept.Hitpoints].",
				"Whenever you heal yourself or an ally, or stop their Bleeding, trigger a positive [morale check|Concept.Morale]."
			]
		},
		"perk.bh_magna_medicina": {
			Fluff = "Nothing some good knowledge can't resolve.",
			Type = ::UPD.EffectType.Active,
			Description = [
				"Unlocks the Magna Medicina skill, which cures the most recently suffered temporary [injury|Concept.InjuryTemporary] of yourself or an adjacent ally.",
				"The first time you use Magna Medicina on that ally each battle, also restore " + ::MSU.Text.colorPositive("30%") + " of their maximum [Hitpoints|Concept.Hitpoints].",
				"Costs " + ::MSU.Text.colorPositive("4") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue]."
			]
		},
		"perk.bh_scholastic_anatomy": {
			Fluff = "Permanent? Maybe for an amateur.",
			Type = ::UPD.EffectType.Passive,
			Description = [
				"When you acquire this perk, all existing permanent [injuries|Concept.InjuryPermanent] become temporary and can heal normally, except injuries caused by the loss of a body part, like being blind.",
				"Any permanent [injuries|Concept.InjuryPermanent] you suffer in the future become temporary instead.",
				"All temporary [injuries|Concept.InjuryTemporary] last for half their normal duration."
			]
		}
	};
	local perk = d[_id];
	return ::Brotherhood.formatSurvivalPerkTooltip({ Fluff = perk.Fluff, Effects = [{ Type = perk.Type, Description = perk.Description }] });
}

::Brotherhood.registerPlagueDoctorPerks <- function()
{
	::DynamicPerks.Perks.addPerks([
		{ ID="perk.bh_ghost_pain", Script="scripts/skills/perks/perk_bh_ghost_pain", Name="Ghost Pain", Tooltip=::Brotherhood.getPlagueDoctorTooltip("perk.bh_ghost_pain"), Icon="ui/perks/bh_ghost_pain.png", IconDisabled="ui/perks/bh_ghost_pain_sw.png", PerkGroupIDs=[] },
		{ ID="perk.bh_medicine_mastery", Script="scripts/skills/perks/perk_bh_medicine_mastery", Name="Medicine Mastery", Tooltip=::Brotherhood.getPlagueDoctorTooltip("perk.bh_medicine_mastery"), Icon="ui/perks/bh_medicine_mastery.png", IconDisabled="ui/perks/bh_medicine_mastery_sw.png", PerkGroupIDs=[] },
		{ ID="perk.bh_magna_medicina", Script="scripts/skills/perks/perk_bh_magna_medicina", Name="Magna Medicina", Tooltip=::Brotherhood.getPlagueDoctorTooltip("perk.bh_magna_medicina"), Icon="ui/perks/perk_21.png", IconDisabled="ui/perks/perk_21_sw.png", PerkGroupIDs=[] },
		{ ID="perk.bh_scholastic_anatomy", Script="scripts/skills/perks/perk_bh_scholastic_anatomy", Name="Scholastic Anatomy", Tooltip=::Brotherhood.getPlagueDoctorTooltip("perk.bh_scholastic_anatomy"), Icon="ui/perks/perk_09.png", IconDisabled="ui/perks/perk_09_sw.png", PerkGroupIDs=[] }
	]);

	// Reforged constructs perk groups before Dynamic Perks' VeryLate metadata
	// pass. Vanilla definitions such as Bags and Belts do not own this field yet.
	foreach (id in [
		"perk.bags_and_belts", "perk.bh_crippling_strikes",
		"perk.bh_ghost_pain", "perk.bh_medicine_mastery",
		"perk.bh_magna_medicina", "perk.bh_scholastic_anatomy"
	])
	{
		local perk = ::Const.Perks.findById(id);
		if (perk == null) throw "Brotherhood Plague Doctor perk was not registered: " + id;
		if (!("PerkGroupIDs" in perk)) perk.PerkGroupIDs <- [];
	}
}

::Brotherhood.registerMobilityPerks <- function()
{
	::DynamicPerks.Perks.addPerks([
		::Brotherhood.clonePerkDefWithScript("perk.pathfinder", "scripts/skills/perks/perk_pathfinder"),
		{
			ID = "perk.bh_pursuer",
			Script = "scripts/skills/perks/perk_bh_pursuer",
			Name = "Pursuer",
			Tooltip = ::Brotherhood.getMobilityPerkTooltip("perk.bh_pursuer"),
			Icon = "ui/perks/bh_pursuer.png",
			IconDisabled = "ui/perks/bh_pursuer_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_vantage",
			Script = "scripts/skills/perks/perk_bh_vantage",
			Name = "Vantage",
			Tooltip = ::Brotherhood.getMobilityPerkTooltip("perk.bh_vantage"),
			Icon = "ui/perks/perk_05.png",
			IconDisabled = "ui/perks/perk_05_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_prepared",
			Script = "scripts/skills/perks/perk_bh_prepared",
			Name = "Prepared",
			Tooltip = ::Brotherhood.getMobilityPerkTooltip("perk.bh_prepared"),
			Icon = "ui/perks/perk_42.png",
			IconDisabled = "ui/perks/perk_42_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_little_devil",
			Script = "scripts/skills/perks/perk_bh_little_devil",
			Name = "Little Devil",
			Tooltip = ::Brotherhood.getMobilityPerkTooltip("perk.bh_little_devil"),
			Icon = "ui/perks/perk_26.png",
			IconDisabled = "ui/perks/perk_26_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_light_feet",
			Script = "scripts/skills/perks/perk_bh_light_feet",
			Name = "Light Feet",
			Tooltip = ::Brotherhood.getMobilityPerkTooltip("perk.bh_light_feet"),
			Icon = "ui/perks/perk_01.png",
			IconDisabled = "ui/perks/perk_01_sw.png",
			PerkGroupIDs = []
		}
	]);
}

::Brotherhood.zeroReachProperties <- function( _properties )
{
	if (_properties == null) return;

	if ("Reach" in _properties) _properties.Reach = 0;
	if ("ReachMult" in _properties) _properties.ReachMult = 0.0;
	if ("IsAffectedByReach" in _properties) _properties.IsAffectedByReach = false;
	if ("DefensiveReachIgnore" in _properties) _properties.DefensiveReachIgnore = 0;
	if ("OffensiveReachIgnore" in _properties) _properties.OffensiveReachIgnore = 0;
	if ("BonusPerReachAdvantage" in _properties) _properties.BonusPerReachAdvantage = 0;
}

::Brotherhood.disableEntityReach <- function( _entity )
{
	if (_entity == null) return;

	::Brotherhood.zeroReachProperties(_entity.getBaseProperties());
	::Brotherhood.zeroReachProperties(_entity.getCurrentProperties());
	_entity.getSkills().removeByID("special.rf_reach");
}

::Brotherhood.getTestingBackgrounds <- function()
{
	return [
		"beggar_background"
	];
}

::Brotherhood.applyTestingBackgroundPool <- function()
{
	if ("CharacterBackgrounds" in ::Const) ::Const.CharacterBackgrounds = ::Brotherhood.getTestingBackgrounds();
	if ("CharacterPiracyBackgrounds" in ::Const) ::Const.CharacterPiracyBackgrounds = ::Brotherhood.getTestingBackgrounds();

	if ("MV_getHireableCharacterBackgrounds" in ::Const)
	{
		::Const.MV_getHireableCharacterBackgrounds = function()
		{
			return ::Brotherhood.getTestingBackgrounds();
		};
	}
	else
	{
		::Const.MV_getHireableCharacterBackgrounds <- function()
		{
			return ::Brotherhood.getTestingBackgrounds();
		};
	}
}

::Brotherhood.isTestingItem <- function( _item )
{
	if (_item == null || !("m" in _item)) return false;
	if ("BH_IsTestingItem" in _item.m && _item.m.BH_IsTestingItem) return true;
	return "Name" in _item.m && _item.m.Name != null && _item.m.Name.find("[TEST") == 0;
}

::Brotherhood.zeroTestingItemSkillFatigue <- function( _item )
{
	if (!::Brotherhood.isTestingItem(_item)) return;
	if (!("getSkills" in _item)) return;

	foreach (skill in _item.getSkills())
	{
		if (skill == null || !("m" in skill)) continue;
		if ("FatigueCost" in skill.m) skill.m.FatigueCost = 0;
	}
}

::Brotherhood.forceTestingItemZeroFatigue <- function( _item )
{
	if (!::Brotherhood.isTestingItem(_item)) return;

	if ("BH_IsTestingItem" in _item.m) _item.m.BH_IsTestingItem = true;
	else _item.m.BH_IsTestingItem <- true;
	if ("StaminaModifier" in _item.m) _item.m.StaminaModifier = 0;
	if ("FatigueOnSkillUse" in _item.m) _item.m.FatigueOnSkillUse = 0;
	::Brotherhood.zeroTestingItemSkillFatigue(_item);
}

::Brotherhood.tuneTestingItem <- function( _item, _name )
{
	if (_item == null || !("m" in _item)) return _item;

	if ("BH_IsTestingItem" in _item.m) _item.m.BH_IsTestingItem = true;
	else _item.m.BH_IsTestingItem <- true;
	_item.m.Name = _name;
	if ("ConditionMax" in _item.m)
	{
		_item.m.ConditionMax = 999;
		_item.m.Condition = 999;
	}

	if ("StaminaModifier" in _item.m) _item.m.StaminaModifier = 0;
	if ("FatigueOnSkillUse" in _item.m) _item.m.FatigueOnSkillUse = 0;
	if ("RegularDamage" in _item.m) _item.m.RegularDamage = ::Math.max(_item.m.RegularDamage, 110);
	if ("RegularDamageMax" in _item.m) _item.m.RegularDamageMax = ::Math.max(_item.m.RegularDamageMax, 150);
	if ("ArmorDamageMult" in _item.m) _item.m.ArmorDamageMult = ::Math.maxf(_item.m.ArmorDamageMult, 1.5);
	if ("DirectDamageMult" in _item.m) _item.m.DirectDamageMult = ::Math.maxf(_item.m.DirectDamageMult, 0.45);
	if ("MeleeDefense" in _item.m) _item.m.MeleeDefense = ::Math.max(_item.m.MeleeDefense, 45);
	if ("RangedDefense" in _item.m) _item.m.RangedDefense = ::Math.max(_item.m.RangedDefense, 45);
	if ("Ammo" in _item.m) _item.m.Ammo = 99;
	if ("AmmoMax" in _item.m) _item.m.AmmoMax = 99;

	::Brotherhood.forceTestingItemZeroFatigue(_item);

	return _item;
}

::Brotherhood.addTestingItemToStash <- function( _script, _name )
{
	local item = ::Brotherhood.tuneTestingItem(::new(_script), _name);
	::World.Assets.getStash().add(item);
}

// F6 gear deliberately keeps vanilla damage, armor, ammunition capacity, and
// Fatigue values. The older [TEST ...] items are overpowered and zero-Fatigue,
// which makes them unsuitable for validating the current perk mechanics.
::Brotherhood.addCurrentPerkTestingItemToStash <- function( _script, _name, _ammo = null )
{
	local item = ::new(_script);
	if (item == null || !("m" in item)) return 0;
	item.m.Name = _name;
	if (_ammo != null && "getAmmo" in item && item.getAmmoMax() > 0) item.setAmmo(::Math.min(_ammo, item.getAmmoMax()));
	return ::World.Assets.getStash().add(item) == null ? 0 : 1;
}

::Brotherhood.removeLegacyTestingGearFromStash <- function()
{
	local stash = ::World.Assets.getStash();
	local remove = [];
	local legacyPrefixes = ["[TEST 2H]", "[TEST TANK]", "[TEST RANGED]", "[TEST HANDGONNE]", "[TEST OBSIDIAN]"];
	local legacyIDs = ["misc.bh_promised_potential_debug", "misc.bh_flagellant_injury_debug"];

	foreach (item in stash.getItems())
	{
		if (item == null) continue;
		local isLegacy = legacyIDs.find(item.getID()) != null;
		if (!isLegacy)
		{
			local name = item.getName();
			foreach (prefix in legacyPrefixes)
			{
				if (name.find(prefix) == 0)
				{
					isLegacy = true;
					break;
				}
			}
		}
		if (isLegacy) remove.push(item.getInstanceID());
	}

	foreach (instanceID in remove) stash.remove(instanceID);
	return remove.len();
}

::Brotherhood.addTestingGearToStash <- function( _force = false )
{
	if (!::Brotherhood.TestingMode) return null;
	if (!_force && !::Brotherhood.AddTestingGearOnStart) return null;
	if (!("World" in getroottable()) || ::MSU.isNull(::World.Assets)) return null;

	local removed = ::Brotherhood.removeLegacyTestingGearFromStash();
	local added = 0;

	// Exact vanilla-stat melee baselines for the current weapon masteries and
	// free-hand/off-hand perks.
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/arming_sword", "[F6 MELEE] Arming Sword");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/dagger", "[F6 MELEE] Dagger");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/fighting_axe", "[F6 MELEE] Fighting Axe");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/military_cleaver", "[F6 MELEE] Military Cleaver");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/winged_mace", "[F6 MELEE] Winged Mace");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/warhammer", "[F6 MELEE] Warhammer");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/pike", "[F6 POLEARM] Pike");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/fighting_spear", "[F6 SPEAR] Fighting Spear");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/two_handed_hammer", "[F6 2H] Two-Handed Hammer");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/shields/buckler_shield", "[F6 HANDS] Buckler Control");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/shields/heater_shield", "[F6 HANDS] Shield Control");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/tools/player_banner", "[F6 BANNER] Battle Standard");

	// Ranged/reload baselines plus both full and low-ammo states for
	// Preparation, Desperation, Bloodloaded, Porcupine, and alternating attacks.
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/war_bow", "[F6 RANGED] War Bow");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/heavy_crossbow", "[F6 RELOAD] Heavy Crossbow");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/oriental/handgonne", "[F6 RELOAD] Handgonne");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/ammo/powder_bag", "[F6 AMMO FULL] Powder");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/ammo/quiver_of_arrows", "[F6 AMMO FULL] Arrows");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/ammo/quiver_of_arrows", "[F6 AMMO LOW] Arrows", 2);
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/ammo/quiver_of_bolts", "[F6 AMMO FULL] Bolts");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/ammo/quiver_of_bolts", "[F6 AMMO LOW] Bolts", 2);

	// Two copies allow Volley Mastery to equip throwing weapons in both hands.
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/javelin", "[F6 THROWING] Javelins A");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/javelin", "[F6 THROWING] Javelins B");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/throwing_axe", "[F6 THROWING] Axes A");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/throwing_axe", "[F6 THROWING] Axes B");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/weapons/throwing_spear", "[F6 THROWING] Throwing Spear");

	// Nets provide a repeatable negative status and a valid Perfect Thrust setup.
	for (local i = 1; i <= 3; ++i)
	{
		added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/tools/reinforced_throwing_net", "[F6 CONTROL] Reinforced Net " + i);
	}

	// Preserve real armor penalties so Dodge/Brawny/Fatigue comparisons remain valid.
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/armor/padded_leather", "[F6 ARMOR LIGHT] Padded Leather");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/helmets/nasal_helmet", "[F6 ARMOR LIGHT] Nasal Helmet");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/armor/rf_heavy_plate_harness", "[F6 ARMOR HEAVY] Heavy Plate");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/helmets/rf_great_helm", "[F6 ARMOR HEAVY] Great Helm");

	// Potion-strength and fatigue/recovery baselines for Preparation and related perks.
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/accessory/cat_potion_item", "[F6 POTION] Cat Potion");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/accessory/recovery_potion_item", "[F6 POTION] Second Wind");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/accessory/berserker_mushrooms_item", "[F6 POTION] Strange Mushrooms");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/accessory/lionheart_potion_item", "[F6 POTION] Lionheart");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/accessory/bandage_item", "[F6 CONSUMABLE] Bandage");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/accessory/antidote_item", "[F6 CONSUMABLE] Antidote");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/tools/smoke_bomb_item", "[F6 CONSUMABLE] Smoke Bomb A");
	added += ::Brotherhood.addCurrentPerkTestingItemToStash("scripts/items/tools/smoke_bomb_item", "[F6 CONSUMABLE] Smoke Bomb B");

	for (local i = 0; i < 2; ++i)
	{
		if (::World.Assets.getStash().add(::new("scripts/items/misc/bh_student_debug_item")) != null) ++added;
		if (::World.Assets.getStash().add(::new("scripts/items/misc/bh_current_injury_debug_item")) != null) ++added;
	}

	::logInfo("[Brotherhood][F6 KIT] Removed " + removed + " legacy item(s) and added " + added + " current-perk testing item(s) with vanilla stats/costs.");
	return { Added = added, Removed = removed };
}

::Brotherhood.hasEnemyWithinDistance <- function( _actor, _distance )
{
	if (_actor == null || !_actor.isPlacedOnMap()) return false;
	local myTile = _actor.getTile();

	foreach (faction in ::Tactical.Entities.getAllInstances())
	{
		foreach (other in faction)
		{
			if (!other.isPlacedOnMap() || other.isAlliedWith(_actor)) continue;
			if (other.getTile().getDistanceTo(myTile) <= _distance) return true;
		}
	}

	return false;
}

::Brotherhood.hasPlacedAlly <- function( _actor )
{
	if (_actor == null || !_actor.isPlacedOnMap()) return false;

	foreach (ally in ::Tactical.Entities.getInstancesOfFaction(_actor.getFaction()))
	{
		if (ally != null && ally.getID() != _actor.getID() && ally.isPlacedOnMap() && ally.isAlive() && !ally.isDying())
		{
			return true;
		}
	}

	return false;
}

::Brotherhood.hasAdjacentAllyAtTile <- function( _actor, _tile )
{
	if (_actor == null || _tile == null) return false;

	foreach (tile in ::MSU.Tile.getNeighbors(_tile))
	{
		if (tile.IsOccupiedByActor && tile.getEntity().isAlliedWith(_actor) && tile.getEntity().getID() != _actor.getID())
		{
			return true;
		}
	}

	return false;
}

::Brotherhood.recordSpeedsterMovement <- function( _actor, _apSpent )
{
	return;
}

::Brotherhood.getMovementAPSpent <- function( _before, _after, _tilesMoved )
{
	local spent = ::Math.max(0, _before - _after);
	if (spent > 0 || _tilesMoved <= 0) return spent;

	return _tilesMoved;
}

::Brotherhood.hasVantageActionPointDiscount <- function( _actor )
{
	if (_actor == null) return false;

	local skills = _actor.getSkills();
	return skills.getSkillByID("perk.bh_vantage") != null && skills.getSkillByID("perk.pathfinder") == null;
}

::Brotherhood.getVantagePerk <- function( _actor )
{
	return _actor == null ? null : _actor.getSkills().getSkillByID("perk.bh_vantage");
}

::Brotherhood.hasVantage <- function( _actor )
{
	return ::Brotherhood.getVantagePerk(_actor) != null;
}

::Brotherhood.getVantageLevelFatigueCost <- function( _actor, _levelFatigueCost )
{
	if (::Brotherhood.hasVantage(_actor)) return 0;
	return _levelFatigueCost;
}

::Brotherhood.hasPursuerFatigueFreeMovement <- function( _actor )
{
	return false;
}

::Brotherhood.getPursuerActionPoints <- function( _actor )
{
	return 0;
}

::Brotherhood.beginMovementPreviewSettingsAdjustment <- function( _actor, _settings )
{
	if (_actor == null || _settings == null) return null;

	local ret = {
		HasFatigueCosts = false,
		FatigueCosts = null,
		HasFatigueCostPerLevel = false,
		FatigueCostPerLevel = null
	};
	local changed = false;

	if (::Brotherhood.hasPursuerFatigueFreeMovement(_actor) && "FatigueCosts" in _settings && _settings.FatigueCosts != null)
	{
		ret.HasFatigueCosts = true;
		ret.FatigueCosts = _settings.FatigueCosts;
		local zeroCosts = clone _settings.FatigueCosts;
		for (local i = 0; i < zeroCosts.len(); ++i)
		{
			zeroCosts[i] = 0;
		}
		_settings.FatigueCosts = zeroCosts;
		changed = true;
	}

	if (::Brotherhood.hasPursuerFatigueFreeMovement(_actor) && "FatigueCostPerLevel" in _settings)
	{
		ret.HasFatigueCostPerLevel = true;
		ret.FatigueCostPerLevel = _settings.FatigueCostPerLevel;
		_settings.FatigueCostPerLevel = 0;
		changed = true;
	}
	else if (::Brotherhood.hasVantage(_actor) && "FatigueCostPerLevel" in _settings && _settings.FatigueCostPerLevel > 0)
	{
		ret.HasFatigueCostPerLevel = true;
		ret.FatigueCostPerLevel = _settings.FatigueCostPerLevel;
		_settings.FatigueCostPerLevel = 0;
		changed = true;
	}

	return changed ? ret : null;
}

::Brotherhood.endMovementPreviewSettingsAdjustment <- function( _settings, _adjustment )
{
	if (_settings == null || _adjustment == null) return;

	if (_adjustment.HasFatigueCosts)
	{
		_settings.FatigueCosts = _adjustment.FatigueCosts;
	}

	if (_adjustment.HasFatigueCostPerLevel)
	{
		_settings.FatigueCostPerLevel = _adjustment.FatigueCostPerLevel;
	}
}

::Brotherhood.beginMovementNavigatorPreview <- function( _actor )
{
	if (_actor == null || !("m" in _actor)) return null;
	if (!_actor.isPlayerControlled()) return null;
	if (::Tactical.TurnSequenceBar.getActiveEntity() == null || ::Tactical.TurnSequenceBar.getActiveEntity().getID() != _actor.getID()) return null;

	local depth = ("BH_MovementPreviewNavigatorDepth" in _actor.m) ? _actor.m.BH_MovementPreviewNavigatorDepth : 0;
	_actor.m.BH_MovementPreviewNavigatorDepth = depth + 1;

	if (depth == 0)
	{
		::Brotherhood.resetMovementActionPointPreview(_actor);
	}

	return _actor;
}

::Brotherhood.endMovementNavigatorPreview <- function( _actor )
{
	if (_actor == null || !("m" in _actor) || !("BH_MovementPreviewNavigatorDepth" in _actor.m)) return;

	_actor.m.BH_MovementPreviewNavigatorDepth = ::Math.max(0, _actor.m.BH_MovementPreviewNavigatorDepth - 1);
}

::Brotherhood.isMovementPreviewing <- function( _actor )
{
	if (_actor == null || !("m" in _actor)) return false;
	if (_actor.isPreviewing()) return true;
	return "BH_MovementPreviewNavigatorDepth" in _actor.m && _actor.m.BH_MovementPreviewNavigatorDepth > 0;
}

::Brotherhood.isMovementNavigatorPreviewing <- function( _actor )
{
	if (::Tactical.State != null && ::Tactical.State.getCurrentActionState() == ::Const.Tactical.ActionState.TravelPath)
	{
		return false;
	}

	return _actor != null
		&& "m" in _actor
		&& "BH_MovementPreviewNavigatorDepth" in _actor.m
		&& _actor.m.BH_MovementPreviewNavigatorDepth > 0;
}

::Brotherhood.getMovementStepBaseFatigueCost <- function( _actor, _tile, _levelDifference )
{
	if (_actor == null || _tile == null) return 0;

	local fatigueCost = ::Math.round((_actor.m.FatigueCosts[_tile.Type] + _actor.m.CurrentProperties.MovementFatigueCostAdditional) * _actor.m.CurrentProperties.MovementFatigueCostMult);

	if (_levelDifference != 0)
	{
		fatigueCost = fatigueCost + _actor.m.LevelFatigueCost;

		if (_levelDifference > 0)
		{
			fatigueCost = fatigueCost + ::Const.Movement.LevelClimbingFatigueCost;
		}
	}

	return ::Math.max(0, ::Math.round(fatigueCost * _actor.m.CurrentProperties.FatigueEffectMult));
}

::Brotherhood.getMovementStepFatigueCost <- function( _actor, _tile, _levelDifference, _plan = null )
{
	if (_actor == null || _tile == null) return 0;
	if (::Brotherhood.hasPursuerFatigueFreeMovement(_actor)) return 0;

	local fatigueCost = ::Brotherhood.getMovementStepBaseFatigueCost(_actor, _tile, _levelDifference);
	if (_plan != null && "VantageFatigueMode" in _plan)
	{
		if (_plan.VantageFatigueMode == "Free") return 0;
		if (_plan.VantageFatigueMode == "Half") return ::Math.floor(fatigueCost * 0.5);
	}

	return fatigueCost;
}

::Brotherhood.beginPursuerFatigueAdjustment <- function( _actor, _tile, _levelDifference )
{
	if (_actor == null || _tile == null) return null;
	if (!::Brotherhood.hasPursuerFatigueFreeMovement(_actor)) return null;

	local ret = {
		TileType = _tile.Type,
		FatigueCost = _actor.m.FatigueCosts[_tile.Type],
		LevelFatigueCost = _actor.m.LevelFatigueCost
	};

	_actor.m.FatigueCosts[_tile.Type] = -_actor.m.CurrentProperties.MovementFatigueCostAdditional;
	_actor.m.LevelFatigueCost = _levelDifference > 0 ? -::Const.Movement.LevelClimbingFatigueCost : 0;
	return ret;
}

::Brotherhood.endPursuerFatigueAdjustment <- function( _actor, _adjustment )
{
	if (_actor == null || _adjustment == null) return;

	_actor.m.FatigueCosts[_adjustment.TileType] = _adjustment.FatigueCost;
	_actor.m.LevelFatigueCost = _adjustment.LevelFatigueCost;
}

::Brotherhood.beginVantageFatigueAdjustment <- function( _actor, _tile, _levelDifference, _plan = null )
{
	if (_actor == null || _tile == null || _plan == null || !("VantageFatigueMode" in _plan)) return null;
	if (_plan.VantageFatigueMode == null) return null;

	local ret = {
		TileType = _tile.Type,
		FatigueCost = _actor.m.FatigueCosts[_tile.Type],
		LevelFatigueCost = _actor.m.LevelFatigueCost
	};

	local targetFatigue = _plan.VantageFatigueMode == "Free" ? 0 : ::Brotherhood.getMovementStepFatigueCost(_actor, _tile, _levelDifference, _plan);
	local fatigueEffectMult = ::Math.maxf(0.0001, _actor.m.CurrentProperties.FatigueEffectMult);
	local movementFatigueMult = ::Math.maxf(0.0001, _actor.m.CurrentProperties.MovementFatigueCostMult);
	_actor.m.FatigueCosts[_tile.Type] = (targetFatigue.tofloat() / fatigueEffectMult / movementFatigueMult) - _actor.m.CurrentProperties.MovementFatigueCostAdditional;
	_actor.m.LevelFatigueCost = _levelDifference > 0 ? -::Const.Movement.LevelClimbingFatigueCost : 0;
	return ret;
}

::Brotherhood.endVantageFatigueAdjustment <- function( _actor, _adjustment )
{
	if (_actor == null || _adjustment == null) return;

	_actor.m.FatigueCosts[_adjustment.TileType] = _adjustment.FatigueCost;
	_actor.m.LevelFatigueCost = _adjustment.LevelFatigueCost;
}

::Brotherhood.beginMovementFatigueAdjustment <- function( _actor, _tile, _levelDifference, _plan = null )
{
	local pursuerAdjustment = ::Brotherhood.beginPursuerFatigueAdjustment(_actor, _tile, _levelDifference);
	if (pursuerAdjustment != null) return {
		Type = "Pursuer",
		Adjustment = pursuerAdjustment
	};

	local vantageAdjustment = ::Brotherhood.beginVantageFatigueAdjustment(_actor, _tile, _levelDifference, _plan);
	if (vantageAdjustment != null) return {
		Type = "Vantage",
		Adjustment = vantageAdjustment
	};

	return null;
}

::Brotherhood.endMovementFatigueAdjustment <- function( _actor, _adjustment )
{
	if (_adjustment == null) return;

	if (_adjustment.Type == "Pursuer")
	{
		::Brotherhood.endPursuerFatigueAdjustment(_actor, _adjustment.Adjustment);
	}
	else if (_adjustment.Type == "Vantage")
	{
		::Brotherhood.endVantageFatigueAdjustment(_actor, _adjustment.Adjustment);
	}
}

::Brotherhood.beginHoveredVantageFatigueAdjustment <- function( _actor )
{
	if (_actor == null || !_actor.isPlacedOnMap()) return null;

	local hoveredTile = ::Tactical.State.getLastTileHovered();
	if (hoveredTile == null) return null;
	if (hoveredTile.getDistanceTo(_actor.getTile()) != 1) return null;

	local levelDifference = hoveredTile.Level - _actor.getTile().Level;
	local baseActionPointCost = ::Brotherhood.getMovementStepActionPointCost(_actor, hoveredTile, levelDifference);
	local plan = ::Brotherhood.getMovementStepActionPointPlan(_actor, hoveredTile, baseActionPointCost);
	return ::Brotherhood.beginMovementFatigueAdjustment(_actor, hoveredTile, levelDifference, plan);
}

::Brotherhood.hasMovementPreview <- function( _actor )
{
	return _actor != null && ("m" in _actor) && _actor.isPreviewing() && _actor.getPreviewMovement() != null;
}

::Brotherhood.getHoveredMovementPreviewTile <- function( _actor )
{
	if (_actor == null || !("m" in _actor) || !_actor.isPlacedOnMap()) return null;

	local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();
	if (activeEntity == null || activeEntity.getID() != _actor.getID()) return null;

	local hoveredTile = ::Tactical.State.getLastTileHovered();
	if (hoveredTile == null || !hoveredTile.IsEmpty || hoveredTile.Type == ::Const.Tactical.TerrainType.Impassable) return null;
	if (hoveredTile.getDistanceTo(_actor.getTile()) != 1) return null;

	return hoveredTile;
}

::Brotherhood.getBrotherhoodMovementPreviewResourceProjection <- function( _actor )
{
	if (_actor == null || !("m" in _actor)) return null;

	if (::Brotherhood.hasMovementPreview(_actor))
	{
		local actionPoints = _actor.m.PreviewActionPoints;
		local fatigue = _actor.m.PreviewFatigue;
		if ("BH_MovementPreviewActionPoints" in _actor.m && _actor.m.BH_MovementPreviewActionPoints != null)
		{
			actionPoints = _actor.m.BH_MovementPreviewActionPoints;
		}

		if ("BH_MovementPreviewFatigue" in _actor.m && _actor.m.BH_MovementPreviewFatigue != null)
		{
			fatigue = _actor.m.BH_MovementPreviewFatigue;
		}

		return {
			ActionPoints = actionPoints,
			Fatigue = fatigue,
			IsNativePreview = true
		};
	}

	local hoveredTile = ::Brotherhood.getHoveredMovementPreviewTile(_actor);
	if (hoveredTile == null) return null;

	local costs = ::Brotherhood.getMovementStepPreviewCosts(_actor, hoveredTile);
	if (costs == null) return null;

	return {
		ActionPoints = ::Math.max(0, _actor.m.ActionPoints - costs.ActionPointCost),
		Fatigue = ::Math.min(_actor.getFatigueMax(), _actor.m.Fatigue + costs.FatigueCost),
		Costs = costs,
		Tile = hoveredTile,
		IsHoverPreview = true
	};
}

::Brotherhood.getMovementPreviewResourceProjection <- function( _actor )
{
	return ::Brotherhood.getBrotherhoodMovementPreviewResourceProjection(_actor);
}

::Brotherhood.getMovementPreviewAggregateCosts <- function( _actor )
{
	if (_actor == null || !_actor.isPreviewing() || _actor.getPreviewMovement() == null) return null;

	if ("m" in _actor
		&& "BH_MovementPreviewStartActionPoints" in _actor.m && _actor.m.BH_MovementPreviewStartActionPoints != null
		&& "BH_MovementPreviewStartFatigue" in _actor.m && _actor.m.BH_MovementPreviewStartFatigue != null
		&& "BH_MovementPreviewActionPoints" in _actor.m && _actor.m.BH_MovementPreviewActionPoints != null
		&& "BH_MovementPreviewFatigue" in _actor.m && _actor.m.BH_MovementPreviewFatigue != null)
	{
		return {
			ActionPointCost = ::Math.max(0, _actor.m.BH_MovementPreviewStartActionPoints - _actor.m.BH_MovementPreviewActionPoints),
			FatigueCost = ::Math.max(0, _actor.m.BH_MovementPreviewFatigue - _actor.m.BH_MovementPreviewStartFatigue)
		};
	}

	local costs = _actor.getCostsPreview();
	if (costs == null || !("ActionPoints" in costs) || !("Fatigue" in costs)) return null;

	return {
		ActionPointCost = ::Math.max(0, costs.ActionPoints),
		FatigueCost = ::Brotherhood.getMovementPreviewFatigueCost(_actor, costs.Fatigue)
	};
}

::Brotherhood.getMovementPreviewNormalActionPointCost <- function( _actor, _rawActionPointCost )
{
	if (_actor == null) return _rawActionPointCost;

	local ret = ::Math.max(0, _rawActionPointCost);
	local pursuitActionPoints = ::Brotherhood.getPursuerActionPoints(_actor);
	if (pursuitActionPoints > 0)
	{
		ret = ::Math.max(0, ret - ::Math.min(ret, pursuitActionPoints));
	}

	return ret;
}

::Brotherhood.getMovementPreviewFatigueCost <- function( _actor, _rawFatigueCost )
{
	if (_actor == null) return _rawFatigueCost;
	if (::Brotherhood.hasPursuerFatigueFreeMovement(_actor)) return 0;

	local movement = _actor.getPreviewMovement();
	if (movement != null && movement.Tiles == 1 && "End" in movement && movement.End != null && _actor.isPlacedOnMap())
	{
		local vantage = ::Brotherhood.getVantagePerk(_actor);
		if (vantage != null && movement.End.Level != _actor.getTile().Level)
		{
			return 0;
		}
	}

	return ::Math.max(0, _rawFatigueCost);
}

::Brotherhood.applyMovementPreviewCostsToCostsPreview <- function( _actor, _costsPreview )
{
	if (_actor == null || _costsPreview == null || !::Brotherhood.hasMovementPreview(_actor)) return false;

	local changed = false;
	if ("m" in _actor)
	{
		if ("actionPointsPreview" in _costsPreview
			&& "BH_MovementPreviewActionPoints" in _actor.m
			&& _actor.m.BH_MovementPreviewActionPoints != null)
		{
			_costsPreview.actionPointsPreview = ::Math.max(0, _actor.m.BH_MovementPreviewActionPoints);
			changed = true;
		}

		if ("fatiguePreview" in _costsPreview
			&& "BH_MovementPreviewFatigue" in _actor.m
			&& _actor.m.BH_MovementPreviewFatigue != null)
		{
			_costsPreview.fatiguePreview = ::Math.min(_actor.getFatigueMax(), ::Math.max(0, _actor.m.BH_MovementPreviewFatigue));
			changed = true;
		}

		if (changed) return true;
	}

	local costs = _actor.getCostsPreview();
	if (costs != null)
	{
		if ("ActionPoints" in costs && "actionPointsPreview" in _costsPreview)
		{
			local isAlreadyAdjusted = "bhMovementCostsAdjusted" in costs && costs.bhMovementCostsAdjusted;
			local adjustedCost = isAlreadyAdjusted ? ::Math.max(0, costs.ActionPoints) : ::Brotherhood.getMovementPreviewNormalActionPointCost(_actor, costs.ActionPoints);
			local refund = ::Brotherhood.getMovementPreviewActionPointRefund(_actor);
			if (refund > 0) adjustedCost = ::Math.max(0, adjustedCost - refund);
			_costsPreview.actionPointsPreview = ::Math.max(0, _actor.getActionPoints() - adjustedCost);
			changed = true;
		}

		if ("Fatigue" in costs && "fatiguePreview" in _costsPreview)
		{
			local adjustedFatigueCost = ::Brotherhood.getMovementPreviewFatigueCost(_actor, costs.Fatigue);
			_costsPreview.fatiguePreview = ::Math.min(_actor.getFatigueMax(), _actor.getFatigue() + adjustedFatigueCost);
			changed = true;
		}

		return changed;
	}

	return changed;
}

::Brotherhood.applyMovementPreviewFinalCostsToMovementCosts <- function( _actor, _movementCosts )
{
	if (_actor == null || _movementCosts == null || !("m" in _actor)) return false;
	if ("bhMovementCostsAdjusted" in _movementCosts && _movementCosts.bhMovementCostsAdjusted) return true;

	local changed = false;
	local startActionPoints = ("BH_MovementPreviewStartActionPoints" in _actor.m && _actor.m.BH_MovementPreviewStartActionPoints != null) ? _actor.m.BH_MovementPreviewStartActionPoints : _actor.getActionPoints();
	local startFatigue = ("BH_MovementPreviewStartFatigue" in _actor.m && _actor.m.BH_MovementPreviewStartFatigue != null) ? _actor.m.BH_MovementPreviewStartFatigue : _actor.getFatigue();

	if ("ActionPoints" in _movementCosts && "BH_MovementPreviewActionPoints" in _actor.m && _actor.m.BH_MovementPreviewActionPoints != null)
	{
		_movementCosts.ActionPoints = ::Math.max(0, startActionPoints - _actor.m.BH_MovementPreviewActionPoints);
		changed = true;
	}

	if ("Fatigue" in _movementCosts && "BH_MovementPreviewFatigue" in _actor.m && _actor.m.BH_MovementPreviewFatigue != null)
	{
		_movementCosts.Fatigue = ::Math.max(0, ::Math.min(_actor.getFatigueMax(), _actor.m.BH_MovementPreviewFatigue) - startFatigue);
		changed = true;
	}

	if (!changed)
	{
		if ("ActionPoints" in _movementCosts)
		{
			local pursuitActionPoints = ::Brotherhood.getPursuerActionPoints(_actor);
			if (pursuitActionPoints > 0)
			{
				_movementCosts.ActionPoints = ::Math.max(0, _movementCosts.ActionPoints - ::Math.min(_movementCosts.ActionPoints, pursuitActionPoints));
				changed = true;
			}
		}

		if ("Fatigue" in _movementCosts && ::Brotherhood.hasPursuerFatigueFreeMovement(_actor))
		{
			_movementCosts.Fatigue = 0;
			changed = true;
		}
	}

	if (changed)
	{
		if ("bhMovementCostsAdjusted" in _movementCosts) _movementCosts.bhMovementCostsAdjusted = true;
		else _movementCosts.bhMovementCostsAdjusted <- true;
		if ("IsMissingActionPoints" in _movementCosts) _movementCosts.IsMissingActionPoints = _movementCosts.ActionPoints > _actor.getActionPoints();
		if ("IsMissingFatigue" in _movementCosts) _movementCosts.IsMissingFatigue = _actor.getFatigue() + _movementCosts.Fatigue > _actor.getFatigueMax();
	}

	return changed;
}

::Brotherhood.beginMovementPreviewResourceCheck <- function( _actor )
{
	local projection = ::Brotherhood.getMovementPreviewResourceProjection(_actor);
	if (projection == null) return null;

	local ret = {
		ActionPoints = _actor.m.ActionPoints,
		Fatigue = _actor.m.Fatigue
	};

	_actor.m.ActionPoints = projection.ActionPoints;
	_actor.m.Fatigue = projection.Fatigue;
	return ret;
}

::Brotherhood.endMovementPreviewResourceCheck <- function( _actor, _state )
{
	if (_actor == null || _state == null) return;

	_actor.m.ActionPoints = _state.ActionPoints;
	_actor.m.Fatigue = _state.Fatigue;
}

::Brotherhood.refreshMovementPreviewSkillState <- function( _actor )
{
	if (!::Brotherhood.hasMovementPreview(_actor)) return;

	_actor.getSkills().update();
	_actor.setDirty(true);
}

::Brotherhood.getMovementStepActionPointCost <- function( _actor, _tile, _levelDifference )
{
	local terrainBaseCost = ::Brotherhood.getTerrainBaseActionPointCost(_actor, _tile.Type);
	local apCost = ::Math.max(1, (terrainBaseCost + _actor.m.CurrentProperties.MovementAPCostAdditional) * _actor.m.CurrentProperties.MovementAPCostMult);

	if (_levelDifference != 0)
	{
		apCost = apCost + _actor.m.LevelActionPointCost;
	}

	return apCost;
}

::Brotherhood.getTerrainBaseActionPointCost <- function( _actor, _terrainType )
{
	if (_terrainType == ::Const.Tactical.TerrainType.RoughGround || _terrainType == ::Const.Tactical.TerrainType.Forest)
	{
		return 2;
	}

	if (_terrainType == ::Const.Tactical.TerrainType.Swamp)
	{
		return 3;
	}

	return _actor.m.ActionPointCosts[_terrainType];
}

::Brotherhood.isTerrainActionPointCostOverridden <- function( _terrainType )
{
	return _terrainType == ::Const.Tactical.TerrainType.RoughGround
		|| _terrainType == ::Const.Tactical.TerrainType.Forest
		|| _terrainType == ::Const.Tactical.TerrainType.Swamp;
}

::Brotherhood.beginTerrainActionPointCostOverride <- function( _actor, _tile )
{
	if (_actor == null || _tile == null) return null;

	if (!::Brotherhood.isTerrainActionPointCostOverridden(_tile.Type)) return null;

	local ret = {
		TileType = _tile.Type,
		ActionPointCost = _actor.m.ActionPointCosts[_tile.Type]
	};
	_actor.m.ActionPointCosts[_tile.Type] = ::Brotherhood.getTerrainBaseActionPointCost(_actor, _tile.Type);
	return ret;
}

::Brotherhood.endTerrainActionPointCostOverride <- function( _actor, _adjustment )
{
	if (_actor == null || _adjustment == null) return;
	_actor.m.ActionPointCosts[_adjustment.TileType] = _adjustment.ActionPointCost;
}

::Brotherhood.getMovementStepPreviewCosts <- function( _actor, _tile )
{
	if (_actor == null || _tile == null || !_actor.isPlacedOnMap()) return null;

	local levelDifference = _tile.Level - _actor.getTile().Level;
	local baseActionPointCost = ::Brotherhood.getMovementStepActionPointCost(_actor, _tile, levelDifference);
	local plan = ::Brotherhood.getMovementStepActionPointPlan(_actor, _tile, baseActionPointCost);
	local effectiveActionPointCost = ::Math.max(0, baseActionPointCost - plan.Discount);
	local speedsterPreviewRefund = ::Brotherhood.isMovementNavigatorPreviewing(_actor) ? ::Brotherhood.getSpeedsterMovementPreviewRefund(_actor, effectiveActionPointCost, baseActionPointCost) : 0;

	return {
		ActionPointCost = ::Math.max(0, effectiveActionPointCost - speedsterPreviewRefund),
		FatigueCost = ::Brotherhood.getMovementStepFatigueCost(_actor, _tile, levelDifference, plan),
		BaseActionPointCost = baseActionPointCost,
		LevelDifference = levelDifference,
		PursuerDiscount = plan.PursuerDiscount
	};
}

::Brotherhood.getMovementStepActionPointPlan <- function( _actor, _tile, _baseCost )
{
	local plan = {
		BaseCost = _baseCost,
		Discount = 0,
		Vantage = null,
		VantageDiscount = 0,
		VantageTriggersUphill = false,
		VantageUsesFollowupMove = false,
		VantageFollowupDiscount = 0,
		VantageFatigueMode = null,
		LightFeet = null,
		LightFeetDiscount = 0,
		LittleDevil = null,
		Pursuer = null,
		PursuerDiscount = 0
	};

	if (_actor == null || _tile == null || _baseCost <= 0) return plan;
	if (::Brotherhood.isMovementNavigatorPreviewing(_actor) && (!("BH_SpeedsterPreviewActive" in _actor.m) || !_actor.m.BH_SpeedsterPreviewActive))
	{
		::Brotherhood.resetMovementActionPointPreview(_actor);
	}

	local skills = _actor.getSkills();
	local remainingCost = _baseCost;
	local vantage = skills.getSkillByID("perk.bh_vantage");
	local hasMovedUphill = vantage == null ? true : vantage.m.HasMovedUphill;
	local hasUsedFollowupMove = vantage == null ? true : vantage.m.HasUsedFollowupMove;
	if (vantage != null && ::Brotherhood.isMovementNavigatorPreviewing(_actor) && "BH_VantagePreviewHasMovedUphill" in _actor.m)
	{
		hasMovedUphill = _actor.m.BH_VantagePreviewHasMovedUphill;
		hasUsedFollowupMove = _actor.m.BH_VantagePreviewHasUsedFollowupMove;
	}

	local levelDifference = _actor.isPlacedOnMap() ? _tile.Level - _actor.getTile().Level : 0;
	local triggersUphill = vantage != null && levelDifference > 0 && !hasMovedUphill;
	if (levelDifference != 0 && ::Brotherhood.hasVantageActionPointDiscount(_actor) && remainingCost > 2)
	{
		local discount = ::Math.min(1, remainingCost - 2);
		plan.Discount += discount;
		plan.Vantage = vantage;
		plan.VantageDiscount = discount;
		remainingCost = remainingCost - discount;
	}

	if (vantage != null)
	{
		plan.VantageTriggersUphill = triggersUphill;
		if (levelDifference != 0)
		{
			plan.Vantage = vantage;
			plan.VantageFatigueMode = "Free";
		}

		if (!triggersUphill && hasMovedUphill && !hasUsedFollowupMove)
		{
			plan.Vantage = vantage;
			plan.VantageUsesFollowupMove = true;
			plan.VantageFatigueMode = "Half";

			if (remainingCost > 1)
			{
				local discount = ::Math.min(1, remainingCost - 1);
				plan.Discount += discount;
				plan.VantageFollowupDiscount = discount;
				remainingCost = remainingCost - discount;
			}
		}
	}

	local lightFeet = skills.getSkillByID("perk.bh_light_feet");
	if (lightFeet != null)
	{
		plan.LightFeet = lightFeet;
		local lightFeetTriggered = lightFeet.m.HasTriggered;
		if (::Brotherhood.isMovementNavigatorPreviewing(_actor) && "BH_LightFeetPreviewTilesMoved" in _actor.m)
		{
			lightFeetTriggered = _actor.m.BH_LightFeetPreviewTriggered;
		}

		if (!lightFeetTriggered && _baseCost == 2 && remainingCost > 0)
		{
			local discount = ::Math.min(1, remainingCost);
			plan.Discount += discount;
			plan.LightFeetDiscount = discount;
			remainingCost -= discount;
		}
	}

	local pursuer = skills.getSkillByID("perk.bh_pursuer");
	local pursuitActionPoints = ::Brotherhood.getPursuerActionPoints(_actor);
	if (pursuer != null && pursuitActionPoints > 0 && remainingCost > 0)
	{
		local discount = ::Math.min(remainingCost, pursuitActionPoints);
		plan.Discount += discount;
		plan.Pursuer = pursuer;
		plan.PursuerDiscount = discount;
	}

	return plan;
}

::Brotherhood.commitMovementStepActionPointPlan <- function( _actor, _plan, _effectiveCost, _speedsterProgressCost = null )
{
	if (_plan.LittleDevil != null)
	{
		_plan.LittleDevil.m.HasDiscountedThisMove = true;
		_plan.LittleDevil.m.IsSpent = true;
	}

	if (_plan.Vantage != null)
	{
		if (_plan.VantageTriggersUphill)
		{
			_plan.Vantage.m.HasMovedUphill = true;
			_plan.Vantage.m.HasLowerGroundAttackBonus = true;
		}

		if (_plan.VantageUsesFollowupMove)
		{
			_plan.Vantage.m.HasUsedFollowupMove = true;
		}
	}

	if (_plan.LightFeet != null)
	{
		::Brotherhood.logArchetypeTest("LIGHT FEET", _actor, "Movement step committed: base AP cost " + _plan.BaseCost + ", Light Feet discount " + _plan.LightFeetDiscount + ", final AP cost " + _effectiveCost + ". Triggered before step: " + _plan.LightFeet.m.HasTriggered + ".");
		_plan.LightFeet.recordMovementTile(_plan.LightFeetDiscount > 0);
	}

	if (_speedsterProgressCost == null) _speedsterProgressCost = _effectiveCost;
	if (_speedsterProgressCost > 0)
	{
		::Brotherhood.recordSpeedsterMovement(_actor, _speedsterProgressCost);
	}
}

::Brotherhood.resetMovementActionPointPreview <- function( _actor )
{
	if (_actor == null || !("m" in _actor)) return;

	local speedster = _actor.getSkills().getSkillByID("perk.bh_speedster");
	_actor.m.BH_SpeedsterPreviewMovementAPSpent = speedster != null ? speedster.m.ActionPointsSpentOnMovement : 0;
	_actor.m.BH_SpeedsterPreviewTriggered = speedster != null ? speedster.m.HasTriggered : true;
	_actor.m.BH_SpeedsterPreviewActive = true;

	_actor.m.BH_PursuerPreviewActionPoints = 0;
	_actor.m.BH_MovementPreviewActionPointRefund = 0;
	_actor.m.BH_MovementPreviewStartActionPoints = _actor.m.ActionPoints;
	_actor.m.BH_MovementPreviewStartFatigue = _actor.m.Fatigue;
	_actor.m.BH_MovementPreviewActionPoints = null;
	_actor.m.BH_MovementPreviewFatigue = null;
	_actor.m.BH_MovementPreviewUndoStack = [];

	local littleDevil = _actor.getSkills().getSkillByID("perk.bh_little_devil");
	_actor.m.BH_LittleDevilPreviewSpent = littleDevil != null ? littleDevil.m.IsSpent : true;

	local vantage = _actor.getSkills().getSkillByID("perk.bh_vantage");
	_actor.m.BH_VantagePreviewHasMovedUphill = vantage != null ? vantage.m.HasMovedUphill : true;
	_actor.m.BH_VantagePreviewHasUsedFollowupMove = vantage != null ? vantage.m.HasUsedFollowupMove : true;
	_actor.m.BH_VantagePreviewHasLowerGroundAttackBonus = vantage != null ? vantage.m.HasLowerGroundAttackBonus : false;

	local lightFeet = _actor.getSkills().getSkillByID("perk.bh_light_feet");
	_actor.m.BH_LightFeetPreviewTilesMoved = lightFeet != null ? lightFeet.m.MovementTilesThisTurn : 0;
	_actor.m.BH_LightFeetPreviewTriggered = lightFeet != null ? lightFeet.m.HasTriggered : true;
}

::Brotherhood.getSpeedsterMovementPreviewRefund <- function( _actor, _effectiveCost, _speedsterProgressCost = null )
{
	return 0;
}

::Brotherhood.getMovementPreviewActionPointBudgetBonus <- function( _actor, _actionPoints )
{
	if (_actor == null || !_actor.isPlayerControlled()) return 0;
	if (::Tactical.TurnSequenceBar.getActiveEntity() == null || ::Tactical.TurnSequenceBar.getActiveEntity().getID() != _actor.getID()) return 0;

	local bonus = 0;
	local skills = _actor.getSkills();

	bonus += ::Brotherhood.getPursuerActionPoints(_actor);

	local lightFeet = skills.getSkillByID("perk.bh_light_feet");
	if (lightFeet != null && !lightFeet.m.HasTriggered)
	{
		bonus += 1;
	}

	return bonus;
}

::Brotherhood.getMovementPreviewActionPointRefund <- function( _actor )
{
	if (_actor == null || !("m" in _actor)) return 0;
	if (!_actor.isPreviewing() || _actor.getPreviewMovement() == null) return 0;
	if (!("BH_MovementPreviewActionPointRefund" in _actor.m)) return 0;

	return _actor.m.BH_MovementPreviewActionPointRefund;
}

::Brotherhood.isAdjacentPreviewTile <- function( _actor, _tile )
{
	return _actor != null && _tile != null && _actor.isPlacedOnMap() && _tile.getDistanceTo(_actor.getTile()) == 1;
}

::Brotherhood.applyMovementCostTextToTooltipEntry <- function( _entry, _costs )
{
	if (_entry == null || _costs == null || !("text" in _entry) || _entry.text == null) return false;

	local suffixIndex = _entry.text.find(" to traverse");
	if (suffixIndex == null) return false;

	_entry.text = "Costs " + ::MSU.Text.colorPositive(_costs.ActionPointCost) + " AP and " + ::MSU.Text.colorPositive(_costs.FatigueCost) + " Fatigue" + _entry.text.slice(suffixIndex);
	return true;
}

::Brotherhood.applyMovementPreviewResourceBarsToTooltip <- function( _entries, _actor )
{
	if (_entries == null) return _entries;

	local projection = ::Brotherhood.getMovementPreviewResourceProjection(_actor);
	if (projection == null) return _entries;

	foreach (entry in _entries)
	{
		if (!("type" in entry) || entry.type != "progressbar") continue;
		if (!("icon" in entry) || entry.icon == null) continue;

		if (entry.icon == "ui/icons/fatigue.png")
		{
			entry.value = projection.Fatigue;
			entry.valueMax = _actor.getFatigueMax();
			entry.text = "" + projection.Fatigue + " / " + _actor.getFatigueMax();
		}
		else if (entry.icon == "ui/icons/action_points.png")
		{
			entry.value = projection.ActionPoints;
			entry.valueMax = _actor.getActionPointsMax();
			entry.text = "" + projection.ActionPoints + " / " + _actor.getActionPointsMax();
		}
	}

	return _entries;
}

::Brotherhood.applyLittleDevilPreviewFatigueRefund <- function( _actor, _fatigueBeforeStep )
{
	if (_actor == null) return;

	local fatigueSpent = ::Math.max(0, _actor.getFatigue() - _fatigueBeforeStep);
	if (fatigueSpent > 0)
	{
		_actor.setFatigue(::Math.max(0, _actor.getFatigue() - ::Math.floor(fatigueSpent * 0.5)));
	}
}

::Brotherhood.adjustMovementTileTooltip <- function( _entries, _actor )
{
	if (_entries == null) return _entries;
	local refund = ::Brotherhood.getMovementPreviewActionPointRefund(_actor);
	local previewMovement = _actor != null ? _actor.getPreviewMovement() : null;
	local hoveredTile = ::Tactical.State.getLastTileHovered();
	local isAdjacentPreviewTile = ::Brotherhood.isAdjacentPreviewTile(_actor, hoveredTile);
	local isSingleTilePreview = (previewMovement != null && previewMovement.Tiles == 1) || isAdjacentPreviewTile;
	local previewCosts = null;

	if (isAdjacentPreviewTile) previewCosts = ::Brotherhood.getMovementStepPreviewCosts(_actor, hoveredTile);
	else if (previewMovement != null && hoveredTile != null && "End" in previewMovement && previewMovement.End != null && previewMovement.End.isSameTileAs(hoveredTile))
	{
		previewCosts = ::Brotherhood.getMovementPreviewAggregateCosts(_actor);
	}

	if ((refund <= 0 || !isSingleTilePreview) && previewCosts == null) return _entries;

	foreach (entry in _entries)
	{
		if (!("text" in entry) || entry.text == null) continue;
		if (previewCosts != null && ::Brotherhood.applyMovementCostTextToTooltipEntry(entry, previewCosts)) continue;

		if (refund > 0 && isSingleTilePreview)
		{
			for (local raw = 20; raw >= 0; --raw)
			{
				local needle = "Costs " + raw + " AP";
				if (entry.text.find(needle) == null) continue;

				local adjusted = ::Math.max(0, raw - refund);
				entry.text = ::String.replace(entry.text, needle, "Costs " + adjusted + " AP");
				break;
			}

			for (local raw = 20; raw >= 0; --raw)
			{
				local needle = "Costs " + raw + " + 0 AP";
				if (entry.text.find(needle) == null) continue;

				local adjusted = ::Math.max(0, raw - refund);
				entry.text = ::String.replace(entry.text, needle, "Costs " + adjusted + " AP");
				break;
			}
		}

	}

	if (previewCosts != null && "PursuerDiscount" in previewCosts && previewCosts.PursuerDiscount > 0)
	{
		_entries.push({
			id = 991,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Pursuer spends " + ::MSU.Text.colorPositive(previewCosts.PursuerDiscount) + " Pursuit AP on this move.")
		});
	}

	return _entries;
}

::Brotherhood.commitMovementStepActionPointPreview <- function( _actor, _plan, _effectiveCost, _speedsterRefundApplied = false, _speedsterProgressCost = null, _uiActionPointRefund = 0 )
{
	if (_actor == null || !("m" in _actor)) return;

	if (_uiActionPointRefund > 0)
	{
		_actor.m.BH_MovementPreviewActionPointRefund += _uiActionPointRefund;
	}

	if (_plan.LittleDevil != null)
	{
		_actor.m.BH_LittleDevilPreviewSpent = true;
	}

	if (_plan.Pursuer != null && _plan.PursuerDiscount > 0)
	{
		_actor.m.BH_PursuerPreviewActionPoints = ::Math.max(0, _actor.m.BH_PursuerPreviewActionPoints - _plan.PursuerDiscount);
	}

	if (_plan.Vantage != null)
	{
		if (_plan.VantageTriggersUphill)
		{
			_actor.m.BH_VantagePreviewHasMovedUphill = true;
			_actor.m.BH_VantagePreviewHasLowerGroundAttackBonus = true;
		}

		if (_plan.VantageUsesFollowupMove)
		{
			_actor.m.BH_VantagePreviewHasUsedFollowupMove = true;
		}
	}

	if (_plan.LightFeet != null)
	{
		_actor.m.BH_LightFeetPreviewTilesMoved += 1;
		if (_plan.LightFeetDiscount > 0)
		{
			_actor.m.BH_LightFeetPreviewTriggered = true;
		}
	}

	if (_speedsterProgressCost == null) _speedsterProgressCost = _effectiveCost;
	if (false && _speedsterProgressCost > 0)
	{
		local speedster = _actor.getSkills().getSkillByID("perk.bh_speedster");
		if (speedster != null)
		{
			if (!("BH_SpeedsterPreviewActive" in _actor.m) || !_actor.m.BH_SpeedsterPreviewActive)
			{
				::Brotherhood.resetMovementActionPointPreview(_actor);
			}

			if (!_actor.m.BH_SpeedsterPreviewTriggered)
			{
				_actor.m.BH_SpeedsterPreviewMovementAPSpent += _speedsterProgressCost;
				if (_actor.m.BH_SpeedsterPreviewMovementAPSpent >= ::Brotherhood.SpeedsterActionPointThreshold)
				{
					if (!_speedsterRefundApplied)
					{
						_actor.m.ActionPoints = ::Math.min(_actor.getActionPointsMax(), _actor.m.ActionPoints + 2);
					}

					_actor.setPreviewActionPoints(_actor.m.ActionPoints);
					_actor.m.BH_SpeedsterPreviewTriggered = true;
				}
			}
		}
	}
}

::Brotherhood.pushMovementPreviewUndoCost <- function( _actor, _tile, _levelDifference, _baseActionPointCost, _actionPointCost, _fatigueCost )
{
	if (_actor == null || !("m" in _actor) || _tile == null) return;
	if (!("BH_MovementPreviewUndoStack" in _actor.m)) return;

	_actor.m.BH_MovementPreviewUndoStack.push({
		BaseActionPointCost = ::Math.max(0, _baseActionPointCost),
		ActionPointCost = ::Math.max(0, _actionPointCost),
		BaseFatigueCost = ::Brotherhood.getMovementStepBaseFatigueCost(_actor, _tile, _levelDifference),
		FatigueCost = ::Math.max(0, _fatigueCost)
	});
}

::Brotherhood.popMovementPreviewUndoCost <- function( _actor )
{
	if (_actor == null || !("m" in _actor) || !("BH_MovementPreviewUndoStack" in _actor.m)) return null;
	if (_actor.m.BH_MovementPreviewUndoStack.len() == 0) return null;

	local index = _actor.m.BH_MovementPreviewUndoStack.len() - 1;
	local ret = _actor.m.BH_MovementPreviewUndoStack[index];
	_actor.m.BH_MovementPreviewUndoStack.remove(index);
	return ret;
}

::Brotherhood.zeroTalents <- function( _player )
{
	if (_player == null || !("m" in _player)) return;

	_player.m.Talents.resize(::Const.Attributes.COUNT, 0);

	for (local i = 0; i < ::Const.Attributes.COUNT; ++i)
	{
		_player.m.Talents[i] = 0;
	}
}

::Brotherhood.disablePlayerPerkTree <- function( _player )
{
	if (_player == null || !("m" in _player)) return;
	if (!("DynamicPerks" in getroottable())) return;

	local perkTree = ::Brotherhood.createEmptyPerkTree();
	perkTree.setActor(_player);
	perkTree.build();
	_player.m.PerkTree = perkTree;

	if ("PerkTier" in _player.m)
	{
		_player.m.PerkTier = ::DynamicPerks.Const.DefaultPerkTier;
	}
}

::Brotherhood.clearTestingExtras <- function( _player )
{
	if (_player == null || !("m" in _player)) return;

	::Brotherhood.zeroTalents(_player);

	if ("Attributes" in _player.m)
	{
		_player.m.Attributes.clear();
		_player.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
	}

	if ("PerkPoints" in _player.m) _player.m.PerkPoints = 0;
	if ("PerkPointsSpent" in _player.m) _player.m.PerkPointsSpent = 0;

	local skills = _player.getSkills();
	local extras = skills.getSkillsByFunction(function( _skill )
	{
		if (_skill.isType(::Const.SkillType.Background)) return false;
		return _skill.isType(::Const.SkillType.Trait) || _skill.isType(::Const.SkillType.Perk);
	});

	foreach (skill in extras)
	{
		skills.removeByID(skill.getID());
	}

	::Brotherhood.disablePlayerPerkTree(_player);
	skills.update();
}

::Brotherhood.createEmptyPerkTree <- function()
{
	return ::new(::DynamicPerks.Class.PerkTree).init({
		DynamicMap = {
			"pgc.rf_always": [
				"pg.bh_survival"
			]
		}
	});
}

::Brotherhood.isTestingPerkTree <- function( _perkTree )
{
	if (!::Brotherhood.TestingMode) return false;
	local actor = _perkTree.getActor();
	return !::MSU.isNull(actor) && ::MSU.isKindOf(actor, "player");
}

::Brotherhood.isFleshcraftPerkTree <- function( _perkTree )
{
	if (!::Brotherhood.FleshcraftGenerationEnabled) return false;
	local actor = _perkTree.getActor();
	return !::MSU.isNull(actor) && ::MSU.isKindOf(actor, "player");
}

::Brotherhood.pickSurvivalPerks <- function()
{
	local pool = ::Brotherhood.SurvivalPerks.filter(@(_, _perkID) ::Brotherhood.isActiveObsidianPerk(_perkID));
	local ret = [];

	for (local i = 0; i < 2 && pool.len() != 0; ++i)
	{
		ret.push(pool.remove(::Math.rand(0, pool.len() - 1)));
	}

	return ret;
}

::Brotherhood.pickMobilityPerks <- function()
{
	return [];
}

::Brotherhood.pickBardPerks <- function()
{
	local pool = clone ::Brotherhood.BardPerks;
	local ret = [];

	for (local i = 0; i < 1 && pool.len() != 0; ++i)
	{
		ret.push(pool.remove(::Math.rand(0, pool.len() - 1)));
	}

	return ret;
}

::Brotherhood.removePerkFromGroup <- function( _groupID, _perkID )
{
	local group = ::DynamicPerks.PerkGroups.findById(_groupID);
	if (group == null) return;
	if (group.hasPerk(_perkID)) group.removePerk(_perkID);
}

::Brotherhood.removePerkFromAllGroups <- function( _perkID )
{
	foreach (groupID, group in ::DynamicPerks.PerkGroups.getAll())
	{
		if (group.hasPerk(_perkID)) group.removePerk(_perkID);
	}
}

::Brotherhood.keepPerkOnlyInSurvivalGroup <- function( _perkID )
{
	foreach (groupID, group in ::DynamicPerks.PerkGroups.getAll())
	{
		if (groupID != "pg.bh_survival" && group.hasPerk(_perkID))
		{
			group.removePerk(_perkID);
		}
	}

	local perkDef = ::Const.Perks.findById(_perkID);
	if (perkDef == null || !("PerkGroupIDs" in perkDef)) return;

	::Brotherhood.keepOnlyTestingPerkGroupIDs(perkDef);
}

::Brotherhood.keepPerkOnlyInMobilityGroup <- function( _perkID )
{
	foreach (groupID, group in ::DynamicPerks.PerkGroups.getAll())
	{
		if (groupID != "pg.bh_mobility" && group.hasPerk(_perkID))
		{
			group.removePerk(_perkID);
		}
	}

	local perkDef = ::Const.Perks.findById(_perkID);
	if (perkDef == null || !("PerkGroupIDs" in perkDef)) return;

	::Brotherhood.keepOnlyTestingPerkGroupIDs(perkDef);
}

::Brotherhood.keepOnlyTestingGroup <- function( _perkID )
{
	if (::Brotherhood.isSurvivalOnlyPerk(_perkID))
	{
		::Brotherhood.keepPerkOnlyInSurvivalGroup(_perkID);
	}
	else if (::Brotherhood.isMobilityOnlyPerk(_perkID))
	{
		::Brotherhood.keepPerkOnlyInMobilityGroup(_perkID);
	}
}

::Brotherhood.isHoldingWeapon <- function( _actor )
{
	if (_actor == null) return false;

	local mainhand = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	if (::Brotherhood.isThreateningWeaponItem(mainhand)) return true;

	local offhand = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
	return ::Brotherhood.isThreateningWeaponItem(offhand);
}

::Brotherhood.isEmptyHanded <- function( _actor )
{
	if (_actor == null) return false;

	return !::Brotherhood.isHoldingWeapon(_actor);
}

::Brotherhood.isThreateningWeaponItem <- function( _item )
{
	if (_item == null) return false;
	if ("m" in _item && "IsInstrument" in _item.m && _item.m.IsInstrument) return false;

	local id = _item.getID().tolower();
	if (id.find("lute") != null) return false;
	if (id.find("net") != null) return false;
	if (id.find("shield") != null) return false;

	return _item.isItemType(::Const.Items.ItemType.Weapon);
}

::Brotherhood.hasArmedAllyInAttackRange <- function( _attacker, _target, _skill )
{
	if (_attacker == null || _target == null || _skill == null || !::Tactical.isActive()) return false;
	local originTile = _attacker.getTile();

	foreach (ally in ::Tactical.Entities.getInstancesOfFaction(_target.getFaction()))
	{
		if (ally == null || ally.getID() == _target.getID()) continue;
		if (!ally.isAlive() || ally.isDying() || !ally.isPlacedOnMap()) continue;
		if (!::Brotherhood.isHoldingWeapon(ally)) continue;
		if (_skill.isInRange(ally.getTile(), originTile)) return true;
	}

	return false;
}

::Brotherhood.removeReachTooltipEntries <- function( _entries )
{
	if (_entries == null) return _entries;

	for (local i = _entries.len() - 1; i >= 0; --i)
	{
		local entry = _entries[i];
		if (entry == null) continue;

		if ("children" in entry && entry.children != null)
		{
			entry.children = ::Brotherhood.removeReachTooltipEntries(entry.children);
		}

		local isReachEntry = false;
		if ("icon" in entry && entry.icon != null)
		{
			local icon = entry.icon.tolower();
			isReachEntry = icon.find("rf_reach") != null || icon.find("reach") != null;
		}

		if (isReachEntry)
		{
			_entries.remove(i);
			continue;
		}

		if ("text" in entry && entry.text != null)
		{
			local text = entry.text.tolower();
			if (text.find("concept.reach") != null
				|| text.find("reach advantage") != null
				|| text.find("rf_reach") != null
				|| text.find("rf_tacticaltooltipreach") != null)
			{
				_entries.remove(i);
			}
		}
	}

	return _entries;
}

::Brotherhood.ItemLockFlag <- "BH_ItemLocked";

::Brotherhood.isItemLocked <- function( _item )
{
	if (_item != null && _item.getFlags().has(::Brotherhood.ItemLockFlag)) _item.getFlags().remove(::Brotherhood.ItemLockFlag);
	return false;
}

::Brotherhood.toggleItemLock <- function( _item )
{
	if (_item != null && _item.getFlags().has(::Brotherhood.ItemLockFlag)) _item.getFlags().remove(::Brotherhood.ItemLockFlag);
	return false;
}

::Brotherhood.findGroundItem <- function( _entity, _itemID )
{
	if (_entity == null || _entity.getTile() == null) return null;
	foreach (item in _entity.getTile().Items)
	{
		if (item != null && item.getInstanceID() == _itemID) return item;
	}
	return null;
}

::Brotherhood.resolveUIItem <- function( _context, _entityID, _itemID, _itemOwner )
{
	local entity = _entityID != null ? ::Tactical.getEntityByID(_entityID) : null;
	switch (_itemOwner)
	{
	case "entity":
	case "character-screen-inventory-list-module.paperdoll":
	case "character-screen-inventory-list-module.backpack":
		return entity != null ? entity.getItems().getItemByInstanceID(_itemID) : null;

	case "ground":
	case "character-screen-inventory-list-module.ground":
		return ::Brotherhood.findGroundItem(entity, _itemID);

	case "stash":
	case "character-screen-inventory-list-module.stash":
	case "tactical-combat-result-screen.stash":
	case "world-town-screen-shop-dialog-module.stash":
		local stash = ::World.Assets.getStash();
		local result = stash != null ? stash.getItemByInstanceID(_itemID) : null;
		return result != null ? result.item : null;

	case "tactical-combat-result-screen.found-loot":
		local result = ::Tactical.CombatResultLoot.getItemByInstanceID(_itemID);
		return result != null ? result.item : null;

	case "world-town-screen-shop-dialog-module.shop":
		local stash = ::World.State.getTownScreen().getShopDialogModule().getShop().getStash();
		if (stash == null) return null;
		local result = stash.getItemByInstanceID(_itemID);
		return result != null ? result.item : null;
	}

	return null;
}

::Brotherhood.comparisonDeltaText <- function( _candidate, _equipped, _suffix = "" )
{
	local delta = _candidate - _equipped;
	local deltaText = (delta > 0 ? "+" : "") + delta + _suffix;
	if (delta > 0) return ::MSU.Text.colorPositive("Higher by " + deltaText);
	if (delta < 0) return ::MSU.Text.colorNegative("Lower by " + deltaText);
	return "Equal";
}

::Brotherhood.addComparisonRow <- function( _tooltip, _label, _candidate, _equipped, _suffix = "", _icon = "ui/icons/special.png" )
{
	_tooltip.push({
		id = 910 + _tooltip.len(),
		type = "text",
		icon = _icon,
		text = _label + ": " + _candidate + _suffix + " vs " + _equipped + _suffix + " (" + ::Brotherhood.comparisonDeltaText(_candidate, _equipped, _suffix) + ")"
	});
}

::Brotherhood.addItemComparison <- function( _tooltip, _candidate, _equipped )
{
	if (_tooltip == null || _candidate == null || _equipped == null) return _tooltip;

	_tooltip.push({
		id = 909,
		type = "text",
		icon = "ui/icons/special.png",
		text = "Compared with equipped: " + ::MSU.Text.colorPositive(_equipped.getName())
	});

	if (_candidate.isItemType(::Const.Items.ItemType.Weapon) && _equipped.isItemType(::Const.Items.ItemType.Weapon))
	{
		::Brotherhood.addComparisonRow(_tooltip, "Minimum damage", _candidate.getDamageMin(), _equipped.getDamageMin(), "", "ui/icons/regular_damage.png");
		::Brotherhood.addComparisonRow(_tooltip, "Maximum damage", _candidate.getDamageMax(), _equipped.getDamageMax(), "", "ui/icons/regular_damage.png");
		::Brotherhood.addComparisonRow(_tooltip, "Armor effectiveness", ::Math.round(_candidate.getArmorDamageMult() * 100), ::Math.round(_equipped.getArmorDamageMult() * 100), "%", "ui/icons/armor_damage.png");
		::Brotherhood.addComparisonRow(_tooltip, "Armor penetration", ::Math.round((_candidate.m.DirectDamageMult + _candidate.m.DirectDamageAdd) * 100), ::Math.round((_equipped.m.DirectDamageMult + _equipped.m.DirectDamageAdd) * 100), "%", "ui/icons/direct_damage.png");
		::Brotherhood.addComparisonRow(_tooltip, "Range", _candidate.getRangeMax(), _equipped.getRangeMax(), "", "ui/icons/vision.png");
	}
	else if (_candidate.isItemType(::Const.Items.ItemType.Shield) && _equipped.isItemType(::Const.Items.ItemType.Shield))
	{
		::Brotherhood.addComparisonRow(_tooltip, "Melee defense", _candidate.getMeleeDefense(), _equipped.getMeleeDefense(), "", "ui/icons/melee_defense.png");
		::Brotherhood.addComparisonRow(_tooltip, "Ranged defense", _candidate.getRangedDefense(), _equipped.getRangedDefense(), "", "ui/icons/ranged_defense.png");
		::Brotherhood.addComparisonRow(_tooltip, "Durability", _candidate.getConditionMax(), _equipped.getConditionMax(), "", "ui/icons/asset_supplies.png");
	}
	else if ((_candidate.isItemType(::Const.Items.ItemType.Armor) && _equipped.isItemType(::Const.Items.ItemType.Armor))
		|| (_candidate.isItemType(::Const.Items.ItemType.Helmet) && _equipped.isItemType(::Const.Items.ItemType.Helmet)))
	{
		::Brotherhood.addComparisonRow(_tooltip, "Armor", _candidate.getArmorMax(), _equipped.getArmorMax(), "", "ui/icons/armor_body.png");
	}
	else if (_candidate.isItemType(::Const.Items.ItemType.Ammo) && _equipped.isItemType(::Const.Items.ItemType.Ammo))
	{
		::Brotherhood.addComparisonRow(_tooltip, "Ammunition", _candidate.getAmmoMax(), _equipped.getAmmoMax(), "", "ui/icons/ammo.png");
	}

	::Brotherhood.addComparisonRow(_tooltip, "Fatigue penalty", _candidate.getStaminaModifier(), _equipped.getStaminaModifier(), "", "ui/icons/fatigue.png");
	return _tooltip;
}

::Brotherhood.setShieldDurability <- function( _shield, _durability )
{
	if (_shield == null || !("m" in _shield)) return;

	local current = ("Condition" in _shield.m) ? _shield.m.Condition : _durability;
	local currentMax = ("ConditionMax" in _shield.m && _shield.m.ConditionMax > 0) ? _shield.m.ConditionMax : current;
	local ratio = currentMax > 0 ? current.tofloat() / currentMax.tofloat() : 1.0;
	ratio = ::Math.maxf(0.0, ::Math.minf(1.0, ratio));

	_shield.m.ConditionMax = _durability;
	_shield.m.Condition = ::Math.round(_durability * ratio);
}

::include("scripts/mods/mod_brotherhood/duelist_swashbuckler_module");
::include("scripts/mods/mod_brotherhood/urchin_nobody_scavenger_module");
::include("scripts/mods/mod_brotherhood/brute_laborer_module");
::include("scripts/mods/mod_brotherhood/artillerist_module");
::include("scripts/mods/mod_brotherhood/expansion_archetypes_module");
::include("scripts/mods/mod_brotherhood/obsidian_archetypes_module");
::include("scripts/mods/mod_brotherhood/latest_obsidian_archetypes_module");
::include("scripts/mods/mod_brotherhood/armor_doctrine_module");
::include("scripts/mods/mod_brotherhood/active_obsidian_perks");
::include("scripts/mods/mod_brotherhood/perk_debug_logging");
::include("scripts/mods/mod_brotherhood/native_obsidian_perks_module");
::include("scripts/mods/mod_brotherhood/parent_profile_data");
::include("scripts/mods/mod_brotherhood/parent_profiles");
::include("scripts/mods/mod_brotherhood/parent_rng");
::include("scripts/mods/mod_brotherhood/parent_resolver");
::include("scripts/mods/mod_brotherhood/parent_parity_fixture");
::include("scripts/mods/mod_brotherhood/parent_generation_live");
::include("scripts/mods/mod_brotherhood/fleshcraft_data");
::include("scripts/mods/mod_brotherhood/fleshcraft_engine");
::include("scripts/mods/mod_brotherhood/fleshcraft_live_module");
::include("scripts/mods/mod_brotherhood/scenario_presentation_module");
::include("scripts/mods/mod_brotherhood/archetype_test_pool");
::include("scripts/mods/mod_brotherhood/archetype_generator");
::include("scripts/mods/mod_brotherhood/wild_archetype_registry");
::include("scripts/mods/mod_brotherhood/duo_generator");
::include("scripts/mods/mod_brotherhood/chaos_generator");
::include("scripts/mods/mod_brotherhood/wild_generator");

::Brotherhood.HooksMod.queue(">mod_reforged", function() {
	::Brotherhood.Mod = ::MSU.Class.Mod(::Brotherhood.ID, ::Brotherhood.Version, ::Brotherhood.Name);
	local qolPage = ::Brotherhood.Mod.ModSettings.addPage("QualityOfLife", "Quality of Life");
	qolPage.addBooleanSetting(
		"CustomItemSwapping",
		::Brotherhood.CustomItemSwapping,
		"Custom Item Swapping",
		"Enables Brotherhood's rewritten inventory swapping behavior. Disable this to restore vanilla item swapping. Item locking and Shift + Space remain enabled."
	).addAfterChangeCallback(function( _newValue )
	{
		::Brotherhood.CustomItemSwapping = _newValue;
		::logInfo("[Brotherhood][SETTINGS] Custom Item Swapping " + (_newValue ? "enabled." : "disabled; vanilla swapping restored."));
	});

	::Brotherhood.validateEnabledArchetypes();
	::Brotherhood.initializeParentGeneration();
	::Brotherhood.validateFleshcraftData();
	// Plague Doctor and Fleshcraft reference the custom Crippling Strikes owned
	// by Executioner, so fighting-style definitions must exist before the legacy
	// parent registrars validate their memberships.
	::Brotherhood.initializeDuelistAndSwashbuckler();
	// Fleshcraft parents reference perks owned by these legacy content modules.
	// Register their definitions here, after Reforged/UPD exist and before any
	// live parent validation or Reforged perk-group construction can consume them.
	::Brotherhood.registerSurvivalPerks();
	::Brotherhood.registerPlagueDoctorPerks();
	::Brotherhood.registerMobilityPerks();
	::Brotherhood.initializeUrchinNobodyScavenger();
::Brotherhood.initializeBruteAndLaborer();
	::Brotherhood.initializeExpansionArchetypes();
	::Brotherhood.initializeObsidianArchetypes();
	::Brotherhood.initializeLatestObsidianArchetypes();
	::Brotherhood.initializeNativeObsidianPerks();
	::Brotherhood.initializePerkDebugLogging();
	::Brotherhood.initializeArtillerist();
	::Brotherhood.initializeArmorDoctrines();
	::Brotherhood.initializeFleshcraftLive();
	foreach (perkID, icons in ::Brotherhood.CustomPerkIcons)
	{
		local perkDefinition = ::Const.Perks.findById(perkID);
		if (perkDefinition == null) continue;
		perkDefinition.Icon = icons[0];
		perkDefinition.IconDisabled = icons[1];
	}
	::Brotherhood.initializeReforgedScenarioPresentation();
	::Brotherhood.initializeWildGeneration();

	::Brotherhood.HooksMod.hook("scripts/states/tactical_state", function(q) {
		q.helper_handleContextualKeyInput = @(__original) { function helper_handleContextualKeyInput( _key )
		{
			// Space normally waits. Shift+Space ends only the active brother's turn.
			if (_key.getState() == 0 && _key.getKey() == 44 && _key.getModifier() == 1
				&& !this.isInLoadingScreen() && !this.isBattleEnded()
				&& !this.isInputLocked() && !this.isInCharacterScreen()
				&& !this.m.MenuStack.hasBacksteps())
			{
				local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
				if (activeEntity != null && activeEntity.isPlayerControlled())
				{
					::logInfo("[Brotherhood][SHIFT SPACE] Ending the active turn for " + activeEntity.getName() + ".");
					this.Tactical.TurnSequenceBar.initNextTurn();
					return true;
				}
			}

			return __original(_key);
		}}.helper_handleContextualKeyInput;

		q.gatherLoot = @(__original) { function gatherLoot()
		{
			local result = this.Tactical.Entities.getCombatResult();
			local isVictory = result == this.Const.Tactical.CombatResult.EnemyDestroyed || result == this.Const.Tactical.CombatResult.EnemyRetreated;
			local isArena = !this.isScenarioMode() && this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode;
			local isLootingProhibited = this.m.StrategicProperties != null && this.m.StrategicProperties.IsLootingProhibited;

			if (isVictory && !isArena && !isLootingProhibited)
			{
				local capturedEnemies = 0;
				local capturedItems = 0;
				foreach (enemy in this.Tactical.Entities.getAllInstancesAsArray())
				{
					if (!enemy.isAlive() || enemy.isPlayerControlled() || enemy.isAlliedWithPlayer()) continue;
					if (enemy.getMoraleState() != this.Const.MoraleState.Fleeing || !enemy.getSkills().hasSkill("effects.net")) continue;

					local items = enemy.getItems().getAllItems();
					foreach (item in items) item.onCombatFinished();
					enemy.getItems().transferToStash(this.m.CombatResultLoot);
					++capturedEnemies;
					capturedItems += items.len();
				}

				if (capturedEnemies > 0)
				{
					::logInfo("[Brotherhood][CAPTURED LOOT] Recovered " + capturedItems + " item(s) from " + capturedEnemies + " netted fleeing enemy/enemies.");
				}
			}

			return __original();
		}}.gatherLoot;

		q.gatherBrothers = @(__original) { function gatherBrothers( _isVictory )
		{
			local participants = [];
			local participantIDs = {};
			local addParticipant = function( _bro )
			{
				if (_bro == null || !this.isKindOf(_bro, "player")) return;
				local id = _bro.getID().tostring();
				if (id in participantIDs) return;
				participantIDs[id] <- true;
				participants.push(_bro);
			}.bindenv(this);

			foreach (bro in this.Tactical.Entities.getAllInstancesAsArray()) addParticipant(bro);
			foreach (bro in this.Tactical.getSurvivorRoster().getAll()) addParticipant(bro);
			foreach (bro in this.Tactical.getRetreatRoster().getAll()) addParticipant(bro);

			if (!this.isScenarioMode())
			{
				foreach (bro in this.World.getPlayerRoster().getAll()) bro.getFlags().remove("BH_ReserveXPResult");
			}

			local ret = __original(_isVictory);
			if (this.isScenarioMode()) return ret;

			local lowestXP = null;
			foreach (bro in participants)
			{
				local gained = bro.getCombatStats().XPGained;
				if (gained > 0 && (lowestXP == null || gained < lowestXP)) lowestXP = gained;
			}

			if (lowestXP == null) return ret;
			local reserveXP = this.Math.floor(lowestXP * 0.25);
			if (reserveXP <= 0) return ret;

			local recipients = 0;
			foreach (bro in this.World.getPlayerRoster().getAll())
			{
				if (bro.isGuest() || bro.getID().tostring() in participantIDs) continue;

				bro.m.CombatStats.DamageDealtHitpoints = 0;
				bro.m.CombatStats.DamageDealtArmor = 0;
				bro.m.CombatStats.DamageReceivedHitpoints = 0;
				bro.m.CombatStats.DamageReceivedArmor = 0;
				bro.m.CombatStats.Kills = 0;
				bro.m.CombatStats.XPGained = 0;
				bro.addXP(reserveXP, false);
				if (bro.getCombatStats().XPGained <= 0) continue;

				bro.getFlags().set("BH_ReserveXPResult", true);
				this.m.CombatResultRoster.push(bro);
				++recipients;
			}

			if (recipients > 0)
			{
				::logInfo("[Brotherhood][RESERVE XP] " + recipients + " reserve brother(s) received 25% of the lowest participant XP award (" + reserveXP + " base XP).");
			}
			return ret;
		}}.gatherBrothers;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/global/data_helper", function(q) {
		q.convertItemToUIData = @(__original) { function convertItemToUIData( _item, _forceSmallIcon, _owner = null )
		{
			local ret = __original(_item, _forceSmallIcon, _owner);
			if (ret != null)
			{
				ret.bhLocked <- false;
				ret.bhCustomItemSwapping <- ::Brotherhood.isCustomItemSwappingEnabled();
			}
			return ret;
		}}.convertItemToUIData;

		q.convertStatisticsEntityToUIData = @(__original) { function convertStatisticsEntityToUIData( _entity )
		{
			local ret = __original(_entity);
			local receivedReserveXP = "getFlags" in _entity && _entity.getFlags().has("BH_ReserveXPResult");
			local isInVanillaReserve = "getPlaceInFormation" in _entity && _entity.getPlaceInFormation() > 17;
			ret.bhReserve <- receivedReserveXP || (isInVanillaReserve && _entity.getCombatStats().XPGained > 0);
			if (ret.bhReserve)
			{
				::logInfo("[Brotherhood][RESERVE UI] Marked " + _entity.getName() + " as In Reserve on the victory screen.");
			}
			return ret;
		}}.convertStatisticsEntityToUIData;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/modules/tooltip", function(q) {
		q.onBrotherhoodQueryUIItemComparisonTooltipData <- function( _data )
		{
			if (_data == null || _data.len() < 3 || this.m.OnQueryUIItemTooltipDataListener == null) return null;
			local entityID = _data[0];
			local itemID = _data[1];
			local itemOwner = _data[2];
			local ret = this.m.OnQueryUIItemTooltipDataListener(entityID, itemID, itemOwner);
			::logInfo("[Brotherhood][ITEM COMPARE] Requested item " + itemID + " from " + itemOwner + " for entity " + (entityID == null ? "null" : entityID) + ".");
			if (ret == null) return null;
			local result = { Hovered = ret, Equipped = null };
			if (entityID == null)
			{
				::logInfo("[Brotherhood][ITEM COMPARE] No selected entity was attached to the hovered item.");
				return result;
			}

			local entity = ::Tactical.getEntityByID(entityID);
			local candidate = ::Brotherhood.resolveUIItem(this, entityID, itemID, itemOwner);
			if (entity == null || candidate == null)
			{
				::logInfo("[Brotherhood][ITEM COMPARE] Could not resolve " + (entity == null ? "the selected entity" : "the hovered item") + ".");
				return result;
			}
			if (candidate.getSlotType() == ::Const.ItemSlot.None || candidate.getSlotType() == ::Const.ItemSlot.Bag)
			{
				::logInfo("[Brotherhood][ITEM COMPARE] " + candidate.getName() + " has no comparable equipment slot.");
				return result;
			}

			local equipped = entity.getItems().getItemAtSlot(candidate.getSlotType());
			if (equipped == null)
			{
				ret.push({ id = 909, type = "text", icon = "ui/icons/special.png", text = "Comparison: Nothing is equipped in this slot." });
				return result;
			}
			if (equipped.getInstanceID() == candidate.getInstanceID())
			{
				ret.push({ id = 909, type = "text", icon = "ui/icons/special.png", text = "Comparison: This item is currently equipped." });
				return result;
			}
			::logInfo("[Brotherhood][ITEM COMPARE] Comparing " + candidate.getName() + " against " + equipped.getName() + ".");
			result.Hovered = ::Brotherhood.addItemComparison(ret, candidate, equipped);
			result.Equipped = this.m.OnQueryUIItemTooltipDataListener(entityID, equipped.getInstanceID(), "entity");
			return result;
		}
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.general_queryUIElementTooltipData = @(__original) { function general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
		{
			local ret = __original(_entityId, _elementId, _elementOwner);
			if (_elementId == "tactical-screen.turn-sequence-bar-module.EndTurnButton" && ret != null)
			{
				foreach (entry in ret)
				{
					if ("type" in entry && entry.type == "title")
					{
						entry.text = "End Turn (Enter, F, Shift + Space)";
						break;
					}
				}
			}
			return ret;
		}}.general_queryUIElementTooltipData;

		q.tactical_helper_addHintsToTooltip = @(__original) { function tactical_helper_addHintsToTooltip( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
		{
			local ret = __original(_activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked);
			if (ret == null || !::Brotherhood.isCustomItemSwappingEnabled()) return ret;

			if (_itemOwner == "entity" && _item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
			{
				for (local i = ret.len() - 1; i >= 0; --i)
				{
					local entry = ret[i];
					if (!("text" in entry) || !("icon" in entry)) continue;
					if (entry.icon == "ui/icons/mouse_right_button_ctrl.png")
					{
						ret.remove(i);
					}
				}
			}
			else if (_itemOwner == "entity")
			{
				for (local i = ret.len() - 1; i >= 0; --i)
				{
					local entry = ret[i];
					if (!("text" in entry) || !("icon" in entry)) continue;
					if (entry.icon == "ui/icons/mouse_right_button.png" && entry.text.find("Place item in bag") == 0)
					{
						entry.icon = "ui/icons/mouse_right_button_ctrl.png";
					}
					else if (entry.icon == "ui/icons/mouse_right_button_ctrl.png")
					{
						local suffix = entry.text.find(" (");
						entry.icon = "ui/icons/mouse_right_button.png";
						entry.text = "Unequip item" + (suffix == null ? "" : entry.text.slice(suffix));
					}
				}
			}

			return ret;
		}}.tactical_helper_addHintsToTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/character/character_screen", function(q) {
		q.helper_queryEquipmentTargetItems = @(__original) function( _inventory, _sourceItem )
		{
			local actor = _inventory == null ? null : _inventory.getActor();
			if (::Brotherhood.hasSnappingTurtle(actor) && ::Brotherhood.isSnappingTurtleTwoHandedWeapon(_sourceItem))
			{
				local main = _inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand);
				return {
					firstItem = main,
					secondItem = null,
					slotsNeeded = main == null ? 0 : 1
				};
			}
			return __original(_inventory, _sourceItem);
		}

		q.onBrotherhoodInventoryDropDiagnostic <- function( _data )
		{
			if (_data == null)
			{
				::logInfo("[Brotherhood][INVENTORY DROP] UI wrapper sent null diagnostic data.");
				return null;
			}
			local text = "";
			foreach (index, value in _data)
			{
				if (index > 0) text += ", ";
				text += value == null ? "null" : value.tostring();
			}
			::logInfo("[Brotherhood][INVENTORY DROP] UI request [" + text + "].");
			return null;
		}

		q.bhFindLiveBagIndex <- function( _inventory, _item, _hint = null )
		{
			if (_hint != null && _hint >= 0 && _hint < _inventory.getUnlockedBagSlots() && _inventory.getItemAtBagSlot(_hint) == _item) return _hint;
			for (local i = 0; i < _inventory.getUnlockedBagSlots(); ++i)
				if (_inventory.getItemAtBagSlot(i) == _item) return i;
			return null;
		}

		q.bhNormalizeHandSlot <- function( _slot )
		{
			if (_slot == "mainhand") return this.Const.ItemSlot.Mainhand;
			if (_slot == "offhand") return this.Const.ItemSlot.Offhand;
			return _slot;
		}

		q.bhCanUseHandSlot <- function( _item, _actor, _slot )
		{
			if (_item == null) return true;
			_slot = this.bhNormalizeHandSlot(_slot);
			local isHand = _slot == this.Const.ItemSlot.Mainhand || _slot == this.Const.ItemSlot.Offhand;
			local isThrowing = ::Brotherhood.isFleshcraftThrowingWeapon(_item);
			local isTool = ::Brotherhood.isCombatToolConsumable(_item);
			local hasVolley = _actor != null && _actor.getSkills().hasSkill("perk.bh_volley_mastery");
			local hasConsumableMastery = ::Brotherhood.hasConsumableMastery(_actor);
			local nativeSlot = _item.getSlotType();
			local result = isHand && ((isThrowing && hasVolley) || (isTool && hasConsumableMastery) || nativeSlot == _slot);
			::logInfo("[Brotherhood][HAND ELIGIBILITY] " + _item.getName() + " requested=" + _slot + " native=" + nativeSlot + " current=" + _item.getCurrentSlotType() + " throwing=" + isThrowing + " volley=" + hasVolley + " tool=" + isTool + " consumable_mastery=" + hasConsumableMastery + " result=" + result + ".");
			return result;
		}

		q.bhPrepareHandSlot <- function( _item, _actor, _slot )
		{
			_slot = this.bhNormalizeHandSlot(_slot);
			if (::Brotherhood.isFleshcraftThrowingWeapon(_item)) ::Brotherhood.configureVolleyWeaponSlot(_item, _actor, _slot);
			if (::Brotherhood.isCombatToolConsumable(_item)) ::Brotherhood.configureConsumableToolSlot(_item, _actor, _slot);
		}

		q.bhInventoryMoveResult <- function( _actor )
		{
			if (_actor != null) _actor.setDirty(true);
			local activeEntity = this.Tactical.isActive() ? this.Tactical.TurnSequenceBar.getActiveEntity() : null;
			return this.UIDataHelper.convertStashAndEntityToUIData(_actor, activeEntity, false, this.m.InventoryFilter);
		}

		q.bhReleaseHandOccupant <- function( _inventory, _actor, _item, _slotType )
		{
			if (_inventory == null || _item == null) return true;

			_slotType = this.bhNormalizeHandSlot(_slotType);
			if (::Brotherhood.isSnappingTurtleTwoHandedWeapon(_item))
				::Brotherhood.configureSnappingTurtleWeapon(_item, _actor);
			::Brotherhood.clearSnappingTurtleOffhandBlocker(_inventory);

			local currentSlot = _item.getCurrentSlotType();
			if (currentSlot == this.Const.ItemSlot.None || currentSlot == this.Const.ItemSlot.Bag)
			{
				for (local i = 0; i < _inventory.m.Items[_slotType].len(); ++i)
					if (_inventory.m.Items[_slotType][i] == _item) _inventory.m.Items[_slotType][i] = null;
				return true;
			}

			if (_inventory.unequip(_item)) return true;

			local slotType = _item.getSlotType();
			for (local i = 0; i < _inventory.m.Items[slotType].len(); ++i)
			{
				if (_inventory.m.Items[slotType][i] != _item) continue;

				_item.onUnequip();
				_item.setContainer(null);
				_item.setCurrentSlotType(this.Const.ItemSlot.None);
				_inventory.m.Items[slotType][i] = null;

				local blocked = _item.getBlockedSlotType();
				if (blocked != null)
				{
					for (local j = 0; j < _inventory.m.Items[blocked].len(); ++j)
						if (_inventory.m.Items[blocked][j] == -1) _inventory.m.Items[blocked][j] = null;
				}

				::Brotherhood.clearSnappingTurtleOffhandBlocker(_inventory);
				if (_actor != null && !_actor.isNull() && _actor.isAlive()) _actor.getSkills().update();
				::logInfo("[Brotherhood][BAG TO HAND] Force-released " + _item.getName() + " from slot " + slotType + " after vanilla unequip failed.");
				return true;
			}

			::logInfo("[Brotherhood][BAG TO HAND] Failed to release " + _item.getName()
				+ ": current=" + currentSlot + ", slotType=" + slotType + ", requested=" + _slotType + ".");
			return false;
		}

		q.bhDirectEquipSnappingTurtleTwoHander <- function( _inventory, _actor, _item )
		{
			if (_inventory == null || _actor == null || _item == null)
			{
				::logInfo("[Brotherhood][SNAPPING TURTLE EQUIP] Direct placement rejected null inventory, actor, or item.");
				return false;
			}
			if (!::Brotherhood.hasSnappingTurtle(_actor) || !::Brotherhood.isSnappingTurtleTwoHandedWeapon(_item))
			{
				::logInfo("[Brotherhood][SNAPPING TURTLE EQUIP] Direct placement rejected " + _item.getName()
					+ ": perk=" + ::Brotherhood.hasSnappingTurtle(_actor)
					+ ", twoHanded=" + ::Brotherhood.isSnappingTurtleTwoHandedWeapon(_item) + ".");
				return false;
			}
			if (_item.getCurrentSlotType() != this.Const.ItemSlot.None)
			{
				::logInfo("[Brotherhood][SNAPPING TURTLE EQUIP] Direct placement rejected " + _item.getName()
					+ ": current slot is " + _item.getCurrentSlotType() + " instead of None.");
				return false;
			}

			::Brotherhood.clearSnappingTurtleOffhandBlocker(_inventory);
			::Brotherhood.configureSnappingTurtleWeapon(_item, _actor);
			local currentMain = _inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (currentMain == -1 || currentMain == _item)
			{
				for (local i = 0; i < _inventory.m.Items[this.Const.ItemSlot.Mainhand].len(); ++i)
					if (_inventory.m.Items[this.Const.ItemSlot.Mainhand][i] == currentMain)
						_inventory.m.Items[this.Const.ItemSlot.Mainhand][i] = null;
				currentMain = null;
			}
			if (currentMain != null)
			{
				::logInfo("[Brotherhood][SNAPPING TURTLE EQUIP] Direct placement rejected " + _item.getName()
					+ ": main hand is still occupied by " + currentMain.getName() + ".");
				return false;
			}
			local vacancy = -1;
			for (local i = 0; i < _inventory.m.Items[this.Const.ItemSlot.Mainhand].len(); ++i)
			{
				if (_inventory.m.Items[this.Const.ItemSlot.Mainhand][i] == null)
				{
					vacancy = i;
					break;
				}
			}
			if (vacancy == -1)
			{
				::logInfo("[Brotherhood][SNAPPING TURTLE EQUIP] Direct placement rejected " + _item.getName() + ": no writable main-hand vacancy exists.");
				return false;
			}

			_inventory.m.Items[this.Const.ItemSlot.Mainhand][vacancy] = _item;
			_item.setContainer(_inventory);
			_item.setCurrentSlotType(this.Const.ItemSlot.Mainhand);
			_item.onEquip();
			_actor.getSkills().update();
			::Brotherhood.refreshSnappingTurtleLoadout(_actor, "direct two-hander equip");
			::logInfo("[Brotherhood][SNAPPING TURTLE EQUIP] Placed " + _item.getName() + " directly in the main hand without modifying the offhand slot.");
			return true;
		}

		q.onBrotherhoodEquipSnappingTurtleStashItem <- function( _data )
		{
			if (_data == null || "error" in _data) return _data;
			local source = _data.sourceItem;
			local target = _data.inventory.getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local allowed = this.helper_isActionAllowed(_data.entity, [source, target], false);
			if (allowed != null) return allowed;

			if (target != null && _data.inventory.unequip(target) == false)
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			if (_data.stash.removeByIndex(_data.sourceIndex) == null)
			{
				if (target != null) _data.inventory.equip(target);
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromSourceSlot);
			}
			if (!this.bhDirectEquipSnappingTurtleTwoHander(_data.inventory, _data.entity, source))
			{
				_data.stash.insert(source, _data.sourceIndex);
				if (target != null) _data.inventory.equip(target);
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}
			if (target != null) _data.stash.insert(target, _data.sourceIndex);

			this.helper_payForAction(_data.entity, [source, target]);
			source.playInventorySound(this.Const.Items.InventoryEventType.Equipped);
			::logInfo("[Brotherhood][SNAPPING TURTLE EQUIP] Equipped " + source.getName() + " from stash without modifying the offhand slot.");
			return this.bhInventoryMoveResult(_data.entity);
		}

		q.onBrotherhoodMoveEquippedHandItem <- function( _data )
		{
			if (_data == null || _data.len() < 3) return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToFindBagItem);
			local data = this.helper_queryEntityItemData([_data[0], _data[1]]);
			if ("error" in data) return data;

			local source = data.sourceItem;
			local sourceSlot = source.getCurrentSlotType();
			local targetSlot = this.bhNormalizeHandSlot(_data[2]);
			if ((sourceSlot != this.Const.ItemSlot.Mainhand && sourceSlot != this.Const.ItemSlot.Offhand)
				|| (targetSlot != this.Const.ItemSlot.Mainhand && targetSlot != this.Const.ItemSlot.Offhand)
				|| sourceSlot == targetSlot)
			{
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}

			local actor = data.entity;
			local target = data.inventory.getItemAtSlot(targetSlot);
			local canMoveSource = this.bhCanUseHandSlot(source, actor, targetSlot);
			local canMoveTarget = this.bhCanUseHandSlot(target, actor, sourceSlot);
			if (!canMoveSource || !canMoveTarget)
			{
				::logInfo("[Brotherhood][HAND SWAP] Rejected " + source.getName() + ": the item(s) cannot use both hand slots.");
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}

			local allowed = this.helper_isActionAllowed(actor, [source, target], false);
			if (allowed != null) return allowed;

			local sourceSlotType = source.m.SlotType;
			local sourceBlockedSlotType = source.m.BlockedSlotType;
			local targetSlotType = target == null ? null : target.m.SlotType;
			local targetBlockedSlotType = target == null ? null : target.m.BlockedSlotType;
			if (data.inventory.unequip(source) == false) return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromSourceSlot);
			if (target != null && data.inventory.unequip(target) == false)
			{
				source.m.SlotType = sourceSlotType;
				source.m.BlockedSlotType = sourceBlockedSlotType;
				data.inventory.equip(source);
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			}

			this.bhPrepareHandSlot(source, actor, targetSlot);
			local sourceEquipped = data.inventory.equip(source);
			local targetEquipped = true;
			if (sourceEquipped && target != null)
			{
				this.bhPrepareHandSlot(target, actor, sourceSlot);
				targetEquipped = data.inventory.equip(target);
			}
			if (!sourceEquipped || !targetEquipped)
			{
				if (source.isEquipped()) data.inventory.unequip(source);
				if (target != null && target.isEquipped()) data.inventory.unequip(target);
				source.m.SlotType = sourceSlotType;
				source.m.BlockedSlotType = sourceBlockedSlotType;
				data.inventory.equip(source);
				if (target != null)
				{
					target.m.SlotType = targetSlotType;
					target.m.BlockedSlotType = targetBlockedSlotType;
					data.inventory.equip(target);
				}
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}

			this.helper_payForAction(actor, [source, target]);
			source.playInventorySound(this.Const.Items.InventoryEventType.Equipped);
			::logInfo("[Brotherhood][HAND SWAP] Moved " + source.getName() + " to " + (targetSlot == this.Const.ItemSlot.Offhand ? "off hand" : "main hand") + (target == null ? "." : " and swapped with " + target.getName() + "."));
			return this.bhInventoryMoveResult(actor);
		}

		q.onBrotherhoodMoveEquippedHandItemToBag <- function( _data )
		{
			if (_data == null || _data.len() < 2) return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToFindBagItem);
			local data = this.helper_queryEntityItemData([_data[0], _data[1]], true);
			if ("error" in data) return data;
			local source = data.sourceItem;
			local sourceSlot = source.getCurrentSlotType();
			if (sourceSlot != this.Const.ItemSlot.Mainhand && sourceSlot != this.Const.ItemSlot.Offhand)
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromSourceSlot);

			local targetIndex = _data.len() >= 3 ? _data[2] : null;
			if (targetIndex == null)
			{
				for (local i = 0; i < data.inventory.getUnlockedBagSlots(); ++i)
					if (data.inventory.getItemAtBagSlot(i) == null) { targetIndex = i; break; }
			}
			if (targetIndex == null || targetIndex < 0 || targetIndex >= data.inventory.getUnlockedBagSlots())
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.NotEnoughBagSpace);

			local target = data.inventory.getItemAtBagSlot(targetIndex);
			if (target != null && !this.bhCanUseHandSlot(target, data.entity, sourceSlot))
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			local allowed = this.helper_isActionAllowed(data.entity, [source, target], true);
			if (allowed != null) return allowed;

			if (target != null && data.inventory.removeFromBagSlot(targetIndex) == false)
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromBag);
			if (data.inventory.unequip(source) == false)
			{
				if (target != null) data.inventory.addToBag(target, targetIndex);
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromSourceSlot);
			}

			local targetEquipped = true;
			if (target != null)
			{
				this.bhPrepareHandSlot(target, data.entity, sourceSlot);
				targetEquipped = data.inventory.equip(target);
			}
			::Brotherhood.resetVolleyWeaponForBag(source);
				::Brotherhood.resetConsumableToolForBag(source);
			local sourceBagged = targetEquipped && data.inventory.addToBag(source, targetIndex);
			if (!targetEquipped || !sourceBagged)
			{
				if (target != null && target.isEquipped()) data.inventory.unequip(target);
				this.bhPrepareHandSlot(source, data.entity, sourceSlot);
				data.inventory.equip(source);
				if (target != null)
				{
					::Brotherhood.resetVolleyWeaponForBag(target);
				::Brotherhood.resetConsumableToolForBag(target);
					data.inventory.addToBag(target, targetIndex);
				}
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToPutItemIntoBag);
			}

			this.helper_payForAction(data.entity, [source, target]);
			source.playInventorySound(this.Const.Items.InventoryEventType.PlacedInBag);
			::logInfo("[Brotherhood][HAND TO BAG] Moved " + source.getName() + " from " + (sourceSlot == this.Const.ItemSlot.Offhand ? "off hand" : "main hand") + " to live bag slot " + targetIndex + (target == null ? "." : " and equipped " + target.getName() + "."));
			return this.bhInventoryMoveResult(data.entity);
		}

		q.onBrotherhoodMoveBagItemToHand <- function( _data )
		{
			::logInfo("[Brotherhood][BAG TO HAND] Backend request received; values=" + (_data == null ? "null" : _data.len().tostring()) + ".");
			if (_data == null || _data.len() < 4) return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToFindBagItem);
			local data = this.helper_queryEntityItemData([_data[0], _data[1]], true);
			if ("error" in data) return data;
			local source = data.sourceItem;
			local sourceIndex = this.bhFindLiveBagIndex(data.inventory, source, _data[2]);
			local targetSlot = this.bhNormalizeHandSlot(_data[3]);
			if (sourceIndex == null)
			{
				::logInfo("[Brotherhood][BAG TO HAND] Rejected stale bag index " + _data[2] + " for " + source.getName() + "; item identity was not present in any live bag slot.");
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToFindBagItem);
			}
			if (!this.bhCanUseHandSlot(source, data.entity, targetSlot))
			{
				::logInfo("[Brotherhood][BAG TO HAND] Rejected " + source.getName() + " because hand eligibility failed for requested slot " + targetSlot + ".");
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}
			::logInfo("[Brotherhood][BAG TO HAND] Preparing Snapping Turtle state for " + source.getName() + ".");
			::Brotherhood.prepareSnappingTurtleEquip(data.inventory, data.entity, source);
			if (targetSlot == this.Const.ItemSlot.Offhand && data.inventory.hasBlockedSlot(this.Const.ItemSlot.Offhand) && !::Brotherhood.canSnappingTurtleEquipShield(data.entity, data.inventory, source))
			{
				::logInfo("[Brotherhood][BAG TO HAND] Rejected " + source.getName() + " because the live inventory reports the offhand as blocked.");
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}

			local target = data.inventory.getItemAtSlot(targetSlot);
			::logInfo("[Brotherhood][BAG TO HAND] Transaction start for " + source.getName() + " -> slot " + targetSlot
				+ "; occupant=" + (target == null ? "empty" : target.getName()) + ".");
			local allowed = this.helper_isActionAllowed(data.entity, [source, target], false);
			if (allowed != null)
			{
				::logInfo("[Brotherhood][BAG TO HAND] Rejected " + source.getName() + " by helper_isActionAllowed.");
				return allowed;
			}
			if (data.inventory.removeFromBagSlot(sourceIndex) == false)
			{
				::logInfo("[Brotherhood][BAG TO HAND] Failed to remove " + source.getName() + " from resolved bag slot " + sourceIndex + ".");
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromBag);
			}
			if (target != null && !this.bhReleaseHandOccupant(data.inventory, data.entity, target, targetSlot))
			{
				::Brotherhood.resetVolleyWeaponForBag(source);
				::Brotherhood.resetConsumableToolForBag(source);
				data.inventory.addToBag(source, sourceIndex);
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromTargetSlot);
			}

			this.bhPrepareHandSlot(source, data.entity, targetSlot);
			local useDirectSnappingTurtleEquip = targetSlot == this.Const.ItemSlot.Mainhand
				&& ::Brotherhood.hasSnappingTurtle(data.entity)
				&& ::Brotherhood.isSnappingTurtleTwoHandedWeapon(source);
			::logInfo("[Brotherhood][BAG TO HAND] Placement route for " + source.getName()
				+ ": directSnappingTurtle=" + useDirectSnappingTurtleEquip
				+ ", perk=" + ::Brotherhood.hasSnappingTurtle(data.entity)
				+ ", twoHanded=" + ::Brotherhood.isSnappingTurtleTwoHandedWeapon(source)
				+ ", current=" + source.getCurrentSlotType() + ".");
			local sourceEquipped = useDirectSnappingTurtleEquip
				? this.bhDirectEquipSnappingTurtleTwoHander(data.inventory, data.entity, source)
				: data.inventory.equip(source);
			::logInfo("[Brotherhood][BAG TO HAND] Placement result for " + source.getName() + ": " + sourceEquipped + ".");
			local targetBagged = true;
			if (sourceEquipped && target != null)
			{
				::Brotherhood.resetVolleyWeaponForBag(target);
				::Brotherhood.resetConsumableToolForBag(target);
				targetBagged = data.inventory.addToBag(target, sourceIndex);
			}
			if (!sourceEquipped || !targetBagged)
			{
				if (source.isEquipped()) data.inventory.unequip(source);
				::Brotherhood.resetVolleyWeaponForBag(source);
				::Brotherhood.resetConsumableToolForBag(source);
				data.inventory.addToBag(source, sourceIndex);
				if (target != null)
				{
					this.bhPrepareHandSlot(target, data.entity, targetSlot);
					data.inventory.equip(target);
				}
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToEquipBagItem);
			}

			this.helper_payForAction(data.entity, [source, target]);
			source.playInventorySound(this.Const.Items.InventoryEventType.Equipped);
			::logInfo("[Brotherhood][BAG TO HAND] Moved " + source.getName() + " from resolved bag slot " + sourceIndex + " to " + (targetSlot == this.Const.ItemSlot.Offhand ? "off hand" : "main hand")
				+ (::Brotherhood.hasSnappingTurtle(data.entity) && ::Brotherhood.isSnappingTurtleTwoHandedWeapon(source) ? " without disturbing the off hand" : "")
				+ (target == null ? "." : " and returned " + target.getName() + " to that bag slot."));
			return this.bhInventoryMoveResult(data.entity);
		}

		q.onBrotherhoodToggleItemLock <- function( _data )
		{
			if (_data == null || _data.len() < 3)
			{
				::logInfo("[Brotherhood][ITEM LOCK] Character-screen request was missing item data.");
				return null;
			}
			::logInfo("[Brotherhood][ITEM LOCK] Character-screen request for item " + _data[1] + " from " + _data[2] + ".");
			local item = ::Brotherhood.resolveUIItem(this, _data[0], _data[1], _data[2]);
			if (item == null)
			{
				::logInfo("[Brotherhood][ITEM LOCK] Could not resolve the requested character-screen item.");
				return null;
			}
			return { Locked = ::Brotherhood.toggleItemLock(item) };
		}

		q.general_onDropBagItemIntoStash = @(__original) { function general_onDropBagItemIntoStash( _data )
		{
			if (!::Brotherhood.isCustomItemSwappingEnabled()) return __original(_data);
			// Vanilla uses Stash.insert(item, null) when no explicit target slot is
			// supplied. That removes the bag item and silently loses it because null
			// is not a valid stash index. Use Stash.add() for this shortcut instead.
			if (_data == null) return __original(_data);
			local requestedTarget = _data.len() >= 4 ? _data[3] : null;
			if (requestedTarget != null) return __original(_data);

			local data = this.helper_queryBagItemDataToInventory(_data);
			if ("error" in data) return data;
			if (data.sourceItem == null)
			{
				::logInfo("[Brotherhood][BAG TO STASH] Rejected a request with no item in bag slot " + data.sourceItemIdx + ".");
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToFindBagItem);
			}

			local allowed = this.helper_isActionAllowed(data.entity, [data.sourceItem], false);
			if (allowed != null) return allowed;

			local itemID = data.sourceItem.getInstanceID();
			local itemName = data.sourceItem.getName();
			::logInfo("[Brotherhood][BAG TO STASH] Moving " + itemName + " (" + itemID + ") from bag slot " + data.sourceItemIdx + ".");
			if (data.inventory.removeFromBagSlot(data.sourceItemIdx) == false)
			{
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromBag);
			}

			local stashIndex = data.stash.add(data.sourceItem);
			if (stashIndex == null)
			{
				data.inventory.addToBag(data.sourceItem, data.sourceItemIdx);
				::logInfo("[Brotherhood][BAG TO STASH] Stash insertion failed; restored " + itemName + " to bag slot " + data.sourceItemIdx + ".");
				return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.NotEnoughStashSpace);
			}

			data.sourceItem.playInventorySound(this.Const.Items.InventoryEventType.Equipped);
			::logInfo("[Brotherhood][BAG TO STASH] Confirmed " + itemName + " in stash slot " + stashIndex + ".");
			local activeEntity = this.Tactical.isActive() ? this.Tactical.TurnSequenceBar.getActiveEntity() : null;
			return this.UIDataHelper.convertStashAndEntityToUIData(data.entity, activeEntity, false, this.m.InventoryFilter);
		}}.general_onDropBagItemIntoStash;

		q.general_onDestroyStashItem = @(__original) { function general_onDestroyStashItem( _data )
		{
			local data = this.helper_queryStashItemData(_data);
			if (!("error" in data) && ::Brotherhood.isItemLocked(data.sourceItem)) return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromSourceSlot);
			return __original(_data);
		}}.general_onDestroyStashItem;

		q.tactical_onDestroyGroundItem = @(__original) { function tactical_onDestroyGroundItem( _data )
		{
			local data = this.helper_queryGroundItemData(_data);
			if (!("error" in data) && ::Brotherhood.isItemLocked(data.sourceItem)) return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromSourceSlot);
			return __original(_data);
		}}.tactical_onDestroyGroundItem;

		q.tactical_onDropBagItemToGround = @(__original) { function tactical_onDropBagItemToGround( _data )
		{
			local data = this.helper_queryBagItemDataToInventory(_data);
			if (!("error" in data) && ::Brotherhood.isItemLocked(data.sourceItem)) return this.helper_convertErrorToUIData(this.Const.CharacterScreen.ErrorCode.FailedToRemoveItemFromBag);
			return __original(_data);
		}}.tactical_onDropBagItemToGround;

		q.helper_dropItemToGround = @(__original) { function helper_dropItemToGround( _data )
		{
			if (::Brotherhood.isItemLocked(_data.sourceItem)) return null;
			return __original(_data);
		}}.helper_dropItemToGround;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tactical/tactical_screen", function(q) {
		q.onBrotherhoodEndActiveTurn <- function()
		{
			if (!this.isVisible() || this.isAnimating() || ::Tactical.State == null || ::Tactical.State.isInputLocked()) return false;
			local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();
			if (activeEntity == null || !activeEntity.isPlayerControlled()) return false;
			::logInfo("[Brotherhood][SHIFT SPACE UI] Ending the active turn for " + activeEntity.getName() + ".");
			::Tactical.TurnSequenceBar.initNextTurn();
			return true;
		}
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(q) {
		q.onBrotherhoodToggleItemLock <- function( _data )
		{
			if (_data == null || _data.len() < 2 || _data[1] != "world-town-screen-shop-dialog-module.stash")
			{
				::logInfo("[Brotherhood][ITEM LOCK] Shop request was missing valid stash item data.");
				return null;
			}
			::logInfo("[Brotherhood][ITEM LOCK] Shop request for stash item " + _data[0] + ".");
			local result = this.Stash.getItemByInstanceID(_data[0]);
			if (result == null)
			{
				::logInfo("[Brotherhood][ITEM LOCK] Could not resolve the requested shop stash item.");
				return null;
			}
			return { Locked = ::Brotherhood.toggleItemLock(result.item) };
		}

		q.onCanSwapItem = @(__original) { function onCanSwapItem( _data )
		{
			local ret = __original(_data);
			if (_data != null && _data.len() >= 4
				&& _data[1] == "world-town-screen-shop-dialog-module.stash"
				&& _data[3] != _data[1])
			{
				local source = this.Stash.getItemAtIndex(_data[0]);
				if (source != null && ::Brotherhood.isItemLocked(source.item))
				{
					return { Result = this.Const.UI.Swap.CanSwap, Item = null };
				}
			}
			return ret;
		}}.onCanSwapItem;

		q.onSwapItem = @(__original) { function onSwapItem( _data )
		{
			if (_data != null && _data.len() >= 4
				&& _data[1] == "world-town-screen-shop-dialog-module.stash"
				&& _data[3] != _data[1])
			{
				local source = this.Stash.getItemAtIndex(_data[0]);
				if (source != null && ::Brotherhood.isItemLocked(source.item))
				{
					local result = {
						Result = 0,
						Assets = this.m.Parent.queryAssetsInformation(),
						Shop = [],
						Stash = this.UIDataHelper.convertStashToUIData(false, this.m.InventoryFilter),
						StashSpaceUsed = this.Stash.getNumberOfFilledSlots(),
						StashSpaceMax = this.Stash.getCapacity(),
						IsRepairOffered = this.m.Shop.isRepairOffered()
					};
					this.UIDataHelper.convertItemsToUIData(this.m.Shop.getStash().getItems(), result.Shop, this.Const.UI.ItemOwner.Shop);
					return result;
				}
			}
			return __original(_data);
		}}.onSwapItem;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tactical/tactical_combat_result_screen", function(q) {
		q.onBrotherhoodToggleItemLock <- function( _data )
		{
			if (_data == null || _data.len() < 2 || _data[1] != "tactical-combat-result-screen.stash")
			{
				::logInfo("[Brotherhood][ITEM LOCK] Combat-result request was missing valid stash item data.");
				return null;
			}
			::logInfo("[Brotherhood][ITEM LOCK] Combat-result request for stash item " + _data[0] + ".");
			local result = this.Stash.getItemByInstanceID(_data[0]);
			if (result == null)
			{
				::logInfo("[Brotherhood][ITEM LOCK] Could not resolve the requested combat-result stash item.");
				return null;
			}
			return { Locked = ::Brotherhood.toggleItemLock(result.item) };
		}

		q.onSwapItem = @(__original) { function onSwapItem( _data )
		{
			if (_data != null && _data.len() >= 4
				&& _data[1] == "tactical-combat-result-screen.stash"
				&& _data[3] == "tactical-combat-result-screen.found-loot")
			{
				local source = this.Stash.getItemAtIndex(_data[0]);
				if (source != null && ::Brotherhood.isItemLocked(source.item))
				{
					return {
						stash = this.UIDataHelper.convertStashToUIData(true),
						foundLoot = this.UIDataHelper.convertCombatResultLootToUIData()
					};
				}
			}
			return __original(_data);
		}}.onSwapItem;

		q.onDestroyItem = @(__original) { function onDestroyItem( _data )
		{
			if (_data != null && _data.len() >= 2)
			{
				local wrapper = _data[1] == "tactical-combat-result-screen.stash"
					? this.Stash.getItemAtIndex(_data[0])
					: (_data[1] == "tactical-combat-result-screen.found-loot" ? this.Tactical.CombatResultLoot.getItemAtIndex(_data[0]) : null);
				if (wrapper != null && ::Brotherhood.isItemLocked(wrapper.item))
				{
					if (_data[1] == "tactical-combat-result-screen.stash") return { stash = this.UIDataHelper.convertStashToUIData(true) };
					return { foundLoot = this.UIDataHelper.convertCombatResultLootToUIData() };
				}
			}
			return __original(_data);
		}}.onDestroyItem;
	});

	local bh_buildVisualisation = ::TacticalNavigator.buildVisualisation;
	::TacticalNavigator.buildVisualisation <- { function buildVisualisation( _entity, _settings, _actionPoints, _fatigue )
	{
		local previewState = ::Brotherhood.beginMovementNavigatorPreview(_entity);
		local actionPointBonus = ::Brotherhood.getMovementPreviewActionPointBudgetBonus(_entity, _actionPoints);
		local movementPreviewSettingsAdjustment = ::Brotherhood.beginMovementPreviewSettingsAdjustment(_entity, _settings);
		local ret = bh_buildVisualisation(_entity, _settings, _actionPoints + actionPointBonus, _fatigue);
		::Brotherhood.endMovementPreviewSettingsAdjustment(_settings, movementPreviewSettingsAdjustment);
		::Brotherhood.endMovementNavigatorPreview(previewState);
		return ret;
	}}.buildVisualisation;

	local bh_getCostForPath = ::TacticalNavigator.getCostForPath;
	::TacticalNavigator.getCostForPath <- { function getCostForPath( _entity, _settings, _actionPoints, _fatigue )
	{
		local previewState = ::Brotherhood.beginMovementNavigatorPreview(_entity);
		local actionPointBonus = ::Brotherhood.getMovementPreviewActionPointBudgetBonus(_entity, _actionPoints);
		local movementPreviewSettingsAdjustment = ::Brotherhood.beginMovementPreviewSettingsAdjustment(_entity, _settings);
		local ret = bh_getCostForPath(_entity, _settings, _actionPoints + actionPointBonus, _fatigue);
		::Brotherhood.applyMovementPreviewFinalCostsToMovementCosts(_entity, ret);
		::Brotherhood.endMovementPreviewSettingsAdjustment(_settings, movementPreviewSettingsAdjustment);
		::Brotherhood.endMovementNavigatorPreview(previewState);
		return ret;
	}}.getCostForPath;

	::Hooks.registerJS("ui/mods/mod_brotherhood/reach_patch.js");
	if (::Brotherhood.hasEnabledArchetypes())
	{
		::Hooks.registerJS("ui/mods/mod_brotherhood/archetype_glow.js");
		::Hooks.registerJS("ui/mods/mod_brotherhood/archetype_info_button.js");
	}
	::Hooks.registerJS("ui/mods/mod_brotherhood/qol_shortcuts.js");
	::Hooks.registerJS("ui/mods/mod_brotherhood/reserve_result.js");
	if (::Brotherhood.hasEnabledArchetypes())
	{
		::Hooks.registerCSS("ui/mods/mod_brotherhood/archetype_glow.css");
		::Hooks.registerCSS("ui/mods/mod_brotherhood/archetype_info_button.css");
	}
	::Hooks.registerCSS("ui/mods/mod_brotherhood/qol_shortcuts.css");
	::Hooks.registerCSS("ui/mods/mod_brotherhood/reserve_result.css");
	::Hooks.registerCSS("ui/mods/mod_brotherhood/preparation_tooltip.css");

	if (::Brotherhood.TestingMode && ::Brotherhood.OldBlankSlateTesting) ::Brotherhood.applyTestingBackgroundPool();
	::Brotherhood.zeroReachProperties(::Const.CharacterProperties);
	::Const.CharacterProperties.getReach = function()
	{
		return 0;
	};

	// Enforce the keep-list in production and testing. Category filtering below
	// prevents normal rolls; this guard also blocks direct or stale group adds.
	::Brotherhood.HooksMod.hook(::DynamicPerks.Class.PerkTree, function(q) {
		q.addPerkGroup = @(__original) { function addPerkGroup( _perkGroupID )
		{
			if (::Brotherhood.isArchetypeGroupID(_perkGroupID) && !::Brotherhood.isArchetypeEnabled(_perkGroupID)) return;
			return __original(_perkGroupID);
		}}.addPerkGroup;
	});

	if (::Brotherhood.FleshcraftGenerationEnabled)
	{
		if (::Brotherhood.OldBlankSlateTesting)
		{
			::Brotherhood.HooksMod.hook("scripts/entity/tactical/player", function(q) {
				q.setStartValuesEx = @(__original) { function setStartValuesEx( _backgrounds, _addTraits = true )
				{
					__original(::Brotherhood.getTestingBackgrounds(), false);
					::Brotherhood.clearTestingExtras(this);
				}}.setStartValuesEx;

				q.fillTalentValues = @() { function fillTalentValues()
				{
					::Brotherhood.zeroTalents(this);
				}}.fillTalentValues;

				q.fillAttributeLevelUpValues = @(__original) { function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
				{
					::Brotherhood.zeroTalents(this);
					__original(_amount, _maxOnly, _minOnly);
				}}.fillAttributeLevelUpValues;

				q.onHired = @(__original) { function onHired()
				{
					__original();
					::Brotherhood.clearTestingExtras(this);
				}}.onHired;

			});
		}

		::Brotherhood.HooksMod.hookTree("scripts/skills/backgrounds/character_background", function(q) {
			q.createPerkTreeBlueprint = @() { function createPerkTreeBlueprint()
			{
				return ::Brotherhood.createEmptyPerkTree();
			}}.createPerkTreeBlueprint;
		});

		::Brotherhood.HooksMod.hookTree("scripts/scenarios/world/starting_scenario", function(q) {
			q.onSpawnPlayer = @(__original) { function onSpawnPlayer()
			{
				__original();
				if (::Brotherhood.AddTestingGearOnStart) ::Brotherhood.addTestingGearToStash();
			}}.onSpawnPlayer;
		});

		::Brotherhood.HooksMod.hook("scripts/states/world_state", function(q) {
			q.onDeserialize = @(__original) { function onDeserialize( _in )
			{
				local ret = __original(_in);
				if (!::Brotherhood.AddTestingGearOnStart)
				{
					local removed = ::Brotherhood.removeLegacyTestingGearFromStash();
					if (removed > 0) ::logInfo("[Brotherhood] Removed " + removed + " debug item(s) from the company stash.");
				}
				return ret;
			}}.onDeserialize;
		});

		::Brotherhood.HooksMod.hook(::DynamicPerks.Class.PerkGroup, function(q) {
			q.addPerk = @(__original) { function addPerk( _id, _tier )
			{
				local groupID = ::Brotherhood.getOnlyPerkGroupID(_id);
				if (groupID != null && this.getID() != groupID)
				{
					return;
				}

				return __original(_id, _tier);
			}}.addPerk;
		});

		::Brotherhood.HooksMod.hook(::DynamicPerks.Class.PerkTree, function(q) {
			q.addFromDynamicMap = @(__original) { function addFromDynamicMap()
			{
				if (!::Brotherhood.isFleshcraftPerkTree(this)) return __original();
				if (!::Brotherhood.generateFleshcraftPerkTree(this)) return __original();
			}}.addFromDynamicMap;

			q.addSpecialPerkGroups = @(__original) { function addSpecialPerkGroups()
			{
				if (::Brotherhood.isFleshcraftPerkTree(this)) return;
				return __original();
			}}.addSpecialPerkGroups;

			q.addPerkGroup = @(__original) { function addPerkGroup( _perkGroupID )
			{
				if (::Brotherhood.isArchetypeGroupID(_perkGroupID) && !::Brotherhood.isArchetypeEnabled(_perkGroupID))
				{
					return;
				}

				if (_perkGroupID == "pg.bh_brute")
				{
					if (this.m.PerkGroupIDs.find(_perkGroupID) == null) this.m.PerkGroupIDs.push(_perkGroupID);
					this.addPerk("perk.bh_brute_force", 1);
					this.addPerk("perk.bh_too_strong_to_miss", 3);
					local masteries = ["perk.bh_axe_mastery", "perk.bh_cleaver_mastery", "perk.bh_mace_mastery"];
					local mastery = masteries[::Math.rand(0, masteries.len() - 1)];
					this.addPerk(mastery, 4);
					this.addPerk("perk.bh_brutality", 5);
					this.addPerk("perk.bh_splitter", 6);
					return;
				}

				if (_perkGroupID == "pg.bh_mobility")
				{
					return;
				}

				if (_perkGroupID != "pg.bh_survival")
				{
					return __original(_perkGroupID);
				}

				if (this.m.PerkGroupIDs.find(_perkGroupID) == null)
				{
					this.m.PerkGroupIDs.push(_perkGroupID);
				}

				local perkIDs = ::Brotherhood.pickSurvivalPerks();
				foreach (perkID in perkIDs)
				{
					this.addPerk(perkID, 1);
				}
			}}.addPerkGroup;

			q.addPerk = @(__original) { function addPerk( _perkID, _tier = 1, _ignoreMaxWidth = false )
			{
				if (::Brotherhood.isOnlyPerk(_perkID))
				{
					::Brotherhood.keepOnlyTestingGroup(_perkID);
				}

				local ret = __original(_perkID, _tier, _ignoreMaxWidth);

				if ("BH_CapturingNativeArchetypeID" in this.m && this.hasPerk(_perkID))
				{
					local sourceID = this.m.BH_CapturingNativeArchetypeID;
					if (!("BH_NativePerkSources" in this.m)) this.m.BH_NativePerkSources <- {};
					if (!(_perkID in this.m.BH_NativePerkSources)) this.m.BH_NativePerkSources[_perkID] <- [];
					if (this.m.BH_NativePerkSources[_perkID].find(sourceID) == null) this.m.BH_NativePerkSources[_perkID].push(sourceID);
				}

				if (::Brotherhood.isOnlyPerk(_perkID))
				{
					::Brotherhood.keepOnlyTestingGroup(_perkID);
				}

				return ret;
			}}.addPerk;

			q.onDeserialize = @(__original) { function onDeserialize( _in )
			{
				__original(_in);
				if (!::Brotherhood.isFleshcraftPerkTree(this)) return;

				// Dynamic Perks serializes perk rows rather than group IDs. The
				// selected full archetype packages reconstruct their own IDs, but
				// Survivability intentionally grants only part of its package.
				// Restore its ID without rerolling or adding perks on load.
				if (!this.hasPerkGroup("pg.bh_survival"))
				{
					this.m.PerkGroupIDs.push("pg.bh_survival");
				}
			}}.onDeserialize;

			q.toUIData = @(__original) { function toUIData()
			{
				local ret = __original();
				foreach (row in ret)
				{
					foreach (perk in row)
					{
						::Brotherhood.keepOnlyTestingPerkGroupIDs(perk);
					}
				}

				return ret;
			}}.toUIData;
		});
	}

	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.getTooltip = @(__original) { function getTooltip()
		{
			return ::Brotherhood.removeReachTooltipEntries(__original());
		}}.getTooltip;

		q.onVerifyTarget = @(__original) { function onVerifyTarget( _originTile, _targetTile )
		{
			if (!__original(_originTile, _targetTile)) return false;
			if (!::Brotherhood.TestingMode) return true;
			if (!_targetTile.IsOccupiedByActor || this.getContainer() == null) return true;
			if (!this.isAttack()) return true;

			local target = _targetTile.getEntity();
			if (target == null || !target.getSkills().hasSkill("perk.bh_not_important") || !::Brotherhood.isEmptyHanded(target)) return true;

			local attacker = this.getContainer().getActor();
			if (attacker == null || target.isAlliedWith(attacker)) return true;

			return !::Brotherhood.hasArmedAllyInAttackRange(attacker, target, this);
		}}.onVerifyTarget;
	});

	::Brotherhood.HooksMod.hookTree("scripts/skills/skill", function(q) {
		q.getTooltip = @(__original) { function getTooltip()
		{
			return ::Brotherhood.removeReachTooltipEntries(__original());
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill_container", function(q) {
		q.update = @(__original) { function update()
		{
			__original();
			::Brotherhood.zeroReachProperties(this.getActor().getBaseProperties());
			::Brotherhood.zeroReachProperties(this.getActor().getCurrentProperties());
		}}.update;

		q.onCostsPreview = @(__original) { function onCostsPreview( _costsPreview )
		{
			__original(_costsPreview);

			local actor = this.getActor();
			if (actor == null || !actor.isPreviewing()) return;

			::Brotherhood.applyMovementPreviewCostsToCostsPreview(actor, _costsPreview);

			local pursuitActionPoints = ::Brotherhood.getPursuerActionPoints(actor);
			if ("bhPursuitActionPoints" in _costsPreview) _costsPreview.bhPursuitActionPoints = pursuitActionPoints;
			else _costsPreview.bhPursuitActionPoints <- pursuitActionPoints;
		}}.onCostsPreview;
	});

	::Brotherhood.isAllowedWheelGroupID <- function( _groupID )
	{
		return _groupID == "pg.bh_survival" || ::Brotherhood.isArchetypeEnabled(_groupID);
	}

	::Brotherhood.deactivateLegacyPerkGroupMetadata <- function( _phase )
	{
		local removedGroups = 0;
		foreach (categoryID, category in ::DynamicPerks.PerkGroupCategories.getAll())
		{
			local groups = clone category.getGroups();
			foreach (groupID in groups)
			{
				if (::Brotherhood.isAllowedWheelGroupID(groupID)) continue;
				category.removePerkGroup(groupID);
				++removedGroups;
			}
		}

		local removedMemberships = 0;
		foreach (perk in ::Const.Perks.LookupMap)
		{
			if (!("PerkGroupIDs" in perk) || perk.PerkGroupIDs == null) continue;
			local before = perk.PerkGroupIDs.len();
			perk.PerkGroupIDs = perk.PerkGroupIDs.filter(@(_, _id) ::Brotherhood.isAllowedWheelGroupID(_id));
			removedMemberships += before - perk.PerkGroupIDs.len();
		}

		::logInfo(
			"[Brotherhood][WHEEL GROUP WHITELIST][" + _phase + "] Enabled identities: [" + ::Brotherhood.formatIDsForLog(::Brotherhood.EnabledArchetypeIDs) + "]"
			+ "; kept pg.bh_survival infrastructure; removed " + removedGroups.tostring() + " legacy selection entries"
			+ " and " + removedMemberships.tostring() + " legacy perk membership(s)."
		);
	}

	::Reforged.QueueBucket.AfterHooks.push(function() {
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		::Brotherhood.keepPerkOnlyInSurvivalGroup("perk.colossus");
		::Brotherhood.keepPerkOnlyInSurvivalGroup("perk.nine_lives");

		foreach (perkID in ::Brotherhood.MobilityPerks)
		{
			::Brotherhood.removePerkFromAllGroups(perkID);
		}

		foreach (perkID in ::Brotherhood.BardPerks)
		{
			::Brotherhood.removePerkFromAllGroups(perkID);
		}

		if (::Brotherhood.TestingMode)
		{
			local always = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_always");
			if (always != null)
			{
				always.setGroups([
					"pg.bh_survival"
				]);
				always.setMin(1);
			}
		}

		// Wheel of Fortune is the only perk-group generator for player trees.
		// Keep shared perk definitions available, but remove every legacy
		// Reforged/vanilla/background group (Agile, Swift, Tough, weapon groups,
		// etc.) from selection categories and player-facing perk memberships.
		// Survivability is infrastructure, not one of the 29 rolled identities.
		::Brotherhood.deactivateLegacyPerkGroupMetadata("AfterHooks");
	});

	// Some integrations add perk metadata after the ordinary hook-finalization
	// pass. Run the same idempotent whitelist once more when the world becomes
	// available so old saves and late additions cannot restore legacy footers.
	::Reforged.QueueBucket.FirstWorldInit.push(function() {
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		::Brotherhood.deactivateLegacyPerkGroupMetadata("FirstWorldInit");
	});

	::Brotherhood.HooksMod.hookTree("scripts/items/weapons/weapon", function(q) {
		q.create = @(__original) { function create()
		{
			__original();
			if ("Reach" in this.m) this.m.Reach = 0;
		}}.create;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/effects/bleeding_effect", function(q) {
		q.m.BH_TicksLeft <- 2;

		q.onAdded = @(__original) { function onAdded()
		{
			__original();
			if (this.isGarbage()) return;

			this.m.BH_TicksLeft = 2;
			if (::Brotherhood.TestingMode)
			{
				::logInfo("[Brotherhood][BLEED] " + this.getContainer().getActor().getName() + " began bleeding with " + this.m.Stacks + " stack(s) and 2 ticks remaining.");
			}
		}}.onAdded;

		q.onRefresh = @(__original) { function onRefresh()
		{
			local stacksBefore = this.m.Stacks;
			__original();
			if (::Brotherhood.TestingMode && this.m.Stacks > stacksBefore)
			{
				::logInfo("[Brotherhood][BLEED] " + this.getContainer().getActor().getName() + " gained " + (this.m.Stacks - stacksBefore) + " stack(s); now " + this.m.Stacks + " stack(s) with " + this.m.BH_TicksLeft + " tick(s) remaining.");
			}
		}}.onRefresh;

		q.applyDamage = @(__original) { function applyDamage()
		{
			local lastRoundApplied = this.m.LastRoundApplied;
			__original();
			if (this.isGarbage() || this.m.LastRoundApplied == lastRoundApplied) return;

			this.m.BH_TicksLeft--;
			if (::Brotherhood.TestingMode)
			{
				::logInfo("[Brotherhood][BLEED] " + this.getContainer().getActor().getName() + " took " + this.getDamage() + " bleeding damage from " + this.m.Stacks + " stack(s); " + this.m.BH_TicksLeft + " tick(s) remain.");
			}

			if (this.m.BH_TicksLeft <= 0)
			{
				this.removeSelf();
			}
			else
			{
				this.getContainer().getActor().setDirty(true);
			}
		}}.applyDamage;

		q.getDescription = @() { function getDescription()
		{
			return "This character is bleeding profusely. Each stack increases the damage and penalties, and the entire effect expires after its second damage tick.";
		}}.getDescription;

		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret = __original();
			foreach (entry in ret)
			{
				if (entry.id == 10)
				{
					entry.text = "Take " + ::MSU.Text.colorNegative(this.getDamage()) + " damage at turn end or when Waiting";
					break;
				}
			}
			local ticksText = this.m.BH_TicksLeft == 1
				? ::MSU.Text.colorNegative("1") + " remaining damage tick"
				: ::MSU.Text.colorNegative(this.m.BH_TicksLeft) + " remaining damage ticks";
			ret.push({
				id = 14,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Expires after " + ticksText
			});
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Additional stacks do not refresh the remaining ticks"
			});
			return ret;
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/bandage_ally_skill", function(q) {
		q.hasMedicineMastery <- function()
		{
			return this.getContainer() != null && this.getContainer().hasSkill("perk.bh_medicine_mastery");
		}

		q.getActionPointCost = @(__original) { function getActionPointCost()
		{
			return this.hasMedicineMastery() ? 1 : __original();
		}}.getActionPointCost;

		q.getDescription = @(__original) { function getDescription()
		{
			if (!this.hasMedicineMastery()) return __original();
			return "Apply expert battlefield medicine to an ally. Stops Bleeding and treats fresh hemorrhaging injuries, or restores Hitpoints when used on a patient who is not bleeding. Neither the user nor the patient may be engaged in melee.";
		}}.getDescription;

		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret = __original();
			if (!this.hasMedicineMastery()) return ret;

			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/health.png",
				text = ::Reforged.Mod.Tooltips.parseString("When used on a target who is not bleeding, restores " + ::MSU.Text.colorPositive("10%") + " of their maximum [Hitpoints|Concept.Hitpoints]")
			});
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/morale.png",
				text = ::Reforged.Mod.Tooltips.parseString("Healing a target or stopping their Bleeding triggers a positive [morale check|Concept.Morale]")
			});
			return ret;
		}}.getTooltip;

		q.onVerifyTarget = @(__original) { function onVerifyTarget( _originTile, _targetTile )
		{
			if (__original(_originTile, _targetTile)) return true;
			if (!this.hasMedicineMastery() || !_targetTile.IsOccupiedByActor) return false;
			local target = _targetTile.getEntity();
			return target.isAlive() && !target.isDying()
				&& this.getContainer().getActor().isAlliedWith(target)
				&& !_originTile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions())
				&& !_targetTile.hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
		}}.onVerifyTarget;

		q.onUse = @(__original) { function onUse( _user, _targetTile )
		{
			if (!this.hasMedicineMastery()) return __original(_user, _targetTile);
			local target = _targetTile.getEntity();
			local wasBleeding = target.getSkills().hasSkill("effects.bleeding");
			local ret = __original(_user, _targetTile);
			if (!wasBleeding)
			{
				local healing = ::Math.floor(target.getHitpointsMax() * 0.10);
				target.setHitpoints(::Math.min(target.getHitpointsMax(), target.getHitpoints() + healing));
			}
			target.checkMorale(1, 20);
			return ret;
		}}.onUse;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/injury/injury", function(q) {
		q.applyScholasticAnatomyDuration <- function()
		{
			if (this.getContainer() == null || !this.getContainer().hasSkill("perk.bh_scholastic_anatomy")) return;
			if ("BH_ScholasticDurationHalved" in this.m && this.m.BH_ScholasticDurationHalved) return;

			this.m.HealingTimeMin = ::Math.max(1, ::Math.ceil(this.m.HealingTimeMin * 0.5));
			this.m.HealingTimeMax = ::Math.max(this.m.HealingTimeMin, ::Math.ceil(this.m.HealingTimeMax * 0.5));
			if ("BH_ScholasticDurationHalved" in this.m) this.m.BH_ScholasticDurationHalved = true;
			else this.m.BH_ScholasticDurationHalved <- true;
		}

		q.onAdded = @(__original) { function onAdded()
		{
			__original();
			this.applyScholasticAnatomyDuration();
		}}.onAdded;

		q.getHealingTime = @(__original) { function getHealingTime()
		{
			// The roster tooltip calls this directly. Applying here also catches
			// injuries loaded from saves before the perk container next updates.
			this.applyScholasticAnatomyDuration();
			return __original();
		}}.getHealingTime;
	});

	::Brotherhood.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
		q.getTooltip = @(__original) { function getTooltip()
		{
			return ::Brotherhood.removeReachTooltipEntries(__original());
		}}.getTooltip;

		q.onUpdateProperties = @(__original) { function onUpdateProperties( _properties )
		{
			__original(_properties);
			::Brotherhood.zeroReachProperties(_properties);
		}}.onUpdateProperties;

		q.getReach = @() { function getReach()
		{
			return 0;
		}}.getReach;

		q.getDefaultReach = @() { function getDefaultReach()
		{
			return 0;
		}}.getDefaultReach;
	});

	::Brotherhood.HooksMod.hook("scripts/items/weapons/lute", function(q) {
		q.create = @(__original) { function create()
		{
			__original();
			if (!("IsInstrument" in this.m)) this.m.IsInstrument <- true;
			else this.m.IsInstrument = true;
		}}.create;
	});

	::Brotherhood.HooksMod.hookTree("scripts/items/item", function(q) {
		q.isSellable = @(__original) { function isSellable()
		{
			return !::Brotherhood.isItemLocked(this) && __original();
		}}.isSellable;

		q.addSkill = @(__original) { function addSkill( _skill )
		{
			::Brotherhood.restoreVanillaWeaponSkillCost(this, _skill);

			if (::Brotherhood.isTestingItem(this) && _skill != null && "m" in _skill && "FatigueCost" in _skill.m)
			{
				_skill.m.FatigueCost = 0;
			}

			return __original(_skill);
		}}.addSkill;

		q.onDeserialize = @(__original) { function onDeserialize( _in )
		{
			__original(_in);
			::Brotherhood.forceTestingItemZeroFatigue(this);
		}}.onDeserialize;

		q.onUpdateProperties = @(__original) { function onUpdateProperties( _properties )
		{
			::Brotherhood.forceTestingItemZeroFatigue(this);
			return __original(_properties);
		}}.onUpdateProperties;

		q.getStaminaModifier = @(__original) { function getStaminaModifier()
		{
			if (::Brotherhood.isTestingItem(this)) return 0;
			return __original();
		}}.getStaminaModifier;

		q.getTooltip = @(__original) { function getTooltip()
		{
			::Brotherhood.forceTestingItemZeroFatigue(this);
			return ::Brotherhood.removeReachTooltipEntries(__original());
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/items/shields/shield", function(q) {
		q.getTooltip = @(__original) { function getTooltip()
		{
			return ::Brotherhood.removeReachTooltipEntries(__original());
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/special/double_grip", function(q) {
		// Restore vanilla Double Grip after Reforged replaces it with a different
		// bonus for every weapon family.
		q.m.BH_VanillaBonusWasActive <- false;
		q.create = @(__original) { function create()
		{
			__original();
			this.m.Description = "With the second hand free, this character can get a firm double grip on his weapon and inflict additional damage.";
		}}.create;

		q.canDoubleGrip = @() { function canDoubleGrip()
		{
			if (this.getContainer().hasSkill("effects.bh_splitter_no_double_grip")) return false;
			local actor = this.getContainer().getActor();
			if (actor.isDisarmed()) return false;
			local weapon = actor.getMainhandItem();
			return weapon != null && weapon.isDoubleGrippable() && actor.getOffhandItem() == null;
		}}.canDoubleGrip;

		q.getName = @() { function getName() { return this.m.Name; }}.getName;

		q.getTooltip = @() { function getTooltip()
		{
			local ret = this.skill.getTooltip();
			if (this.canDoubleGrip()) ret.push({ id = 7, type = "text", icon = "ui/icons/regular_damage.png", text = ::MSU.Text.colorPositive("25%") + " more damage" });
			return ret;
		}}.getTooltip;

		q.onUpdate = @() { function onUpdate( _properties )
		{
			this.m.CurrWeaponType = null;
			local active=this.canDoubleGrip();
			if(active)
			{
				local old=_properties.MeleeDamageMult;_properties.MeleeDamageMult*=1.25;
				if(!this.m.BH_VanillaBonusWasActive)::Brotherhood.logArchetypeTest("DOUBLE GRIP",this.getContainer().getActor(),"Applied vanilla +25% melee damage; MeleeDamageMult "+old+" -> "+_properties.MeleeDamageMult+".");
			}
			else if(this.m.BH_VanillaBonusWasActive)::Brotherhood.logArchetypeTest("DOUBLE GRIP",this.getContainer().getActor(),"Vanilla bonus deactivated: weapon/offhand/disarm requirements no longer match.");
			this.m.BH_VanillaBonusWasActive=active;
		}}.onUpdate;

		q.onAfterUpdate = @() { function onAfterUpdate( _properties ) {}}.onAfterUpdate;
		q.onAnySkillUsed = @() { function onAnySkillUsed( _skill, _targetEntity, _properties ) {}}.onAnySkillUsed;
		q.onBeingAttacked = @() { function onBeingAttacked( _attacker, _skill, _properties ) {}}.onBeingAttacked;
		q.onTargetHit = @() { function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {}}.onTargetHit;
		q.onGetHitFactorsAsTarget = @() { function onGetHitFactorsAsTarget( _skill, _targetTile, _tooltip ) {}}.onGetHitFactorsAsTarget;
	});

	::Brotherhood.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
		q.onInit = @(__original) { function onInit()
		{
			__original();
			::Brotherhood.disableEntityReach(this);
		}}.onInit;
	});

	::Brotherhood.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
		q.m.BH_SpeedsterPreviewMovementAPSpent <- 0;
		q.m.BH_SpeedsterPreviewTriggered <- false;
		q.m.BH_SpeedsterPreviewActive <- false;
		q.m.BH_PursuerPreviewActionPoints <- 0;
		q.m.BH_MovementPreviewActionPointRefund <- 0;
		q.m.BH_MovementPreviewStartActionPoints <- null;
		q.m.BH_MovementPreviewStartFatigue <- null;
		q.m.BH_MovementPreviewActionPoints <- null;
		q.m.BH_MovementPreviewFatigue <- null;
		q.m.BH_MovementPreviewUndoStack <- [];
		q.m.BH_MovementPreviewNavigatorDepth <- 0;
		q.m.BH_LittleDevilPreviewSpent <- true;
		q.m.BH_VantagePreviewHasMovedUphill <- true;
		q.m.BH_VantagePreviewHasUsedFollowupMove <- true;
		q.m.BH_VantagePreviewHasLowerGroundAttackBonus <- false;
		q.m.BH_LightFeetPreviewTilesMoved <- 0;
		q.m.BH_LightFeetPreviewTriggered <- true;

		q.BH_canForceFleeingAttackOfOpportunity <- function( _entity, _isOnEnter )
		{
			if (_entity == null || !_entity.isAlive() || _entity.isDying()) return false;
			if (_entity.getMoraleState() != ::Const.MoraleState.Fleeing || _entity.isAlliedWith(this)) return false;
			if (!this.m.IsActingEachTurn || !this.m.IsUsingZoneOfControl || !this.m.IsExertingZoneOfControl) return false;
			if (this.getMoraleState() == ::Const.MoraleState.Fleeing || this.getCurrentProperties().IsStunned) return false;
			if (_isOnEnter && (!this.getCurrentProperties().IsAttackingOnZoneOfControlEnter
				|| (!this.getCurrentProperties().IsAttackingOnZoneOfControlAlways && this.getTile().getZoneOfControlCountOtherThan(this.getAlliedFactions()) > 1))) return false;
			return this.getSkills().getAttackOfOpportunity() != null;
		}

		q.onMovementInZoneOfControl = @(__original) { function onMovementInZoneOfControl( _entity, _isOnEnter )
		{
			local ret = __original(_entity, _isOnEnter);
			return ret || this.BH_canForceFleeingAttackOfOpportunity(_entity, _isOnEnter);
		}}.onMovementInZoneOfControl;

		q.onAttackOfOpportunity = @(__original) { function onAttackOfOpportunity( _entity, _isOnEnter )
		{
			local ret = __original(_entity, _isOnEnter);
			if (ret || !this.BH_canForceFleeingAttackOfOpportunity(_entity, _isOnEnter)) return ret;
			if (_entity.getTile().Properties.Effect != null && _entity.getTile().Properties.Effect.Type == "smoke") return false;
			local skill = this.getSkills().getAttackOfOpportunity();
			if (skill == null || !skill.useForFree(_entity.getTile())) return false;
			_entity.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
			::logInfo("[Brotherhood][FLEEING AOO] Restored free attack from " + this.getName() + " against fleeing " + _entity.getName() + ".");
			return true;
		}}.onAttackOfOpportunity;

		q.onMovementStart = @(__original) { function onMovementStart( _tile, _numTiles )
		{
			::Brotherhood.resetMovementActionPointPreview(this);
			return __original(_tile, _numTiles);
		}}.onMovementStart;

		q.RF_getZOCEvasionFatigue = @(__original) { function RF_getZOCEvasionFatigue()
		{
			if (::Brotherhood.hasPursuerFatigueFreeMovement(this)) return 0;
			return __original();
		}}.RF_getZOCEvasionFatigue;

		q.getLevelActionPointCost = @(__original) { function getLevelActionPointCost()
		{
			local ret = __original();
			if (::Brotherhood.hasVantageActionPointDiscount(this))
			{
				return ::Math.max(0, ret - 1);
			}

			return ret;
		}}.getLevelActionPointCost;

		q.getLevelFatigueCost = @(__original) { function getLevelFatigueCost()
		{
			return ::Brotherhood.getVantageLevelFatigueCost(this, __original());
		}}.getLevelFatigueCost;

		q.getActionPointCosts = @(__original) { function getActionPointCosts()
		{
			local ret = __original();
			foreach (terrainType in [::Const.Tactical.TerrainType.RoughGround, ::Const.Tactical.TerrainType.Forest])
			{
				ret[terrainType] = ::Math.max(1, (2 + this.m.CurrentProperties.MovementAPCostAdditional) * this.m.CurrentProperties.MovementAPCostMult);
			}
			ret[::Const.Tactical.TerrainType.Swamp] = ::Math.max(1, (3 + this.m.CurrentProperties.MovementAPCostAdditional) * this.m.CurrentProperties.MovementAPCostMult);
			return ret;
		}}.getActionPointCosts;

		q.onMovementUndo = @(__original) { function onMovementUndo( _tile, _levelDifference )
		{
			local previewUndoCost = ::Brotherhood.isMovementNavigatorPreviewing(this) ? ::Brotherhood.popMovementPreviewUndoCost(this) : null;
			local movementFatigueAdjustment = previewUndoCost == null ? ::Brotherhood.beginMovementFatigueAdjustment(this, _tile, _levelDifference) : null;
			local terrainActionPointAdjustment = ::Brotherhood.beginTerrainActionPointCostOverride(this, _tile);
			local ret = __original(_tile, _levelDifference);
			::Brotherhood.endTerrainActionPointCostOverride(this, terrainActionPointAdjustment);
			::Brotherhood.endMovementFatigueAdjustment(this, movementFatigueAdjustment);

			if (previewUndoCost != null)
			{
				local actionPointRefundCorrection = ::Math.max(0, previewUndoCost.BaseActionPointCost - previewUndoCost.ActionPointCost);
				if (actionPointRefundCorrection > 0)
				{
					this.m.ActionPoints = ::Math.max(0, this.m.ActionPoints - actionPointRefundCorrection);
				}

				local fatigueRefundCorrection = ::Math.max(0, previewUndoCost.BaseFatigueCost - previewUndoCost.FatigueCost);
				if (fatigueRefundCorrection > 0)
				{
					this.m.Fatigue = ::Math.min(this.getFatigueMax(), this.m.Fatigue + fatigueRefundCorrection);
				}
			}

			return ret;
		}}.onMovementUndo;

		q.onMovementStep = @(__original) { function onMovementStep( _tile, _levelDifference )
		{
			local isMovementPreview = ::Brotherhood.isMovementNavigatorPreviewing(this);
			local baseActionPointCost = ::Brotherhood.getMovementStepActionPointCost(this, _tile, _levelDifference);
			local plan = ::Brotherhood.getMovementStepActionPointPlan(this, _tile, baseActionPointCost);
			local effectiveActionPointCost = ::Math.max(0, baseActionPointCost - plan.Discount);
			local speedsterProgressCost = ::Math.max(0, baseActionPointCost - plan.PursuerDiscount);
			local actionPointsBefore = this.m.ActionPoints;
			local wasLittleDevilSlipping = plan.LittleDevil != null ? plan.LittleDevil.m.IsSlipping : false;
			local speedsterPreviewRefund = isMovementPreview ? ::Brotherhood.getSpeedsterMovementPreviewRefund(this, effectiveActionPointCost, speedsterProgressCost) : 0;
			local movementPreviewActionPointRefund = plan.Discount + speedsterPreviewRefund;
			local littleDevilFatigueBeforeStep = plan.LittleDevil != null ? this.getFatigue() : 0;

			if (plan.Discount > 0 || speedsterPreviewRefund > 0)
			{
				this.m.ActionPoints = this.m.ActionPoints + plan.Discount + speedsterPreviewRefund;
			}

			if (plan.LittleDevil != null && !plan.LittleDevil.m.IsSlipping)
			{
				if (plan.LittleDevil.m.StartingTile == null) plan.LittleDevil.m.StartingTile = this.getTile();
				plan.LittleDevil.m.FatigueBeforeMovement = this.getFatigue();
				plan.LittleDevil.m.IsSlipping = true;
				plan.LittleDevil.getContainer().update();
			}

			local movementFatigueAdjustment = ::Brotherhood.beginMovementFatigueAdjustment(this, _tile, _levelDifference, plan);
			local terrainActionPointAdjustment = ::Brotherhood.beginTerrainActionPointCostOverride(this, _tile);
			local ret = __original(_tile, _levelDifference);
			::Brotherhood.endTerrainActionPointCostOverride(this, terrainActionPointAdjustment);
			::Brotherhood.endMovementFatigueAdjustment(this, movementFatigueAdjustment);

			if (!ret)
			{
				if (plan.Discount > 0 || speedsterPreviewRefund > 0)
				{
					this.m.ActionPoints = actionPointsBefore;
					this.setPreviewActionPoints(this.m.ActionPoints);
					this.setPreviewFatigue(this.m.Fatigue);
					::Brotherhood.refreshMovementPreviewSkillState(this);
				}

				if (plan.LittleDevil != null)
				{
					plan.LittleDevil.m.IsSlipping = wasLittleDevilSlipping;
					plan.LittleDevil.getContainer().update();
				}

				return false;
			}

			if (isMovementPreview)
			{
				::Brotherhood.commitMovementStepActionPointPreview(this, plan, effectiveActionPointCost, speedsterPreviewRefund > 0, speedsterProgressCost, movementPreviewActionPointRefund);
				::Brotherhood.pushMovementPreviewUndoCost(this, _tile, _levelDifference, baseActionPointCost, ::Math.max(0, effectiveActionPointCost - speedsterPreviewRefund), ::Brotherhood.getMovementStepFatigueCost(this, _tile, _levelDifference, plan));

				if (plan.LittleDevil != null)
				{
					::Brotherhood.applyLittleDevilPreviewFatigueRefund(this, littleDevilFatigueBeforeStep);
				}

				this.setPreviewActionPoints(this.m.ActionPoints);
				this.setPreviewFatigue(this.m.Fatigue);
				this.m.BH_MovementPreviewActionPoints = this.m.ActionPoints;
				this.m.BH_MovementPreviewFatigue = this.m.Fatigue;
				::Brotherhood.refreshMovementPreviewSkillState(this);

				if (plan.LittleDevil != null)
				{
					plan.LittleDevil.m.IsSlipping = wasLittleDevilSlipping;
					plan.LittleDevil.getContainer().update();
				}

				return true;
			}

			if (!isMovementPreview)
			{
				if (plan.LittleDevil != null)
				{
					::Brotherhood.applyLittleDevilPreviewFatigueRefund(this, littleDevilFatigueBeforeStep);
				}

				::Brotherhood.commitMovementStepActionPointPlan(this, plan, effectiveActionPointCost, speedsterProgressCost);
				local pursuer = this.getSkills().getSkillByID("perk.bh_pursuer");
				if (pursuer != null && pursuer.m.PendingRefund)
				{
					local actualAPSpent = ::Math.max(0, actionPointsBefore - this.m.ActionPoints);
					pursuer.consumeMovementStep(actualAPSpent);
				}
				this.setPreviewActionPoints(this.m.ActionPoints);
				this.setDirty(true);
			}

			return true;
		}}.onMovementStep;

		q.getTooltip = @(__original) { function getTooltip( _targetedWithSkill = null )
		{
			return ::Brotherhood.removeReachTooltipEntries(__original(_targetedWithSkill));
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/entity/tactical/player", function(q) {
		q.getTooltip = @(__original) { function getTooltip( _targetedWithSkill = null )
		{
			return ::Brotherhood.removeReachTooltipEntries(__original(_targetedWithSkill));
		}}.getTooltip;

		q.unlockPerk = @(__original) function( _id )
		{
			if (this.hasPerk(_id)) return true;
			if (this.m.PerkPoints <= 0) return false;

			local isLabTester = this.getFlags().has("BH_ParentLabTester") && this.getFlags().get("BH_ParentLabTester");
			if (isLabTester)
			{
				local tree = this.getPerkTree();
				if (tree == null || !tree.hasPerk(_id)) return false;
			}
			else if (::MSU.isIn("isPerkUnlockable", this, true) && !this.isPerkUnlockable(_id))
			{
				return false;
			}

			return __original(_id);
		}
	});


	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.tactical_queryTileTooltipData = @(__original) { function tactical_queryTileTooltipData()
		{
			local actor = ::Tactical.TurnSequenceBar.getActiveEntity();
			local vantageFatigueAdjustment = ::Brotherhood.beginHoveredVantageFatigueAdjustment(actor);
			local ret = __original();
			::Brotherhood.endMovementFatigueAdjustment(actor, vantageFatigueAdjustment);

			if (ret != null)
			{
				ret = ::Brotherhood.adjustMovementTileTooltip(ret, actor);
			}

			return ret;
		}}.tactical_queryTileTooltipData;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/global/data_helper", function(q) {
		q.addStatsToUIData = @(__original) { function addStatsToUIData( _entity, _target )
		{
			__original(_entity, _target);
			if ("rf_reach" in _target) delete _target.rf_reach;
			if ("rf_reachMax" in _target) delete _target.rf_reachMax;
			if ("rf_reachLabel" in _target) delete _target.rf_reachLabel;
		}}.addStatsToUIData;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function(q) {
		q.setActiveEntityCostsPreview = @(__original) { function setActiveEntityCostsPreview( _costsPreview )
		{
			local activeEntity = this.getActiveEntity();
			if (activeEntity != null && _costsPreview != null && !("SkillID" in _costsPreview))
			{
				::Brotherhood.applyMovementPreviewFinalCostsToMovementCosts(activeEntity, _costsPreview);

				local hoveredTile = ::Tactical.State == null ? null : ::Tactical.State.getLastTileHovered();
				if (hoveredTile != null && ::Brotherhood.isAdjacentPreviewTile(activeEntity, hoveredTile))
				{
					local stepCosts = ::Brotherhood.getMovementStepPreviewCosts(activeEntity, hoveredTile);
					if (stepCosts != null)
					{
						if ("ActionPoints" in _costsPreview) _costsPreview.ActionPoints = stepCosts.ActionPointCost;
						if ("Fatigue" in _costsPreview) _costsPreview.Fatigue = stepCosts.FatigueCost;
						if ("IsMissingActionPoints" in _costsPreview) _costsPreview.IsMissingActionPoints = stepCosts.ActionPointCost > activeEntity.getActionPoints();
						if ("IsMissingFatigue" in _costsPreview) _costsPreview.IsMissingFatigue = activeEntity.getFatigue() + stepCosts.FatigueCost > activeEntity.getFatigueMax();
					}
				}
			}

			local ret = __original(_costsPreview);
			if (activeEntity != null
				&& _costsPreview != null
				&& !("SkillID" in _costsPreview)
				&& this.m.ActiveEntityCostsPreview != null)
			{
				if ("actionPointsPreview" in this.m.ActiveEntityCostsPreview)
				{
					activeEntity.setPreviewActionPoints(this.m.ActiveEntityCostsPreview.actionPointsPreview);
				}
				if ("fatiguePreview" in this.m.ActiveEntityCostsPreview)
				{
					activeEntity.setPreviewFatigue(this.m.ActiveEntityCostsPreview.fatiguePreview);
				}
			}

			return ret;
		}}.setActiveEntityCostsPreview;

		q.convertEntitySkillsToUIData = @(__original) { function convertEntitySkillsToUIData( _entity )
		{
			if (_entity == null
				|| this.m.ActiveEntityCostsPreview == null
				|| !("id" in this.m.ActiveEntityCostsPreview)
				|| this.m.ActiveEntityCostsPreview.id != _entity.getID())
			{
				return __original(_entity);
			}

			local oldPreviewActionPoints = _entity.getPreviewActionPoints();
			local oldPreviewFatigue = _entity.getPreviewFatigue();
			if ("actionPointsPreview" in this.m.ActiveEntityCostsPreview)
			{
				_entity.setPreviewActionPoints(this.m.ActiveEntityCostsPreview.actionPointsPreview);
			}
			if ("fatiguePreview" in this.m.ActiveEntityCostsPreview)
			{
				_entity.setPreviewFatigue(this.m.ActiveEntityCostsPreview.fatiguePreview);
			}

			local ret = __original(_entity);
			_entity.setPreviewActionPoints(oldPreviewActionPoints);
			_entity.setPreviewFatigue(oldPreviewFatigue);
			return ret;
		}}.convertEntitySkillsToUIData;

		q.convertEntityToUIData = @(__original) { function convertEntityToUIData( _entity, isLastEntity = false )
		{
			local ret = __original(_entity, isLastEntity);
			if (_entity != null)
			{
				ret.morale = _entity.getMoraleState();
				ret.moraleMax = ::Const.MoraleStateName.len() - 1;
				if ("moraleLabel" in ret) ret.moraleLabel = ::Const.MoraleStateName[_entity.getMoraleState()];
				else ret.moraleLabel <- ::Const.MoraleStateName[_entity.getMoraleState()];
				ret.bhPursuitActionPoints <- ::Brotherhood.getPursuerActionPoints(_entity);
			}
			return ret;
		}}.convertEntityToUIData;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/throw_net", function(q) {
		q.onVerifyTarget = @(__original) { function onVerifyTarget( _originTile, _targetTile )
		{
			if (!_targetTile.IsOccupiedByActor) return false;

			local target = _targetTile.getEntity();
			local baseProperties = target.getBaseProperties();
			local oldReach = ("Reach" in baseProperties) ? baseProperties.Reach : null;
			if (oldReach != null) baseProperties.Reach = 0;

			local ret = __original(_originTile, _targetTile);

			if (oldReach != null) baseProperties.Reach = oldReach;
			return ret && !target.getCurrentProperties().IsImmuneToRoot;
		}}.onVerifyTarget;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/thrust", function(q) {
		q.m.MeleeSkillAdd = 20;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/slash", function(q) {
		q.m.MeleeSkillAdd = 10;
	});

	local function hookShieldDurability( _script, _durability )
	{
		::Brotherhood.HooksMod.hook(_script, function(q) {
			q.create = @(__original) { function create()
			{
				__original();
				::Brotherhood.setShieldDurability(this, _durability);
			}}.create;

			q.onDeserialize = @(__original) { function onDeserialize( _in )
			{
				__original(_in);
				::Brotherhood.setShieldDurability(this, _durability);
			}}.onDeserialize;
		});
	}

	local shieldDurability = [
		["scripts/items/shields/buckler_shield", 24],
		["scripts/items/shields/wooden_shield_old", 32],
		["scripts/items/shields/oriental/southern_light_shield", 32],
		["scripts/items/shields/greenskins/goblin_light_shield", 32],
		["scripts/items/shields/worn_heater_shield", 40],
		["scripts/items/shields/ancient/auxiliary_shield", 40],
		["scripts/items/shields/ancient/coffin_shield", 40],
		["scripts/items/shields/ancient/tower_shield", 40],
		["scripts/items/shields/greenskins/goblin_heavy_shield", 40],
		["scripts/items/shields/rf_draugr/rf_draugr_round_shield", 40],
		["scripts/items/shields/wooden_shield", 55],
		["scripts/items/shields/faction_wooden_shield", 55],
		["scripts/items/shields/greenskins/orc_light_shield", 55],
		["scripts/items/shields/worn_kite_shield", 60],
		["scripts/items/shields/heater_shield", 70],
		["scripts/items/shields/faction_heater_shield", 70],
		["scripts/items/shields/kite_shield", 85],
		["scripts/items/shields/faction_kite_shield", 85],
		["scripts/items/shields/beasts/schrat_shield", 100],
		["scripts/items/shields/special/craftable_schrat_shield", 100],
		["scripts/items/shields/special/craftable_lindwurm_shield", 100],
		["scripts/items/shields/special/craftable_kraken_shield", 120],
		["scripts/items/shields/oriental/metal_round_shield", 120],
		["scripts/items/shields/legendary/gilders_embrace_shield", 120],
		["scripts/items/shields/greenskins/orc_heavy_shield", 160],
		["scripts/items/shields/named/named_bandit_heater_shield", 70],
		["scripts/items/shields/named/named_rider_on_horse_shield", 70],
		["scripts/items/shields/named/named_undead_heater_shield", 70],
		["scripts/items/shields/named/named_wing_shield", 70],
		["scripts/items/shields/named/named_bandit_kite_shield", 85],
		["scripts/items/shields/named/named_dragon_shield", 85],
		["scripts/items/shields/named/named_lindwurm_shield", 85],
		["scripts/items/shields/named/named_red_white_shield", 85],
		["scripts/items/shields/named/named_undead_kite_shield", 85],
		["scripts/items/shields/named/named_full_metal_heater_shield", 120],
		["scripts/items/shields/named/named_golden_round_shield", 120],
		["scripts/items/shields/named/named_sipar_shield", 120],
		["scripts/items/shields/named/named_orc_heavy_shield", 160]
	];

	foreach (entry in shieldDurability)
	{
		hookShieldDurability(entry[0], entry[1]);
	}

	::Brotherhood.HooksMod.hook("scripts/items/shields/special/craftable_schrat_shield", function(q) {
		q.m.SpawnSaplingConditionThreshold = 80;
		q.m.SpawnSaplingConditionLoss = 35;

		q.create = @(__original) { function create()
		{
			__original();
			this.m.SpawnSaplingConditionThreshold = 80;
			this.m.SpawnSaplingConditionLoss = 35;
		}}.create;
	});
});
