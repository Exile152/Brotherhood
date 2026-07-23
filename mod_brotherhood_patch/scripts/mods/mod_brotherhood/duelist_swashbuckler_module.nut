// The engine's broad script scan reaches this helper before Brotherhood's
// preload has created its namespace. The explicit include later executes it at
// the correct time.
if (!("Brotherhood" in getroottable())) return;

::Brotherhood.logDuelistTest <- function( _actor, _message )
{
	// Duelist diagnostics have completed. Keep the helper as a no-op so its perk
	// scripts do not need gameplay-affecting rewrites.
}

::Brotherhood.logSwashbucklerTest <- function( _actor, _message )
{
	// Swashbuckler testing is complete. Retain a no-op compatibility helper for
	// its scripts so diagnostics can be removed without gameplay rewrites.
}

::Brotherhood.logArchetypeTest <- function( _tag, _actor, _message )
{
	::Brotherhood.logActivePerkMechanic(_tag, _actor, _message);
}

// These archetypes have passed their test phase. Keep old diagnostic call
// sites harmless without touching gameplay or player-facing combat messages.
::Brotherhood.logFencerTest <- function( _actor, _message ) {}
::Brotherhood.logExecutionerTest <- function( _actor, _message ) {}
::Brotherhood.logCripplingTest <- function( _actor, _message )
{
	::Brotherhood.logActivePerkMechanic("Crippling Strikes", _actor, _message);
}

::Brotherhood.getDuelistTooltip <- function( _id )
{
	local data = {
		"perk.bh_feint": ["Where is my attack coming from?", ["Missed attacks against enemies below your current [Initiative|Concept.Initiative] build " + ::MSU.Text.colorPositive("75%") + " less [Fatigue|Concept.Fatigue]."]],
		"perk.bh_reentering_stage": ["Wait, I think my last entrance was not so good.", ["After leaving an enemy's [Zone of Control|Concept.ZoneOfControl], deal " + ::MSU.Text.colorPositive("25%") + " more melee damage to that enemy until the end of this character's next turn.", "This effect can apply to multiple enemies."]],
		"perk.bh_en_garde": ["Try your best.", ["Gain " + ::MSU.Text.colorPositive("+10") + " Melee Attack and [Melee Defense|Concept.MeleeDefense], and deal " + ::MSU.Text.colorPositive("10%") + " more damage while it is not your [turn|Concept.Turn]."]],
		"perk.bh_sword_mastery": ["Master the art of swordfighting.", ["Sword skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Riposte no longer has a hit chance penalty and no longer deactivates when missing a swing.", "Gash has a " + ::MSU.Text.colorPositive("50%") + " lower [threshold|Concept.InjuryThreshold] to inflict [injuries|Concept.InjuryTemporary].", "Split and Swing have " + ::MSU.Text.colorPositive("+10%") + " chance to hit."]],
		"perk.bh_change_of_tempo": ["Excuse me, I need to get to that guy behind you.", ["Unlocks the Change of Tempo skill, allowing this character to swap places with an adjacent ally or enemy.", "After swapping with an enemy, this character may leave that enemy's [Zone of Control|Concept.ZoneOfControl] without triggering a free attack until the end of the turn.", "Costs " + ::MSU.Text.colorPositive("3") + " Action Points and builds " + ::MSU.Text.colorNegative("20") + " Fatigue."]],
		"perk.bh_double_strike": ["Here, take another.", ["After a successful hit, deal " + ::MSU.Text.colorPositive("25%") + " more damage until you miss an attack, move, change your weapon, wait, or end your turn."]],
		"perk.bh_panache": ["I am, simply, the best.", ["Whenever this character hits an enemy, there is a " + ::MSU.Text.colorPositive("33%") + " chance to trigger a positive morale check.", "While Confident, gain " + ::MSU.Text.colorPositive("20%") + " more [Melee Defense|Concept.MeleeDefense]."]],
		"perk.bh_stolen": ["I have your sword! I have your sword!", ["All melee attacks now have a " + ::MSU.Text.colorPositive("5%") + " chance of disarming your opponent.", "Weapons you disarm go directly into your inventory."]],
		"perk.bh_you_missed_again": ["As expected.", ["Whenever an enemy misses an attack against this character, there is a " + ::MSU.Text.colorPositive("33%") + " chance for that enemy to trigger a negative morale check."]],
		"perk.bh_duelist": ["Become one with your weapon and go for the weak spots!", ["While your off hand is free or not holding a weapon or shield (except bucklers), " + ::MSU.Text.colorPositive("+20%") + " of your damage ignores armor.", "This bonus is doubled while only one opponent is adjacent to you."]]
	};
	local d = data[_id];
	return ::Brotherhood.formatSurvivalPerkTooltip({ Fluff = d[0], Effects = [{ Type = ::UPD.EffectType.Passive, Description = d[1] }] });
}

::Brotherhood.getFencerTooltip <- function( _id )
{
	local data = {
		"perk.bh_feint": ["Where is my attack coming from?", ["Missed attacks against enemies below your current [Initiative|Concept.Initiative] build " + ::MSU.Text.colorPositive("75%") + " less [Fatigue|Concept.Fatigue]."]],
		"perk.bh_en_garde": ["Try your best.", ["Gain " + ::MSU.Text.colorPositive("+10") + " Melee Attack, Defense and " + ::MSU.Text.colorPositive("10%") + " Damage when it's not your turn."]],
		"perk.bh_fencing_mastery": ["Always remain one step ahead.", ["Attacks against enemies with lower current Initiative build " + ::MSU.Text.colorPositive("25%") + " less Fatigue and deal " + ::MSU.Text.colorPositive("10%") + " more damage.", "Whenever an attack hits an enemy, gain " + ::MSU.Text.colorPositive("+10") + " Initiative until the end of this character's next turn. This effect stacks."]],
		"perk.bh_contre_attaque": ["Aha! Poor footwork.", ["While wielding a one-handed melee weapon with the off hand empty, gain access to Riposte.", "Riposte costs " + ::MSU.Text.colorPositive("1") + " less Action Point."]]
	}; local d = data[_id]; return ::Brotherhood.formatSurvivalPerkTooltip({ Fluff = d[0], Effects = [{ Type = ::UPD.EffectType.Passive, Description = d[1] }] });
}

::Brotherhood.getExecutionerTooltip <- function( _id, _allowObjectFields = true )
{
	local bleeding = _allowObjectFields ? "[$ $|Skill+bleeding_effect]" : "Bleeding";
	local data = {
		"perk.bh_crippling_strikes": ["Cripple your enemies!", ["Lowers the threshold to inflict injuries by " + ::MSU.Text.colorNegative("33%") + " for both melee and ranged attacks.", "You have half the chance to also inflict injuries when hitting armor instead of health."]],
		"perk.bh_executioner": ["Kill them already.", ["Inflict additional " + ::MSU.Text.colorPositive("20%") + " damage against targets that have sustained any injury effects, like a broken arm."]],
		"perk.bh_cleaver_mastery": ["Master the art of cleaver fighting.", ["Cleaver skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Cleaver attacks apply an additional stack of " + bleeding + ".", "Cleaver attacks gain " + ::MSU.Text.colorPositive("+15%") + " of armor penetration against injured or bleeding enemies.", "Disarm suffers only half its normal penalty to hit.", "Gouge has a " + ::MSU.Text.colorPositive("50%") + " lower threshold to inflict injuries."]],
		"perk.bh_heads_will_roll": ["Clean or dirty, you die when I'm here.", ["Whenever you score a fatality you become Confident.", "While Confident all melee attacks are fatalities (if allowed by the weapon)."]]
	}; local d = data[_id]; return ::Brotherhood.formatSurvivalPerkTooltip({ Fluff = d[0], Effects = [{ Type = ::UPD.EffectType.Passive, Description = d[1] }] });
}

::Brotherhood.registerDuelistPerks <- function()
{
	local defs = [
		["perk.bh_feint", "scripts/skills/perks/perk_bh_feint", "Feint", "ui/perks/bh_feint.png", "ui/perks/bh_feint_sw.png"],
		["perk.bh_reentering_stage", "scripts/skills/perks/perk_bh_reentering_stage", "Re-entering Stage", "ui/perks/perk_26.png", "ui/perks/perk_26_sw.png"],
		["perk.bh_en_garde", "scripts/skills/perks/perk_bh_en_garde", "En Garde", "ui/perks/perk_rf_en_garde.png", "ui/perks/perk_rf_en_garde_sw.png"],
		["perk.bh_sword_mastery", "scripts/skills/perks/perk_bh_sword_mastery", "Sword Mastery", "ui/perks/perk_46.png", "ui/perks/perk_46_sw.png"],
		["perk.bh_change_of_tempo", "scripts/skills/perks/perk_bh_change_of_tempo", "Change of Tempo", "ui/perks/bh_change_of_tempo.png", "ui/perks/bh_change_of_tempo_sw.png"],
		["perk.bh_double_strike", "scripts/skills/perks/perk_bh_double_strike", "Double Strike", "ui/perks/bh_double_strike.png", "ui/perks/bh_double_strike_sw.png"],
		["perk.bh_panache", "scripts/skills/perks/perk_bh_panache", "Panache", "ui/perks/perk_21.png", "ui/perks/perk_21_sw.png"],
		["perk.bh_stolen", "scripts/skills/perks/perk_bh_stolen", "Stolen!", "ui/perks/perk_17.png", "ui/perks/perk_17_sw.png"],
		["perk.bh_you_missed_again", "scripts/skills/perks/perk_bh_you_missed_again", "You Missed, Again", "ui/perks/perk_41.png", "ui/perks/perk_41_sw.png"],
		["perk.bh_duelist", "scripts/skills/perks/perk_bh_duelist", "Duelist", "ui/perks/perk_41.png", "ui/perks/perk_41_sw.png"]
		,["perk.bh_fencing_mastery", "scripts/skills/perks/perk_bh_fencing_mastery", "Fencing Mastery", "ui/perks/bh_fencing_mastery.png", "ui/perks/bh_fencing_mastery_sw.png"]
		,["perk.bh_contre_attaque", "scripts/skills/perks/perk_bh_contre_attaque", "Contre-Attaque", "ui/perks/bh_contre_attaque.png", "ui/perks/bh_contre_attaque_sw.png"]
		,["perk.bh_crippling_strikes", "scripts/skills/perks/perk_bh_crippling_strikes", "Crippling Strikes", "ui/perks/perk_14.png", "ui/perks/perk_14_sw.png"]
		,["perk.bh_executioner", "scripts/skills/perks/perk_bh_executioner", "Executioner", "ui/perks/perk_16.png", "ui/perks/perk_16_sw.png"]
		,["perk.bh_cleaver_mastery", "scripts/skills/perks/perk_bh_cleaver_mastery", "Cleaver Mastery", "ui/perks/perk_47.png", "ui/perks/perk_47_sw.png"]
		,["perk.bh_heads_will_roll", "scripts/skills/perks/perk_bh_heads_will_roll", "Heads Will Roll", "ui/perks/perk_16.png", "ui/perks/perk_16_sw.png"]
	];
	local perks = [];
	local canFormatTooltips = "UPD" in getroottable() && "Reforged" in getroottable();
	foreach (d in defs)
	{
		local icon = d[3];
		local iconDisabled = d[4];
		local sourceID = d[0] == "perk.bh_crippling_strikes" ? "perk.crippling_strikes" : (d[0] == "perk.bh_cleaver_mastery" ? "perk.mastery.cleaver" : null);
		if (sourceID != null)
		{
			local source = ::Const.Perks.findById(sourceID);
			if (source != null)
			{
				icon = source.Icon;
				iconDisabled = source.IconDisabled;
			}
		}
		perks.push({
			ID = d[0], Script = d[1], Name = d[2],
			Tooltip = canFormatTooltips ? (d[0] in {"perk.bh_fencing_mastery":true,"perk.bh_contre_attaque":true} ? ::Brotherhood.getFencerTooltip(d[0]) : (d[0] in {"perk.bh_crippling_strikes":true,"perk.bh_executioner":true,"perk.bh_cleaver_mastery":true,"perk.bh_heads_will_roll":true} ? ::Brotherhood.getExecutionerTooltip(d[0], false) : ::Brotherhood.getDuelistTooltip(d[0]))) : [],
			Icon = icon, IconDisabled = iconDisabled, PerkGroupIDs = []
		});
	}
	::DynamicPerks.Perks.addPerks(perks);
}

// Reforged loads every script in its perk_groups directory later in the same
// queue. Dynamic Perks assumes every referenced definition already owns this
// array and crashes with "the index 'PerkGroupIDs' does not exist" otherwise.
::Brotherhood.ensureFightingStylePerkGroupMetadata <- function()
{
	foreach (id in [
		"perk.bh_feint", "perk.bh_en_garde", "perk.bh_sword_mastery",
		"perk.bh_change_of_tempo", "perk.bh_double_strike", "perk.bh_panache",
		"perk.bh_duelist", "perk.bh_reentering_stage", "perk.bh_stolen",
		"perk.bh_you_missed_again"
		,"perk.bh_fencing_mastery", "perk.bh_contre_attaque", "perk.bh_crippling_strikes", "perk.bh_executioner", "perk.bh_cleaver_mastery", "perk.bh_heads_will_roll"
	])
	{
		local perk = ::Const.Perks.findById(id);
		if (perk == null) throw "Brotherhood fighting-style perk was not registered: " + id;
		if (!("PerkGroupIDs" in perk)) perk.PerkGroupIDs <- [];
	}
}

::Brotherhood.initializeDuelistAndSwashbuckler <- function()
{
	::Brotherhood.registerDuelistPerks();
	::Brotherhood.ensureFightingStylePerkGroupMetadata();
	if (!::Brotherhood.shouldInitializeArchetypeModule(["pg.bh_duelist", "pg.bh_fencer", "pg.bh_executioner", "pg.bh_swashbuckler"])) return;
	::Reforged.QueueBucket.FirstWorldInit.push(function() {
		local cleaver = ::Const.Perks.findById("perk.bh_cleaver_mastery");
		if (cleaver != null) cleaver.Tooltip = ::Brotherhood.getExecutionerTooltip("perk.bh_cleaver_mastery");
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/riposte", function(q) {
		q.getActionPointCost = @(__original) { function getActionPointCost()
		{
			local ret = __original();
			if (this.getContainer().hasSkill("perk.bh_contre_attaque"))
			{
				local adjusted = ::Math.max(0, ret - 1);
				::Brotherhood.logFencerTest(this.getContainer().getActor(), "Contre-Attaque adjusted Riposte AP cost from " + ret + " to " + adjusted + ".");
				return adjusted;
			}
			return ret;
		}}.getActionPointCost;
	});

	foreach (script in ["scripts/skills/actives/split", "scripts/skills/actives/swing"])
	{
		::Brotherhood.HooksMod.hook(script, function(q) {
			q.onAnySkillUsed = @(__original) { function onAnySkillUsed( _skill, _targetEntity, _properties )
			{
				__original(_skill, _targetEntity, _properties);
				if (_skill == this && this.getContainer().hasSkill("perk.bh_sword_mastery")) _properties.MeleeSkill += 5;
			}}.onAnySkillUsed;
		});
	}

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.general_queryUIPerkTooltipData = @(__original) { function general_queryUIPerkTooltipData( _entityId, _perkId )
		{
			local ret = __original(_entityId, _perkId);
			local perk = ::Const.Perks.findById(_perkId);
			if (ret == null || perk == null || !("PerkGroupIDs" in perk)) return ret;
			local actor = ::Tactical.getEntityByID(_entityId);
			if (actor != null && ::Brotherhood.isTestingPerkTree(actor.getPerkTree()))
			{
				// Wheel tooltips already provide exact assignment plus one compact
				// possible-membership line. Do not re-add one icon row per group.
				return ::Brotherhood.removeGenericPerkGroupHints(ret, perk);
			}
			local hintIndex = 2;
			foreach (groupID in perk.PerkGroupIDs)
			{
				local group = ::DynamicPerks.PerkGroups.findById(groupID);
				if (group == null || group.getName() == "") continue;
				if (::Brotherhood.isArchetypeGroupID(groupID) && hintIndex < ret.len())
				{
					ret[hintIndex].text = ::DynamicPerks.Mod.Tooltips.parseString(format("[%s|PerkGroup+%s] Archetype", group.getName(), groupID));
				}
				++hintIndex;
			}
			return ret;
		}}.general_queryUIPerkTooltipData;
	});

	::Reforged.QueueBucket.AfterHooks.push(function() {
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		local memberships = {
			"perk.bh_feint": ["pg.bh_duelist", "pg.bh_fencer", "pg.bh_swashbuckler"],
			"perk.bh_en_garde": ["pg.bh_duelist", "pg.bh_fencer"],
			"perk.bh_sword_mastery": ["pg.bh_duelist"],
			"perk.bh_double_strike": ["pg.bh_duelist"],
			"perk.bh_panache": ["pg.bh_duelist", "pg.bh_swashbuckler"],
			"perk.bh_duelist": ["pg.bh_duelist"],
			"perk.bh_reentering_stage": ["pg.bh_swashbuckler"],
			"perk.bh_change_of_tempo": ["pg.bh_swashbuckler"],
			"perk.bh_stolen": ["pg.bh_swashbuckler"],
			"perk.bh_you_missed_again": ["pg.bh_swashbuckler"]
		};
		memberships["perk.bh_fencing_mastery"] <- ["pg.bh_fencer"];
		memberships["perk.bh_contre_attaque"] <- ["pg.bh_fencer"];
		memberships["perk.bh_crippling_strikes"] <- ["pg.bh_executioner"];
		memberships["perk.bh_executioner"] <- ["pg.bh_executioner"];
		memberships["perk.bh_cleaver_mastery"] <- ["pg.bh_executioner"];
		memberships["perk.bh_heads_will_roll"] <- ["pg.bh_executioner"];
		foreach (perkID, groupIDs in memberships)
		{
			local perk = ::Const.Perks.findById(perkID);
			if (perk != null) perk.PerkGroupIDs = clone groupIDs;
		}

		local collection = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_fighting_style");
		if (collection != null)
		{
			local groups = clone collection.getGroups();
			if (groups.find("pg.bh_fencer") == null) groups.push("pg.bh_fencer");
			if (groups.find("pg.bh_executioner") == null) groups.push("pg.bh_executioner");
			if (groups.find("pg.bh_duelist") == null) groups.push("pg.bh_duelist");
			if (groups.find("pg.bh_swashbuckler") == null) groups.push("pg.bh_swashbuckler");
			collection.setGroups(groups);
		}
	});
}
