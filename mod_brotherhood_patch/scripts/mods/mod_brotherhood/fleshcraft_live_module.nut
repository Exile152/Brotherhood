if (!("Brotherhood" in getroottable())) return;

::Brotherhood.FleshcraftPerkDefinitions <- [
	["perk.bh_fundamentals", "Fundamentals", "perk.gifted"],
	["perk.bh_steady_rhythm", "Steady Rhythm", "perk.recover"],
	["perk.bh_disrupt", "Disrupt", "perk.overwhelm"],
	["perk.bh_overwhelm", "Overwhelm", "perk.overwhelm"],
	["perk.bh_lunge", "Lunge", "perk.footwork"],
	["perk.bh_footwork", "Footwork", "perk.footwork"],
	["perk.bh_lightweight", "Lightweight", "perk.executioner"],
	["perk.bh_perfect_thrust", "Perfect Thrust", "perk.berserk"],
	["perk.bh_crimson", "Crimson", "perk.killing_frenzy"],
	["perk.bh_medieval_medicine", "Medieval Medicine", "perk.executioner"],
	["perk.bh_easy_target", "Easy Target", "perk.backstabber"],
	["perk.bh_torture", "Torture", "perk.executioner"],
	["perk.bh_shock", "Shock", "perk.overwhelm"],
	["perk.bh_examination", "Examination", "perk.fast_adaption"],
	["perk.bh_outmatched", "Outmatched", "perk.underdog"],
	["perk.bh_finesse", "Finesse", "perk.dodge"],
	["perk.bh_flow_state", "Flow State", "perk.duelist"],
	["perk.bh_fine_balance", "Fine Balance", "perk.gifted"],
	["perk.bh_preparation", "Preparation", "perk.bags_and_belts"],
	["perk.bh_bloodloaded", "Bloodloaded", "perk.quick_hands"],
	["perk.bh_desperation", "Desperation", "perk.executioner"],
	["perk.bh_porcupine", "Point Blank", "perk.bullseye"],
	["perk.bh_versatile_defense", "Versatile Defense", "perk.underdog"],
	["perk.bh_juggling_mastery", "Juggling Mastery", "perk.mastery.throwing"],
	["perk.bh_skirmishing_mastery", "Skirmishing Mastery", "perk.mastery.throwing"],
	["perk.bh_volley_mastery", "Volley Mastery", "perk.mastery.throwing"],
	["perk.bh_asymmetry", "Asymmetry", "perk.quick_hands"],
	["perk.bh_exceptional_skill", "Exceptional Skill", "perk.bullseye"],
	["perk.bh_malice", "Malice", "perk.killing_frenzy"],
	["perk.bh_omnivorous", "Omnivorous", "perk.quick_hands"],
	["perk.bh_steady_aim", "Steady Aim", "perk.bullseye"],
	["perk.bh_windreaver", "Windreaver", "perk.berserk"],
	["perk.bh_cooking_up_trouble", "Cooking Up Trouble", "perk.bags_and_belts"],
	["perk.bh_distracted", "Distracted", "perk.overwhelm"],
	["perk.bh_over_dexterous", "Over-Dexterous", "perk.gifted"],
	["perk.bh_bully", "Bully", "perk.fearsome"],
	["perk.bh_determination", "Determination", "perk.fortified_mind"],
	["perk.bh_acuity", "Acuity", "perk.dodge"],
	["perk.bh_unadaptive_opening", "Unadaptive Opening", "perk.fast_adaption"],
	["perk.bh_lead_by_example", "Lead by Example", "perk.rally_the_troops"],
	["perk.bh_snapping_turtle", "Snapping Turtle", "perk.shield_expert"],
	["perk.bh_nerves_of_steel", "Nerves of Steel", "perk.indomitable"],
	["perk.bh_sentinel", "Sentinel", "perk.underdog"],
	["perk.bh_twin_discipline", "Twin Discipline", "perk.dodge"],
	["perk.bh_bladed_loop", "Bladed Loop", "perk.duelist"],
	["perk.bh_aerial_dance", "Aerial Dance", "perk.dodge"],
	["perk.bh_zenith", "Zenith", "perk.dodge"],
	["perk.bh_heavyweight", "Heavyweight", "perk.brawny"],
	["perk.bh_nidhogg", "Nidhogg", "perk.berserk"],
	["perk.bh_ragnarok", "Ragnarok", "perk.berserk"],
	["perk.bh_overkill", "Overkill", "perk.killing_frenzy"],
	["perk.bh_consumable_mastery", "Consumable Mastery", "perk.bags_and_belts"],
	["perk.bh_opening_metal", "Opening Metal", "perk.executioner"],
	["perk.bh_aimed_sloth", "Aimed Sloth", "perk.overwhelm"]
];

::Brotherhood.getFleshcraftPerkTooltip <- function( _id )
{
	local data = {
		"perk.bh_fundamentals": ["Always back to it.", ["While you have " + ::MSU.Text.colorPositive("20") + " or less accumulated [Fatigue|Concept.Fatigue], gain " + ::MSU.Text.colorPositive("+7") + " to every attribute in which you have at least one star."]],
		"perk.bh_steady_rhythm": ["Keep on walking, one step at a time.", ["At the end of your turn, if you used exactly one weapon skill this turn, recover " + ::MSU.Text.colorPositive("10") + " [Fatigue|Concept.Fatigue]."]],
		"perk.bh_disrupt": ["Break their formation.", ["Enemies attacked by you deal " + ::MSU.Text.colorPositive("15%") + " less damage until the start of your next turn."]],
		"perk.bh_overwhelm": ["Take advantage of your high Initiative!", ["Each attack against an opponent acting later in the current round applies Overwhelmed, whether the attack hits or misses.", "Each stack lowers the target's [Melee Skill|Concept.MeleeSkill] and [Ranged Skill|Concept.RangeSkill] by " + ::MSU.Text.colorNegative("10%") + " for one turn.", "Multi-target attacks can apply the effect to several enemies."]],
		"perk.bh_lunge": ["Move and attack.", ["The first weapon skill you use each turn can target an enemy " + ::MSU.Text.colorPositive("1") + " tile beyond its normal range. If it does, move 1 tile towards the target before doing the attack.", "This movement costs no [Action Points|Concept.ActionPoints], but generates its normal [Fatigue|Concept.Fatigue]. Leaving an enemy [Zone of Control|Concept.ZoneOfControl] can trigger a free attack that stops the lunge. The step prefers safer tiles over the most direct route."]],
		"perk.bh_footwork": ["Step away before they can pin you down.", ["Unlocks Footwork, allowing movement through or out of an enemy [Zone of Control|Concept.ZoneOfControl] without triggering a free attack.", "Costs " + ::MSU.Text.colorPositive("2") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue]."]],
		"perk.bh_lightweight": ["Float like a butterfly...", ["Deal " + ::MSU.Text.colorPositive("3%") + " more damage for every point your weapon weighs below 5, up to " + ::MSU.Text.colorPositive("15%") + "."]],
		"perk.bh_perfect_thrust": ["A horrific fable is about to be sung!", ["Unlocks Perfect Thrust, which performs your equipped melee weapon's first piercing attack against a Dazed, Stunned, or Netted enemy. After paying the attack's normal [Action Points|Concept.ActionPoints] cost, consume all remaining [Action Points|Concept.ActionPoints]. Gain " + ::MSU.Text.colorPositive("+30%") + " damage for each [Action Point|Concept.ActionPoints] consumed this way.", "Costs " + ::MSU.Text.colorPositive("3") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("25") + " [Fatigue|Concept.Fatigue]."]],
		"perk.bh_crimson": ["Paint this battlefield red.", ["Gain " + ::MSU.Text.colorPositive("+2") + " Melee Skill, Ranged Skill, Melee Defense, Ranged Defense, and Initiative for every living injured enemy on the battlefield."]],
		"perk.bh_medieval_medicine": ["All we have to do is just cut your arm off.", ["Whenever you trigger an injury, deal damage directly to [Hitpoints|Concept.Hitpoints] instead of applying it.", "Deal " + ::MSU.Text.colorPositive("15-20") + " damage for a [light injury|BHLightInjuries+light].", "Deal " + ::MSU.Text.colorPositive("20-25") + " damage for a [heavy injury|BHHeavyInjuries+heavy]."]],
		"perk.bh_easy_target": ["Easy prey.", ["Gain " + ::MSU.Text.colorPositive("+10%") + " chance to hit targets suffering a negative status effect or below " + ::MSU.Text.colorPositive("50%") + " Hitpoints."]],
		"perk.bh_torture": ["Time to end this.", ["Whenever you inflict one injury, inflict another."]],
		"perk.bh_shock": ["Too much pain?", ["Whenever you would inflict an injury, the target deals " + ::MSU.Text.colorPositive("15%") + " less damage until your next turn."]],
		"perk.bh_examination": ["Hold still.", ["If you end your turn without using a weapon skill, gain " + ::MSU.Text.colorPositive("+15%") + " chance to hit for your next attack."]],
		"perk.bh_outmatched": ["But never outskilled.", ["While your off hand is free or not holding a weapon or shield (except bucklers), for every adjacent enemy, gain " + ::MSU.Text.colorPositive("+5") + " [Melee Defense|Concept.MeleeDefense] and " + ::MSU.Text.colorPositive("+5%") + " of your damage ignores armor, up to two enemies.", "These bonuses are doubled while no ally is adjacent to you."]],
		"perk.bh_finesse": ["You can't hit me in such a sloppy way.", ["Enemies that miss you have their off hand disabled during their next turn."]],
		"perk.bh_flow_state": ["Be like water.", ["While your off hand is free or not holding a weapon or shield (except bucklers), every weapon attack that hits an opponent grants one stack of 'Flow'.", "Each stack grants " + ::MSU.Text.colorPositive("+5%") + " armor penetration, up to six stacks.", "At the end of your turn, if you did not hit an enemy, lose two stacks of 'Flow'."]],
		"perk.bh_fine_balance": ["Learn two at a time.", ["Whenever you level up and increase a Skill and a Defense, gain " + ::MSU.Text.colorPositive("+1") + " Hitpoints and Fatigue.", "At odd levels, gain " + ::MSU.Text.colorPositive("+1") + " Initiative and Resolve instead.", "This can trigger only once per level and stops after Level 11."]],
		"perk.bh_preparation": ["Always have more.", ["At the start of combat, gain " + ::MSU.Text.colorPositive("+2") + " temporary maximum ammunition for your current ammunition slot.", "Potion effects on you are " + ::MSU.Text.colorPositive("25%") + " stronger."]],
		"perk.bh_bloodloaded": ["Keep on attacking!", ["When you kill an adjacent enemy, reload your previously held weapon."]],
		"perk.bh_desperation": ["Make sure all shots count, I mean it.", ["Your ranged weapon deals " + ::MSU.Text.colorPositive("+3%") + " damage for each point of ammunition missing."]],
		"perk.bh_porcupine": ["It stings.", ["You can now shoot targets directly adjacent to you, even when an enemy is also adjacent to you.", "Your range with all ranged weapons becomes " + ::MSU.Text.colorNegative("1") + ".", "Subsequent ranged attacks against the same enemy this turn deal " + ::MSU.Text.colorPositive("15%") + " more damage."]],
		"perk.bh_versatile_defense": ["Ready for anything!", ["Melee attacks grant " + ::MSU.Text.colorPositive("+10") + " [Ranged Defense|Concept.RangeDefense] until your next turn.", "Ranged attacks grant " + ::MSU.Text.colorPositive("+10") + " [Melee Defense|Concept.MeleeDefense] until your next turn.", "Subsequent attacks replace the bonus with " + ::MSU.Text.colorPositive("+5") + "."]],
		"perk.bh_juggling_mastery": ["Master throwing weapons and make them graze and bounce enemies.", ["Throwing skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Whenever you attack with a throwing spear and miss, it still grazes your intended target, dealing " + ::MSU.Text.colorPositive("25%") + " of the original damage.", "Throwing axes now ricochet, targeting a second adjacent enemy after hitting the first one, dealing " + ::MSU.Text.colorPositive("25%") + " of the original damage."]],
		"perk.bh_skirmishing_mastery": ["Master throwing weapons to wound or kill the enemy before they even get close.", ["Throwing skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Damage is increased by " + ::MSU.Text.colorPositive("20%") + " when attacking at a distance of " + ::MSU.Text.colorPositive("2") + " tiles.", "Damage is increased by " + ::MSU.Text.colorPositive("15%") + " when attacking at a distance of " + ::MSU.Text.colorPositive("3") + " tiles."]],
		"perk.bh_volley_mastery": ["Master throwing weapons, two at a time.", ["Throwing skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "You can equip throwing weapons in your off hand. Attacks throw both equipped weapons, with each dealing " + ::MSU.Text.colorPositive("70%") + " damage and rolling to hit separately.", "Both throws consume ammunition and build [Fatigue|Concept.Fatigue]."]],
		"perk.bh_asymmetry": ["Unbalanced strikes.", ["Ranged attacks that hit grant " + ::MSU.Text.colorPositive("1") + " stack of 'Asymmetry', up to " + ::MSU.Text.colorPositive("3") + ". Melee attacks consume a stack and cost " + ::MSU.Text.colorPositive("1") + " less [Action Point|Concept.ActionPoints]."]],
		"perk.bh_exceptional_skill": ["More than just attacking!", ["Gain " + ::MSU.Text.colorPositive("33%") + " of your current Ranged Defense as Ranged Skill.", "Gain " + ::MSU.Text.colorPositive("25%") + " of your current Ranged Defense as Ranged Damage."]],
		"perk.bh_malice": ["Welcome to my league.", ["Enemies that survive your attacks grant you 'Malice', up to " + ::MSU.Text.colorPositive("5") + " stacks. Killing an enemy with a different weapon type (Melee or Ranged) consumes all Malice and recovers " + ::MSU.Text.colorPositive("5") + " [Fatigue|Concept.Fatigue] per stack."]],
		"perk.bh_omnivorous": ["Varied teeth for varied blades.", ["Melee attacks make your next Ranged attack deal " + ::MSU.Text.colorPositive("+25%") + " damage.", "Ranged attacks make your next Melee attack deal " + ::MSU.Text.colorPositive("+25%") + " damage."]],
		"perk.bh_steady_aim": ["Just breathe.", ["When a ranged attack hits but deals no [Hitpoint|Concept.Hitpoints] damage, that weapon ignores an additional " + ::MSU.Text.colorPositive("+35%") + " of armor on its next attack."]],
		"perk.bh_windreaver": ["It's raining!", ["Ranged attacks cost " + ::MSU.Text.colorPositive("1") + " [Action Point|Concept.ActionPoints] less for each other enemy targeted by your ranged attacks this turn, to a minimum of " + ::MSU.Text.colorPositive("2") + " [Action Points|Concept.ActionPoints]."]],
		"perk.bh_cooking_up_trouble": ["Hot, hot, hot!", ["Weapons in your bag gain " + ::MSU.Text.colorPositive("+5%") + " damage each turn, up to " + ::MSU.Text.colorPositive("25%") + ".", "Once out, the bonus lasts for " + ::MSU.Text.colorPositive("2") + " turns."]],
		"perk.bh_distracted": ["I'm here!", ["When an enemy within " + ::MSU.Text.colorPositive("2") + " tiles of you targets one of your allies with an attack or skill, they become 'Distracted' until the end of the round.", "Your attacks against 'Distracted' enemies ignore an additional " + ::MSU.Text.colorPositive("20%") + " of armor."]],
		"perk.bh_over_dexterous": ["Above it all.", ["Gain " + ::MSU.Text.colorPositive("5%") + " of your Melee Skill as Ranged Skill.", "Every point of Melee Skill above " + ::MSU.Text.colorPositive("94") + " grants " + ::MSU.Text.colorPositive("+1") + " Ranged Skill and " + ::MSU.Text.colorPositive("+1%") + " Ranged Damage."]],
		"perk.bh_bully": ["You never said stop.", ["Gain " + ::MSU.Text.colorPositive("+10%") + " chance to hit against enemies with lower [morale|Concept.Morale] than you."]],
		"perk.bh_determination": ["Your heart shines red.", ["Passing a negative [morale check|Concept.Morale] recovers " + ::MSU.Text.colorPositive("5") + " [Fatigue|Concept.Fatigue].", "Each previous negative morale success this turn reduces the amount recovered by " + ::MSU.Text.colorPositive("1") + ", to a minimum of " + ::MSU.Text.colorPositive("0") + "."]],
		"perk.bh_acuity": ["Stay sharp!", ["Gain " + ::MSU.Text.colorPositive("+20%") + " [Initiative|Concept.Initiative]."]],
		"perk.bh_unadaptive_opening": ["Don't adapt to nothing, stay doing the same thing.", ["Gain an additional " + ::MSU.Text.colorPositive("+15%") + " chance to hit on enemies that have full armor and [Hitpoints|Concept.Hitpoints]."]],
		"perk.bh_lead_by_example": ["I wanna be like you when I grow up!", ["Hitting an enemy with the battle standard causes the ally with the lowest [morale|Concept.Morale] that the banner aura can reach to make a positive morale check.", "Killing the enemy causes this check to succeed automatically."]],
		"perk.bh_snapping_turtle": ["Nhac!", ["You can equip a shield alongside two-handed weapons. While carrying both, your attacks deal " + ::MSU.Text.colorNegative("50%") + " less damage."]],
		"perk.bh_nerves_of_steel": ["Double soul hearted.", ["You receive " + ::MSU.Text.colorPositive("15%") + " less damage.", "Whenever you take damage, make a negative [morale check|Concept.Morale] unaffected by missing [Hitpoints|Concept.Hitpoints]. This replaces ordinary morale checks caused by taking damage."]],
		"perk.bh_sentinel": ["Stop being foolish when I'm near.", ["Once per turn, when an enemy in your [Zone of Control|Concept.ZoneOfControl] attacks another target, immediately make a free attack against them."]],
		"perk.bh_twin_discipline": ["Stay still while I don't.", ["Your two most recently hit enemies are marked.", "Marked enemies do not exert a [Zone of Control|Concept.ZoneOfControl] against you.", "While two enemies are marked, you deal " + ::MSU.Text.colorPositive("10%") + " more damage to both."]],
		"perk.bh_bladed_loop": ["Wrong timing.", ["After an enemy misses you in melee, your next melee attack against a different enemy gains " + ::MSU.Text.colorPositive("+20%") + " chance to hit."]],
		"perk.bh_aerial_dance": ["Light feet.", ["The first time each round an enemy misses you, recover " + ::MSU.Text.colorPositive("5") + " [Fatigue|Concept.Fatigue], or " + ::MSU.Text.colorPositive("10") + " if the attack missed by " + ::MSU.Text.colorPositive("5") + " or less."]],
		"perk.bh_zenith": ["A brief light.", ["Your first melee hit against each enemy triggers a second attack."]],
		"perk.bh_heavyweight": ["...Sting like an anvil.", ["Gain [Melee Skill|Concept.MeleeSkill] and [Ranged Skill|Concept.RangeSkill] equal to half your weapon's weight, up to " + ::MSU.Text.colorPositive("+12") + "."]],
		"perk.bh_nidhogg": ["Gnaw and gnash.", ["After an enemy attacks you, mark them with 'Nidhogg'.", "Attacking an enemy marked with 'Nidhogg' consumes the mark and immediately repeats the attack without consuming [Action Points|Concept.ActionPoints]."]],
		"perk.bh_ragnarok": ["Everyone here, will, DIE!", ["Unlocks the 'Ragnarok' active skill which makes your attacks cost " + ::MSU.Text.colorPositive("3") + " [Action Points|Concept.ActionPoints] and build twice their normal [Fatigue|Concept.Fatigue] until the end of your turn.", "Costs " + ::MSU.Text.colorPositive("1") + " [Action Point|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue]."]],
		"perk.bh_overkill": ["Make sure they die!", ["Consecutive attacks against the same enemy deal " + ::MSU.Text.colorPositive("+25%") + " damage for " + ::MSU.Text.colorPositive("2") + " turns.", "Does not stack, but another hit will reset the timer."]],
		"perk.bh_consumable_mastery": ["Learn the art of tools and explosives.", ["Tool skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Tool skills cost " + ::MSU.Text.colorPositive("1") + " less [Action Point|Concept.ActionPoints] to a minimum of " + ::MSU.Text.colorPositive("1") + " [Action Point|Concept.ActionPoints].", "You can equip combat tools in both hands.", "At the start of combat, combat tools in your hands and bags gain " + ::MSU.Text.colorPositive("2") + " additional uses."]],
		"perk.bh_opening_metal": ["Not for me, for the useful one!", ["After you hit an enemy, the next attack against them by another character deals " + ::MSU.Text.colorPositive("20%") + " more damage.", "Doesn't stack, but another hit with 'Opening Metal' refreshes it."]],
		"perk.bh_aimed_sloth": ["You shall not move.", ["Any attack that inflicts at least " + ::MSU.Text.colorPositive("1") + " point of damage to [Hitpoints|Concept.Hitpoints] also builds up " + ::MSU.Text.colorPositive("10") + " additional [Fatigue|Concept.Fatigue] on the opponent.", "An opponent can only be affected by 'Aimed Sloth' once per round, no matter the source."]]
	};
	local d = data[_id];
	local type = _id == "perk.bh_perfect_thrust" || _id == "perk.bh_footwork" || _id == "perk.bh_ragnarok" ? ::UPD.EffectType.Active : ::UPD.EffectType.Passive;
	// Parse with Brotherhood's tooltip addon here. If Reforged parses these raw
	// custom identifiers later, it incorrectly looks for them in mod_reforged.
	return ::Brotherhood.Mod.Tooltips.parseString(::Brotherhood.formatSurvivalPerkTooltip({ Fluff = d[0], Effects = [{ Type = type, Description = d[1] }] }));
}

::Brotherhood.logFleshcraftMechanic <- function( _label, _actor, _message )
{
	::Brotherhood.logActivePerkMechanic(_label, _actor, _message);
}

::Brotherhood.isPreparationAmplifiedEffect <- function( _skill )
{
	return _skill != null
		&& _skill.getContainer() != null
		&& _skill.getContainer().hasSkill("perk.bh_preparation")
		&& (((_skill.getType() & ::Const.SkillType.DrugEffect) != 0) || _skill.getID().tolower().find("potion") != null);
}

::Brotherhood.decoratePreparationTooltipText <- function( _text )
{
	if (typeof _text != "string") return _text;
	local ret = _text;
	local searchFrom = 0;
	while (true)
	{
		local colorStart = ret.find("[color=", searchFrom);
		if (colorStart == null) break;
		local marker = ret.find("]", colorStart);
		if (marker == null) break;
		local valueStart = marker + 1;
		local valueEnd = ret.find("[/color]", valueStart);
		if (valueEnd == null) break;
		local raw = ret.slice(valueStart, valueEnd);
		local suffix = "";
		local numeric = raw;
		if (raw.len() > 0 && raw.slice(raw.len() - 1) == "%")
		{
			suffix = "%";
			numeric = raw.slice(0, raw.len() - 1);
		}
		local first = numeric.len() == 0 ? "" : numeric.slice(0, 1);
		if (first != "-" && first != "+" && (first < "0" || first > "9"))
		{
			searchFrom = valueEnd + 8;
			continue;
		}
		local scaled = ::Math.round(numeric.tofloat() * 125.0) / 100.0;
		local scaledText = scaled == ::Math.floor(scaled) ? ::Math.floor(scaled).tostring() : scaled.tostring();
		if (first == "+" && scaled > 0) scaledText = "+" + scaledText;
		local originalDisplay = first == "+" ? raw.slice(1) : raw;
		local replacement = ::Brotherhood.Mod.Tooltips.parseString("[" + scaledText + suffix + "|PreparationStrength+" + originalDisplay + "]");
		ret = ret.slice(0, colorStart) + replacement + ret.slice(valueEnd + 8);
		searchFrom = colorStart + replacement.len();
	}
	return ret;
}

::Brotherhood.isMetaProgressionSkill <- function( _skill )
{
	if (_skill == null) return false;
	local id = _skill.getID();
	local visibleOutsideCombat = [
		"perk.bh_student",
		"effects.bh_student_permanent_gains",
		"perk.bh_learning_devil",
		"effects.bh_learning_devil_permanent_changes",
		"perk.bh_fine_balance",
		"perk.bh_scholarship",
		"perk.bh_ambition",
		"perk.bh_birthright",
		"perk.bh_promised_potential",
		"effects.bh_promised_potential",
		"perk.bh_realized_potential",
		"perk.bh_wasted_potential"
	];
	return visibleOutsideCombat.find(id) != null;
}

::Brotherhood.shouldHideCombatSkillOutsideBattle <- function( _skill )
{
	if (_skill == null || _skill.getContainer() == null || ::Brotherhood.isMetaProgressionSkill(_skill)) return false;
	local id = _skill.getID();
	if (id.find("perk.bh_") != 0 && id.find("effects.bh_") != 0) return false;
	local actor = _skill.getContainer().getActor();
	return actor == null || !("Tactical" in getroottable()) || !::Tactical.isActive() || !actor.isPlacedOnMap();
}

::Brotherhood.isFleshcraftPermittedOffhand <- function( _item )
{
	if (_item == null) return true;
	if (_item.getID() == "shield.buckler" || _item.getID() == "shield.named_buckler") return true;
	return !_item.isItemType(::Const.Items.ItemType.Weapon) && !_item.isItemType(::Const.Items.ItemType.Shield);
}

::Brotherhood.hasFleshcraftOneHandedSetup <- function( _actor )
{
	if (_actor == null) return false;
	local main = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	local off = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
	return main != null
		&& main.isItemType(::Const.Items.ItemType.Weapon)
		&& main.isItemType(::Const.Items.ItemType.OneHanded)
		&& !main.isItemType(::Const.Items.ItemType.RangedWeapon)
		&& ::Brotherhood.isFleshcraftPermittedOffhand(off);
}

::Brotherhood.getAdjacentCombatants <- function( _actor )
{
	local ret = [];
	if (_actor == null || !_actor.isPlacedOnMap()) return ret;
	local tile = _actor.getTile();
	for (local direction = 0; direction < 6; ++direction)
	{
		if (!tile.hasNextTile(direction)) continue;
		local next = tile.getNextTile(direction);
		if (!next.IsOccupiedByActor) continue;
		local other = next.getEntity();
		if (other != null && other.isAlive() && !other.isDying()) ret.push(other);
	}
	return ret;
}

::Brotherhood.hasExactlyOneAdjacentOpponent <- function( _actor )
{
	if (_actor == null || !_actor.isPlacedOnMap()) return false;
	local opponents = 0;
	foreach (other in ::Brotherhood.getAdjacentCombatants(_actor))
	{
		if (_actor.isAlliedWith(other)) continue;
		opponents += 1;
		if (opponents > 1) return false;
	}
	return opponents == 1;
}

::Brotherhood.getStudentBattleData <- function()
{
	if (!("World" in getroottable()) || ::World.Statistics == null) return { Active = false, Serial = 0, TotalBaseXP = 0.0, DeployedCount = 0 };
	local flags = ::World.Statistics.getFlags();
	return {
		Active = flags.has("BH_StudentBattleActive") && flags.get("BH_StudentBattleActive"),
		Serial = flags.has("BH_StudentBattleSerial") ? flags.get("BH_StudentBattleSerial") : 0,
		TotalBaseXP = flags.has("BH_StudentBattleBaseXP") ? flags.get("BH_StudentBattleBaseXP") : 0.0,
		DeployedCount = flags.has("BH_StudentBattleDeployed") ? flags.get("BH_StudentBattleDeployed") : 0
	};
}

::Brotherhood.VolleyPortraitBakeDepth <- 0;
::Brotherhood.VolleyPortraitActorState <- {};

::Brotherhood.getVolleyPortraitActorState <- function( _actor )
{
	local id = _actor.getID();
	if (!(id in ::Brotherhood.VolleyPortraitActorState))
	{
		::Brotherhood.VolleyPortraitActorState[id] <- {
			ThrowingOffhand = false,
			AlwaysApplyOffset = false
		};
	}
	return ::Brotherhood.VolleyPortraitActorState[id];
}

::Brotherhood.clearLegacyVolleyPortraitActorFields <- function( _actor )
{
	if (_actor == null || !("m" in _actor)) return;
	if ("BH_ThrowingOffhandOffset" in _actor.m) delete _actor.m.BH_ThrowingOffhandOffset;
	if ("BH_VolleyAlwaysApplyOffset" in _actor.m) delete _actor.m.BH_VolleyAlwaysApplyOffset;
}

::Brotherhood.isVolleyOffhandThrowingWeapon <- function( _actor, _offhand = null )
{
	if (_actor == null || !_actor.getSkills().hasSkill("perk.bh_volley_mastery")) return false;
	if (_offhand == null) _offhand = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
	return _offhand != null && _offhand.getCurrentSlotType() == ::Const.ItemSlot.Offhand
		&& ::Brotherhood.isFleshcraftThrowingWeapon(_offhand);
}

::Brotherhood.isCombatToolNet <- function( _item )
{
	if (_item == null || ::MSU.isNull(_item)) return false;
	local id = null;
	try { id = _item.getID(); }
	catch (error) { id = null; }
	return id == "tool.throwing_net" || id == "tool.reinforced_throwing_net";
}

// Bombs (not nets) in the offhand with Consumable Mastery use the same shield_icon
// flip + right offset as Volley offhand throwing weapons.
::Brotherhood.isConsumableMasteryBombOffhand <- function( _actor, _offhand = null )
{
	if (!::Brotherhood.hasConsumableMastery(_actor)) return false;
	if (_offhand == null) _offhand = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
	return _offhand != null && _offhand.getCurrentSlotType() == ::Const.ItemSlot.Offhand
		&& ::Brotherhood.isCombatToolConsumable(_offhand)
		&& !::Brotherhood.isCombatToolNet(_offhand);
}

::Brotherhood.needsDualWieldOffhandOffset <- function( _actor, _offhand = null )
{
	return ::Brotherhood.isVolleyOffhandThrowingWeapon(_actor, _offhand)
		|| ::Brotherhood.isConsumableMasteryBombOffhand(_actor, _offhand);
}

::Brotherhood.syncVolleyPortraitForBake <- function( _actor )
{
	if (_actor == null || ::Brotherhood.VolleyPortraitBakeDepth > 0) return false;

	++::Brotherhood.VolleyPortraitBakeDepth;
	local changed = ::Brotherhood.refreshVolleyOffhandAppearance(_actor, "procedural portrait");
	--::Brotherhood.VolleyPortraitBakeDepth;
	return changed;
}

::Brotherhood.refreshVolleyOffhandAppearance <- function( _actor, _context = "appearance" )
{
	if (_actor == null || !_actor.hasSprite("shield_icon")) return false;
	local offhand = _actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
	local needsOffset = ::Brotherhood.needsDualWieldOffhandOffset(_actor, offhand);
	local sprite = _actor.getSprite("shield_icon");
	local offset = _actor.getSpriteOffset("shield_icon");
	local expectedFlip = needsOffset ? _actor.isAlliedWithPlayer() : !_actor.isAlliedWithPlayer();
	local expectedX = needsOffset ? 32 : 0;
	local state = ::Brotherhood.getVolleyPortraitActorState(_actor);
	local trackedStateChanged = state.ThrowingOffhand != needsOffset;
	local wantsAlwaysApply = needsOffset;
	local alwaysApplyChanged = state.AlwaysApplyOffset != wantsAlwaysApply;

	if (alwaysApplyChanged)
	{
		_actor.setAlwaysApplySpriteOffset(wantsAlwaysApply);
		state.AlwaysApplyOffset = wantsAlwaysApply;
	}

	local needsRefresh = offset.X != expectedX || offset.Y != 0 || trackedStateChanged || alwaysApplyChanged;

	if (needsRefresh)
	{
		sprite.setHorizontalFlipping(expectedFlip);
		_actor.setSpriteOffset("shield_icon", ::createVec(expectedX, 0));
	}

	state.ThrowingOffhand = needsOffset;
	::Brotherhood.clearLegacyVolleyPortraitActorFields(_actor);
	return needsRefresh;
};

::Brotherhood.registerStudentDeployment <- function( _actor )
{
	local flags = ::World.Statistics.getFlags();
	local data = ::Brotherhood.getStudentBattleData();
	if (!data.Active)
	{
		data.Serial += 1;
		flags.set("BH_StudentBattleActive", true);
		flags.set("BH_StudentBattleSerial", data.Serial);
		flags.set("BH_StudentBattleBaseXP", 0.0);
		flags.set("BH_StudentBattleDeployed", 0);
		data.DeployedCount = 0;
	}
	local actorFlags = _actor.getFlags();
	if (actorFlags.has("BH_StudentDeployedBattle") && actorFlags.get("BH_StudentDeployedBattle") == data.Serial) return;
	actorFlags.set("BH_StudentDeployedBattle", data.Serial);
	flags.set("BH_StudentBattleDeployed", data.DeployedCount + 1);
}

::Brotherhood.recordStudentBaseXP <- function( _victim )
{
	local data = ::Brotherhood.getStudentBattleData();
	if (!data.Active || _victim == null || _victim.isAlliedWithPlayer()) return;
	local credited = 0.0;
	if (("RF_DamageReceived" in _victim.m) && _victim.m.RF_DamageReceived != null && ("Total" in _victim.m.RF_DamageReceived) && _victim.m.RF_DamageReceived.Total > 0)
	{
		foreach (faction in [::Const.Faction.Player, ::Const.Faction.PlayerAnimals])
		{
			if (faction in _victim.m.RF_DamageReceived)
				credited += _victim.getXPValue() * _victim.m.RF_DamageReceived[faction].Total / _victim.m.RF_DamageReceived.Total;
		}
	}
	else credited = _victim.getXPValue();
	local flags = ::World.Statistics.getFlags();
	flags.set("BH_StudentBattleBaseXP", data.TotalBaseXP + credited);
}

::Brotherhood.finishStudentBattle <- function()
{
	if (!("World" in getroottable()) || ::World.Statistics == null) return;
	::World.Statistics.getFlags().set("BH_StudentBattleActive", false);
}

::Brotherhood.isActorInPlayerCompany <- function( _actor )
{
	if (_actor == null || !("World" in getroottable()) || ::World.State == null) return false;
	foreach (bro in ::World.getPlayerRoster().getAll()) if (bro.getID() == _actor.getID()) return true;
	return false;
}

::Brotherhood.getInjuryDefinition <- function( _injuryID )
{
	foreach (definition in ::Const.Injury.All) if (definition.ID == _injuryID) return definition;
	return null;
}

::Brotherhood.getInjuryCategoryTooltip <- function( _heavy )
{
	local ret = [
		{ id = 1, type = "title", text = _heavy ? "Heavy Injuries" : "Light Injuries" },
		{ id = 2, type = "description", text = _heavy ? "Injuries with a damage threshold of 50% or more." : "Injuries with a damage threshold below 50%." }
	];
	local names = [];
	foreach (definition in ::Const.Injury.All)
	{
		if (::Brotherhood.isHeavyInjuryDefinition(definition) != _heavy) continue;
		local injury = ::new("scripts/skills/" + definition.Script);
		names.push({ Name = injury.getNameOnly(), Icon = injury.getIcon() });
	}
	names.sort(@(a,b) a.Name <=> b.Name);
	foreach (entry in names)
		ret.push({ id = 10 + ret.len(), type = "text", icon = entry.Icon, text = entry.Name });
	return ret;
}

::Brotherhood.isHeavyInjuryDefinition <- function( _definition )
{
	return _definition != null && _definition.Threshold >= 0.5;
}

::Brotherhood.cloneHitInfoWithInjuries <- function( _hitInfo, _injuries )
{
	local ret = clone _hitInfo;
	ret.Injuries = _injuries;
	return ret;
}

::Brotherhood.selectTortureInjury <- function( _target, _skill, _hitInfo, _original )
{
	local originalDefinition = ::Brotherhood.getInjuryDefinition(_original.getID());
	local sameBucket = [];
	local anyBucket = [];
	foreach (definition in _hitInfo.Injuries)
	{
		if (definition.ID == _original.getID() || _target.getSkills().hasSkill(definition.ID)) continue;
		anyBucket.push(definition);
		if (::Brotherhood.isHeavyInjuryDefinition(definition) == ::Brotherhood.isHeavyInjuryDefinition(originalDefinition)) sameBucket.push(definition);
	}
	if (sameBucket.len() != 0)
	{
		local selected = _target.MV_selectInjury(_skill, ::Brotherhood.cloneHitInfoWithInjuries(_hitInfo, sameBucket));
		if (selected != null) return selected;
	}
	if (anyBucket.len() != 0)
	{
		local selected = _target.MV_selectInjury(_skill, ::Brotherhood.cloneHitInfoWithInjuries(_hitInfo, anyBucket));
		if (selected != null) return selected;
	}
	return ::new("scripts/skills/" + originalDefinition.Script);
}

::Brotherhood.canReceiveGhostInjury <- function( _candidate, _definition )
{
	if (_candidate == null || !_candidate.isAlive() || _candidate.isDying() || !_candidate.isPlacedOnMap()) return false;
	if (!_candidate.getCurrentProperties().IsAffectedByInjuries || _candidate.getCurrentProperties().ThresholdToReceiveInjuryMult == 0) return false;
	if (_candidate.m.ExcludedInjuries.find(_definition.ID) != null || _candidate.getSkills().hasSkill(_definition.ID)) return false;
	if (_candidate.getSkills().hasSkill(::Brotherhood.getGhostInjuryEffectID(_definition.ID))) return false;
	local injury = ::new("scripts/skills/" + _definition.Script);
	return injury.isValid(_candidate);
}

::Brotherhood.applyGhostPain <- function( _source, _originalTarget, _injury )
{
	if (_source == null || _originalTarget == null || !_originalTarget.isPlacedOnMap()) return;
	if (_source.getSkills().getSkillByID("perk.bh_ghost_pain") == null) return;
	local definition = ::Brotherhood.getInjuryDefinition(_injury.getID());
	if (definition == null) return;
	local tile = _originalTarget.getTile();
	for (local direction = 0; direction < 6; ++direction)
	{
		if (!tile.hasNextTile(direction)) continue;
		local adjacent = tile.getNextTile(direction);
		if (!adjacent.IsOccupiedByActor) continue;
		local candidate = adjacent.getEntity();
		if (candidate == null || candidate.getID() == _originalTarget.getID() || candidate.isAlliedWith(_source)) continue;
		if (!::Brotherhood.canReceiveGhostInjury(candidate, definition)) continue;
		local chance = ::Math.max(5, ::Math.min(50, 100 - candidate.getCurrentProperties().Bravery));
		if (::Math.rand(1, 100) > chance) continue;
		if (_source.getSkills().hasSkill("perk.bh_medieval_medicine"))
		{
			local penalty = ::Math.floor(::Math.min(10.0, _source.getCurrentProperties().getBravery() * 0.075));
			local before = candidate.getMoraleState();
			local result = candidate.getMoraleState() == ::Const.MoraleState.Ignore ? false : candidate.checkMorale(-1, -penalty);
			::Brotherhood.showMedievalMedicineIcon(_source, candidate);
			::Brotherhood.logFleshcraftMechanic("MEDIEVAL MEDICINE", _source, "Converted Ghost " + _injury.getNameOnly() + " on " + candidate.getName() + " into a morale check with -" + penalty + " Resolve (morale " + before + " -> " + candidate.getMoraleState() + ", result=" + result.tostring() + ").");
		}
		else
		{
			local ghost = ::new("scripts/skills/effects/bh_ghost_injury_effect");
			ghost.configure(definition.ID, definition.Script, _injury.getNameOnly());
			candidate.getSkills().add(ghost);
			ghost.configure(definition.ID, definition.Script, _injury.getNameOnly());
			candidate.getSkills().update();
			candidate.setDirty(true);
			::Brotherhood.logFleshcraftMechanic("GHOST PAIN", _source, "Applied " + ghost.getNameOnly() + " to " + candidate.getName() + ".");
		}
	}
}

::Brotherhood.applyShock <- function( _source, _target )
{
	if (_source == null || _target == null || _source.getSkills().getSkillByID("perk.bh_shock") == null) return;
	local id = "effects.bh_shock." + _source.getID();
	local existing = _target.getSkills().getSkillByID(id);
	if (existing != null) { existing.refresh(); return; }
	local effect = ::new("scripts/skills/effects/bh_shock_effect");
	effect.configure(_source.getID());
	_target.getSkills().add(effect);
}

::Brotherhood.removeShockFromSource <- function( _sourceID )
{
	if (!("Tactical" in getroottable()) || !("State" in ::Tactical) || ::Tactical.State == null || !("Entities" in ::Tactical) || ::Tactical.Entities == null) return;
	local effectID = "effects.bh_shock." + _sourceID;
	foreach (actor in ::Tactical.Entities.getAllInstancesAsArray())
		if (actor != null && actor.getSkills().hasSkill(effectID)) actor.getSkills().removeByID(effectID);
}

::Brotherhood.applyMedievalMedicine <- function( _source, _target, _skill, _injury )
{
	local definition = ::Brotherhood.getInjuryDefinition(_injury.getID());
	local heavy = ::Brotherhood.isHeavyInjuryDefinition(definition);
	local damage = heavy ? ::Math.rand(20, 25) : ::Math.rand(15, 20);
	local oldHitpoints = _target.getHitpoints();
	_target.setHitpoints(::Math.max(0, _target.getHitpoints() - damage));
	_target.setDirty(true);
	if (_target.getHitpoints() <= 0 && _target.isAlive()) _target.kill(_source, _skill, ::Const.FatalityType.None);
	local damageDealt = oldHitpoints - _target.getHitpoints();
	::Brotherhood.showMedievalMedicineIcon(_source, _target);
	if (_source != null && _source.isPlayerControlled() && ::Tactical.isActive() && ::Tactical.TurnSequenceBar.getActiveEntity() != null)
	{
		::Tactical.EventLog.log("[color=" + ::Const.UI.Color.PositiveValue + "]" + _source.getName() + "[/color]'s Medieval Medicine replaced " + _injury.getNameOnly() + " with " + damageDealt + " direct damage.");
	}
	::Brotherhood.logFleshcraftMechanic("MEDIEVAL MEDICINE", _source, "Replaced " + _injury.getNameOnly() + " on " + _target.getName() + " with " + damageDealt + " direct Hitpoint damage (heavy=" + heavy.tostring() + ").");
}

::Brotherhood.showMedievalMedicineIcon <- function( _source, _target )
{
	if (_source == null || _target == null || !_target.isPlacedOnMap()) return;
	local perk = _source.getSkills().getSkillByID("perk.bh_medieval_medicine");
	if (perk == null) return;
	local key = _source.getID().tostring() + ":" + ::Const.SkillCounter.tostring();
	if ("BH_MedievalMedicinePopupKey" in _target.m && _target.m.BH_MedievalMedicinePopupKey == key) return;
	_target.m.BH_MedievalMedicinePopupKey <- key;
	perk.spawnIcon("perk_55", _target.getTile());
}

::Brotherhood.applyFleshcraftInjuryEvent <- function( _target, _skill, _hitInfo, _injury, _isGhostGenerated = false )
{
	if (_injury == null || _target == null || !_target.isAlive()) return null;
	local source = _skill == null || _skill.getContainer() == null ? null : _skill.getContainer().getActor();
	::Brotherhood.applyShock(source, _target);
	if (!_isGhostGenerated) ::Brotherhood.applyGhostPain(source, _target, _injury);
	if (source != null && source.getSkills().getSkillByID("perk.bh_medieval_medicine") != null)
		::Brotherhood.applyMedievalMedicine(source, _target, _skill, _injury);
	else
	{
		_target.getSkills().add(_injury);
		_target.MV_onInjuryReceived(_injury);
	}
	::Brotherhood.refreshCrimsonActors();
	return _injury;
}

::Brotherhood.actorHasCountedInjury <- function( _actor )
{
	if (_actor.getSkills().getAllSkillsOfType(::Const.SkillType.TemporaryInjury).len() != 0) return true;
	foreach (effect in _actor.getSkills().getAllSkillsOfType(::Const.SkillType.StatusEffect))
		if (effect.getID().find("effects.bh_ghost_injury_") == 0 || effect.getID().find("effects.bh_ghost_injury.") == 0) return true;
	return false;
}

::Brotherhood.countCrimsonEnemies <- function( _actor )
{
	local count = 0;
	if (_actor == null || !("Tactical" in getroottable()) || !("State" in ::Tactical) || ::Tactical.State == null || !("Entities" in ::Tactical) || ::Tactical.Entities == null) return count;
	foreach (other in ::Tactical.Entities.getAllInstancesAsArray())
		if (other != null && other.isAlive() && !other.isDying() && other.isPlacedOnMap() && !other.isAlliedWith(_actor) && ::Brotherhood.actorHasCountedInjury(other)) ++count;
	return count;
}

::Brotherhood.refreshCrimsonActors <- function()
{
	if (!("Tactical" in getroottable()) || !("State" in ::Tactical) || ::Tactical.State == null || !("Entities" in ::Tactical) || ::Tactical.Entities == null) return;
	foreach (actor in ::Tactical.Entities.getAllInstancesAsArray())
	{
		if (actor == null || actor.getSkills().getSkillByID("perk.bh_crimson") == null) continue;
		actor.getSkills().update();
		actor.setDirty(true);
	}
}

::Brotherhood.recordFineBalanceSelection <- function( _actor, _values )
{
	local flags = _actor.getFlags();
	if (flags.has("BH_GiftedPendingSelections") && flags.get("BH_GiftedPendingSelections") > 0)
	{
		local left = flags.get("BH_GiftedPendingSelections") - 1;
		if (left == 0) flags.remove("BH_GiftedPendingSelections"); else flags.set("BH_GiftedPendingSelections", left);
		return;
	}
	local level = _actor.getLevel() - _actor.m.LevelUps + 1;
	if (level < 1 || level > 11) return;
	local hasSkill = _values.meleeSkillIncrease > 0 || _values.rangeSkillIncrease > 0;
	local hasDefense = _values.meleeDefenseIncrease > 0 || _values.rangeDefenseIncrease > 0;
	flags.set("BH_FineBalanceQualified_" + level, hasSkill && hasDefense);
	local perk = _actor.getSkills().getSkillByID("perk.bh_fine_balance");
	if (perk != null && hasSkill && hasDefense) perk.processLevel(level);
}

::Brotherhood.registerFleshcraftPerks <- function()
{
	local perks = [];
	foreach (definition in ::Brotherhood.FleshcraftPerkDefinitions)
	{
		if (::Const.Perks.findById(definition[0]) != null) continue;
		local source = ::Const.Perks.findById(definition[2]);
		local customIcons = ::Brotherhood.getCustomPerkIcons(definition[0]);
		perks.push({
			ID = definition[0],
			Script = "scripts/skills/perks/perk_" + definition[0].slice(5),
			Name = definition[1],
			Tooltip = ::Brotherhood.getFleshcraftPerkTooltip(definition[0]),
			Icon = customIcons != null ? customIcons[0] : (source == null ? "ui/perks/perk_10.png" : source.Icon),
			IconDisabled = customIcons != null ? customIcons[1] : (source == null ? "ui/perks/perk_10_sw.png" : source.IconDisabled),
			PerkGroupIDs = []
		});
	}
	::DynamicPerks.Perks.addPerks(perks);
}

::Brotherhood.validateFleshcraftLiveData <- function()
{
	foreach (profile in ::Brotherhood.ParentProfiles)
		if (!(profile.ID in ::Brotherhood.FleshcraftTemplates)) throw "Brotherhood authored 0M parent has no matching 0B template: " + profile.ID;
	foreach (templateID, template in ::Brotherhood.FleshcraftTemplates)
	{
		if (!(templateID in ::Brotherhood.ParentProfileByID))
		{
			if (!(templateID in ::Brotherhood.DormantFleshcraftParentIDs)) throw "Brotherhood authored 0B parent has no matching 0M profile: " + templateID;
		}
		foreach (pool in [template.spine_pool, template.flesh_pool])
		{
			foreach (perkID in pool)
			{
				if (!(perkID in ::Brotherhood.FleshcraftPerkTiers)) throw "Brotherhood Fleshcraft template '" + templateID + "' has no authored tier for " + perkID;
				local tier = ::Brotherhood.FleshcraftPerkTiers[perkID];
				if (typeof tier != "integer" || tier < 1 || tier > 7) throw "Brotherhood Fleshcraft perk tier must be an integer from 1 to 7: " + perkID;
				if (::Const.Perks.findById(perkID) == null) throw "Brotherhood Fleshcraft template '" + templateID + "' references an unregistered perk: " + perkID;
			}
		}
	}
	foreach (perkID in ::Brotherhood.FleshcraftPatchUpPerks)
	{
		if (!(perkID in ::Brotherhood.FleshcraftPerkTiers)) throw "Brotherhood Patch Up perk has no authored tier: " + perkID;
		if (::Const.Perks.findById(perkID) == null) throw "Brotherhood Patch Up references an unregistered perk: " + perkID;
	}
	return true;
}

::Brotherhood.generateFleshcraftPerkTree <- function( _perkTree )
{
	local actor = _perkTree.getActor();
	local parentData = ::Brotherhood.ensureParentGeneration(actor);
	if (parentData == null || parentData.ParentIDs.len() != 4) return false;
	local state = ::Brotherhood.ParentRNG.create(::Brotherhood.ParentRNG.deriveSeed(parentData.Seed, "brotherhood-fleshcraft-tree-v1"));
	local random = function() { return ::Brotherhood.ParentRNG.nextUnit(state); };
	local parents = ::Brotherhood.constructFleshcraftParents(actor, random);
	if (parents == null || parents.len() != 4) return false;
	local duplicateCollapses = ::Brotherhood.getFleshcraftDuplicateCollapses(parents);
	local duoEligibility = ::Brotherhood.getFleshcraftDuoEligibility(parents);

	_perkTree.addPerkGroup("pg.bh_survival");
	local identityIDs = [];
	foreach (parent in parents)
	{
		foreach (perkID in parent.Half)
		{
			if (identityIDs.find(perkID) == null) identityIDs.push(perkID);
			::Brotherhood.addActiveObsidianPerk(_perkTree, perkID, ::Brotherhood.FleshcraftPerkTiers[perkID], "parent " + parent.TemplateID);
		}
	}
	local armamentAdded = ::Brotherhood.getArmamentLayerAdded(parents);
	foreach (perkID in armamentAdded)
	{
		if (identityIDs.find(perkID) == null) identityIDs.push(perkID);
		::Brotherhood.addActiveObsidianPerk(_perkTree, perkID, ::Brotherhood.FleshcraftPerkTiers[perkID], "armament");
	}

	local existingPatchUp = [];
	foreach (perkID in ::Brotherhood.FleshcraftPatchUpPerks) if (_perkTree.hasPerk(perkID)) existingPatchUp.push(perkID);
	local patchUp = ::Brotherhood.selectFleshcraftPatchUp(existingPatchUp, random);
	foreach (perkID in patchUp.Selected)
	{
		if (!_perkTree.hasPerk(perkID)) ::Brotherhood.addActiveObsidianPerk(_perkTree, perkID, ::Brotherhood.FleshcraftPerkTiers[perkID], "Patch Up");
	}

	local doctrines = [];
	if (::Brotherhood.ArmorDoctrineGenerationEnabled)
	{
		foreach (doctrine in ::Brotherhood.selectArmorDoctrines(random))
		{
			// Armor Doctrines are a separate generation layer, not Active Obsidian
			// parent content. Seat them directly at tier 6.
			_perkTree.addPerk(doctrine.ID, 6);
			if (_perkTree.hasPerk(doctrine.ID))
			{
				doctrines.push(doctrine);
				::Brotherhood.fleshcraftLogInfo("[Brotherhood][FLESHCRAFT][TREE ADD] perk=" + doctrine.ID + "; tier=6; source=Armor Doctrine; added=true");
			}
			else ::Brotherhood.fleshcraftLogInfo("[Brotherhood][FLESHCRAFT][TREE ADD] perk=" + doctrine.ID + "; tier=6; source=Armor Doctrine; added=false");
		}
	}

	_perkTree.m.BH_SelectedFleshcraftParents <- parents;
	_perkTree.m.BH_FleshcraftIdentityPerks <- identityIDs;
	_perkTree.m.BH_FleshcraftArmamentAdded <- armamentAdded;
	_perkTree.m.BH_FleshcraftDuplicateCollapses <- duplicateCollapses;
	_perkTree.m.BH_FleshcraftWildSlotsCreated <- ::Brotherhood.WildGenerationEnabled ? 20 - identityIDs.len() : 0;
	_perkTree.m.BH_FleshcraftDuoEligibility <- duoEligibility;
	_perkTree.m.BH_FleshcraftPatchUpCandidates <- patchUp.Candidates;
	_perkTree.m.BH_FleshcraftPatchUpSelected <- patchUp.Selected;
	_perkTree.m.BH_SelectedArmorDoctrines <- doctrines;

	if (::Brotherhood.FleshcraftDebugLogging || ::Brotherhood.ParentGenerationDetailedDebugLogging)
	{
		local actorName = ::MSU.isNull(actor) ? "unknown character" : actor.getName();
		local parentIDs = [];
		foreach (parent in parents)
		{
			parentIDs.push(parent.TemplateID);
			::Brotherhood.fleshcraftLogInfo(
				"[Brotherhood][FLESHCRAFT][PARENT] actor=" + actorName
				+ "; parent=" + parent.TemplateID
				+ "; contested=[" + ::Brotherhood.fleshcraftFormatIDs(parent.SeatDecisions.map(@(decision) decision.SeatID + "=" + decision.Winner)) + "]"
				+ "; spines=[" + ::Brotherhood.fleshcraftFormatIDs(parent.SeatedSpines) + "]"
				+ "; flesh=[" + ::Brotherhood.fleshcraftFormatIDs(parent.SeatedFlesh) + "]"
				+ "; half=[" + ::Brotherhood.fleshcraftFormatIDs(parent.Half) + "]"
			);
		}
		::Brotherhood.fleshcraftLogInfo(::Brotherhood.formatArmamentLayerLog(parents));
		local collapseLog = [];
		foreach (collapse in duplicateCollapses) collapseLog.push(collapse.PerkID + " x" + (collapse.CollapsedCount + 1));
		local duoLog = [];
		foreach (pair in duoEligibility) duoLog.push(pair.LeftParentID + "+" + pair.RightParentID + "=" + (pair.Eligible ? "eligible" : "overlap"));
		local finalTree = [];
		foreach (perkID, perk in _perkTree.getPerks()) finalTree.push(perkID + "@T" + (perk.Row + 1));
		::Brotherhood.fleshcraftLogInfo(
			"[Brotherhood][FLESHCRAFT][DOCTRINES] actor=" + actorName
			+ "; selected=[" + ::Brotherhood.formatSelectedDefinitionsForLog(doctrines) + "]"
			+ "; count=" + doctrines.len()
			+ "; pool=" + ::Brotherhood.ArmorDoctrinePool.len()
			+ "; roll=" + ::Brotherhood.ArmorDoctrineRollCount
		);
		::Brotherhood.fleshcraftLogInfo(
			"[Brotherhood][FLESHCRAFT][TREE] actor=" + actorName
			+ "; selected_parents=[" + ::Brotherhood.fleshcraftFormatIDs(parentIDs) + "]"
			+ "; patch_candidates=[" + ::Brotherhood.fleshcraftFormatIDs(patchUp.Candidates) + "]"
			+ "; patch_selected=[" + ::Brotherhood.fleshcraftFormatIDs(patchUp.Selected) + "]"
			+ "; duplicate_collapses=[" + ::Brotherhood.fleshcraftFormatIDs(collapseLog) + "]"
			+ "; wild_slots=" + _perkTree.m.BH_FleshcraftWildSlotsCreated
			+ "; duo_eligibility=[" + ::Brotherhood.fleshcraftFormatIDs(duoLog) + "]"
			+ "; doctrines=[" + ::Brotherhood.formatSelectedDefinitionsForLog(doctrines) + "]"
			+ "; final_tree=[" + ::Brotherhood.fleshcraftFormatIDs(finalTree) + "]"
		);
	}
	return true;
}

::Brotherhood.getLungePerk <- function( _skill )
{
	if (_skill == null || _skill.getContainer() == null || !_skill.m.IsWeaponSkill) return null;
	return _skill.getContainer().getSkillByID("perk.bh_lunge");
}

::Brotherhood.applyLungeWeaponSkillRange <- function( _skill )
{
	if (_skill == null || !("m" in _skill) || !("IsWeaponSkill" in _skill.m) || !_skill.m.IsWeaponSkill) return;
	if (::Brotherhood.isPorcupineRangedAttack(_skill)) return;
	if (!("BH_LungeRangeBonus" in _skill.m)) _skill.m.BH_LungeRangeBonus <- 0;
	if (_skill.m.BH_LungeRangeBonus != 0)
	{
		_skill.m.MaxRange -= _skill.m.BH_LungeRangeBonus;
		_skill.m.BH_LungeRangeBonus = 0;
	}
	local perk = ::Brotherhood.getLungePerk(_skill);
	if (perk != null && perk.isAvailable())
	{
		_skill.m.MaxRange += 1;
		_skill.m.BH_LungeRangeBonus = 1;
	}
}

::Brotherhood.refreshLungeWeaponSkillRanges <- function( _actor )
{
	if (_actor == null) return;
	foreach (skill in _actor.getSkills().getAllSkillsOfType(::Const.SkillType.Active))
	{
		if (skill.m.IsWeaponSkill) ::Brotherhood.applyLungeWeaponSkillRange(skill);
	}
}

::Brotherhood.getNormalWeaponSkillRange <- function( _skill )
{
	if (!("BH_FleshcraftSuppressLungeRange" in _skill.m)) _skill.m.BH_FleshcraftSuppressLungeRange <- false;
	local wasSuppressed = _skill.m.BH_FleshcraftSuppressLungeRange;
	_skill.m.BH_FleshcraftSuppressLungeRange = true;
	local ret = null;
	try
	{
		ret = _skill.getMaxRange();
	}
	catch (error)
	{
		_skill.m.BH_FleshcraftSuppressLungeRange = wasSuppressed;
		throw error;
	}
	_skill.m.BH_FleshcraftSuppressLungeRange = wasSuppressed;
	return ret;
}

::Brotherhood.getNormalWeaponSkillRangeToTarget <- function( _skill, _originTile, _targetTile )
{
	local ret = ::Brotherhood.getNormalWeaponSkillRange(_skill);
	if (_skill.m.IsRanged)
	{
		local levelDifference = _originTile.Level - _targetTile.Level;
		ret += ::Math.min(_skill.m.MaxRangeBonus, ::Math.max(0, levelDifference));
	}
	return ret;
}

::Brotherhood.getLungeDestinationSafety <- function( _actor, _originTile, _targetTile, _tile, _movementFatigue, _directionOffset )
{
	local adjacentAllies = 0;
	local adjacentEnemies = 0;
	local adjacentHighEnemies = 0;
	for (local direction = 0; direction < 6; ++direction)
	{
		if (!_tile.hasNextTile(direction)) continue;
		local neighbor = _tile.getNextTile(direction);
		if (!neighbor.IsOccupiedByActor) continue;
		local entity = neighbor.getEntity();
		if (entity.isAlliedWith(_actor))
		{
			++adjacentAllies;
			continue;
		}
		if (!entity.isAlive() || entity.isDying() || entity.getCurrentProperties().IsStunned) continue;
		++adjacentEnemies;
		if (neighbor.Level > _tile.Level) ++adjacentHighEnemies;
	}

	local effect = _tile.Properties.Effect;
	return {
		Destination = _tile,
		Fatigue = _movementFatigue,
		LevelDifference = _tile.Level - _originTile.Level,
		EnemyZOC = _tile.getZoneOfControlCountOtherThan(_actor.getAlliedFactions()),
		IsMarkedForImpact = _tile.Properties.IsMarkedForImpact,
		HasNegativeTileEffect = effect != null && !effect.IsPositive && effect.Applicable(_actor),
		IsBadTerrain = _tile.IsBadTerrain,
		Level = _tile.Level,
		TacticalValue = _tile.TVTotal,
		AdjacentAllies = adjacentAllies,
		AdjacentEnemies = adjacentEnemies,
		AdjacentHighEnemies = adjacentHighEnemies,
		DirectionOffset = _directionOffset
	};
}

::Brotherhood.isSaferLungeDestination <- function( _candidate, _currentBest )
{
	if (_currentBest == null) return true;
	if (_candidate.AdjacentEnemies != _currentBest.AdjacentEnemies) return _candidate.AdjacentEnemies < _currentBest.AdjacentEnemies;
	if (_candidate.AdjacentHighEnemies != _currentBest.AdjacentHighEnemies) return _candidate.AdjacentHighEnemies < _currentBest.AdjacentHighEnemies;
	if (_candidate.EnemyZOC != _currentBest.EnemyZOC) return _candidate.EnemyZOC < _currentBest.EnemyZOC;
	if (_candidate.IsMarkedForImpact != _currentBest.IsMarkedForImpact) return !_candidate.IsMarkedForImpact;
	if (_candidate.HasNegativeTileEffect != _currentBest.HasNegativeTileEffect) return !_candidate.HasNegativeTileEffect;
	if (_candidate.IsBadTerrain != _currentBest.IsBadTerrain) return !_candidate.IsBadTerrain;
	if (_candidate.Level != _currentBest.Level) return _candidate.Level > _currentBest.Level;
	if (_candidate.AdjacentAllies != _currentBest.AdjacentAllies) return _candidate.AdjacentAllies > _currentBest.AdjacentAllies;
	if (_candidate.TacticalValue != _currentBest.TacticalValue) return _candidate.TacticalValue > _currentBest.TacticalValue;
	if (_candidate.DirectionOffset != _currentBest.DirectionOffset) return _candidate.DirectionOffset < _currentBest.DirectionOffset;
	if (_candidate.Fatigue != _currentBest.Fatigue) return _candidate.Fatigue < _currentBest.Fatigue;
	return _candidate.DirectionOffset < _currentBest.DirectionOffset;
}

::Brotherhood.isSkillUsableFromWithoutLunge <- function( _skill, _originTile, _targetTile )
{
	if (!("BH_FleshcraftSuppressLungeValidation" in _skill.m)) _skill.m.BH_FleshcraftSuppressLungeValidation <- false;
	if (!("BH_FleshcraftSuppressLungeRange" in _skill.m)) _skill.m.BH_FleshcraftSuppressLungeRange <- false;
	local wasValidationSuppressed = _skill.m.BH_FleshcraftSuppressLungeValidation;
	local wasRangeSuppressed = _skill.m.BH_FleshcraftSuppressLungeRange;
	_skill.m.BH_FleshcraftSuppressLungeValidation = true;
	_skill.m.BH_FleshcraftSuppressLungeRange = true;
	local ret = false;
	try
	{
		ret = _skill.isUsableOn(_targetTile, _originTile);
	}
	catch (error)
	{
		_skill.m.BH_FleshcraftSuppressLungeValidation = wasValidationSuppressed;
		_skill.m.BH_FleshcraftSuppressLungeRange = wasRangeSuppressed;
		throw error;
	}
	_skill.m.BH_FleshcraftSuppressLungeValidation = wasValidationSuppressed;
	_skill.m.BH_FleshcraftSuppressLungeRange = wasRangeSuppressed;
	return ret;
}

::Brotherhood.canLungeAttackFrom <- function( _skill, _originTile, _targetTile, _forFree = false )
{
	if (_originTile == null || _targetTile == null) return false;
	local distance = _originTile.getDistanceTo(_targetTile);
	if (distance < _skill.getMinRange()) return false;
	if (distance > ::Brotherhood.getNormalWeaponSkillRangeToTarget(_skill, _originTile, _targetTile)) return false;
	if (_forFree) return _skill.isUsable() && _skill.onVerifyTarget(_originTile, _targetTile);
	return ::Brotherhood.isSkillUsableFromWithoutLunge(_skill, _originTile, _targetTile);
}

::Brotherhood.getLungeFootstepBrush <- function( _originTile, _destinationTile )
{
	local brushes = [
		"steps_top",
		"steps_top_right",
		"steps_bot_right",
		"steps_bot",
		"steps_bot_left",
		"steps_top_left"
	];
	return brushes[_originTile.getDirectionTo(_destinationTile)];
}

::Brotherhood.getLungeMove <- function( _skill, _originTile, _targetTile, _forFree = false )
{
	local actor = _skill.getContainer().getActor();
	if (actor == null || actor.getCurrentProperties().IsRooted || actor.getCurrentProperties().IsStunned) return null;
	if (_originTile == null || _targetTile == null) return null;
	local distance = _originTile.getDistanceTo(_targetTile);
	local firstDirection = _originTile.getDirectionTo(_targetTile);
	local skillFatigue = _forFree ? 0 : _skill.getFatigueCost();
	local best = null;
	for (local offset = 0; offset < 6; ++offset)
	{
		local direction = (firstDirection + offset) % 6;
		if (!_originTile.hasNextTile(direction)) continue;
		local tile = _originTile.getNextTile(direction);
		// A Lunge has exactly one movement step. IsEmpty excludes actors and
		// blocking terrain/objects; the height check mirrors normal movement.
		if (!tile.IsEmpty || ::Math.abs(tile.Level - _originTile.Level) > 1) continue;
		if (tile.getDistanceTo(_targetTile) != distance - 1) continue;
		if (!::Brotherhood.canLungeAttackFrom(_skill, tile, _targetTile, _forFree)) continue;
		local levelDifference = tile.Level - _originTile.Level;
		local movementFatigue = ::Brotherhood.getMovementStepFatigueCost(actor, tile, levelDifference);
		if (actor.getFatigue() + skillFatigue + movementFatigue > actor.getFatigueMax()) continue;
		local candidate = ::Brotherhood.getLungeDestinationSafety(actor, _originTile, _targetTile, tile, movementFatigue, offset);
		if (::Brotherhood.isSaferLungeDestination(candidate, best)) best = candidate;
	}
	return best;
}

::Brotherhood.previewLungeMove <- function( _skill, _targetTile )
{
	if (_targetTile == null) return;
	local perk = ::Brotherhood.getLungePerk(_skill);
	if (perk == null || !perk.isAvailable()) return;
	local origin = _skill.getContainer().getActor().getTile();
	local normalRange = ::Brotherhood.getNormalWeaponSkillRangeToTarget(_skill, origin, _targetTile);
	if (origin.getDistanceTo(_targetTile) != normalRange + 1) return;
	local move = ::Brotherhood.getLungeMove(_skill, origin, _targetTile, false);
	if (move == null) return;
	// The tactical-state hook draws the native gray/red hexes. Add only the
	// directional one-step path here so it does not compete with those markers.
	local footstepBrush = ::Brotherhood.getLungeFootstepBrush(origin, move.Destination);
	::Tactical.getHighlighter().addOverlayIcon(footstepBrush, move.Destination, move.Destination.Pos.X, move.Destination.Pos.Y);
}

::Brotherhood.canUseSkillForFreeOnTile <- function( _skill, _targetTile )
{
	if (_skill == null || _targetTile == null || !_skill.isUsable()) return false;
	local user = _skill.getContainer() == null ? null : _skill.getContainer().getActor();
	if (user == null || !user.isPlacedOnMap()) return false;
	local userTile = user.getTile();
	if (userTile == null) return false;
	if (!_skill.onVerifyTarget(userTile, _targetTile)) return false;
	return _skill.isInRange(_targetTile, userTile);
}

// Nested Tooltips treats [Text] / [Text|Id] as links. Plain names that contain
// brackets (e.g. legacy "[LAB] Tank") must be stripped before colorizing.
::Brotherhood.toTooltipPlainName <- function( _name )
{
	if (_name == null || _name == "") return "";
	local text = "" + _name;
	while (true)
	{
		local open = text.find("[");
		if (open == null) break;
		text = text.slice(0, open) + text.slice(open + 1);
	}
	while (true)
	{
		local close = text.find("]");
		if (close == null) break;
		text = text.slice(0, close) + text.slice(close + 1);
	}
	return text;
}

::Brotherhood.toTooltipPositiveName <- function( _name )
{
	local plain = ::Brotherhood.toTooltipPlainName(_name);
	if (plain == "") return null;
	return ::MSU.Text.colorPositive(plain);
}

// Combat tools that used to destroy on throw. They now track ammo like fire lances
// and restock after battle via World.Assets.refillAmmo (AmmoCost = 10).
::Brotherhood.CombatToolConsumableIDs <- {
	"weapon.smoke_bomb": true,
	"weapon.fire_bomb": true,
	"weapon.daze_bomb": true,
	"weapon.acid_flask": true,
	"weapon.holy_water": true,
	"tool.throwing_net": true,
	"tool.reinforced_throwing_net": true
};

// Singular / plural ammo nouns for javelin-style "Has N <noun> left" tooltips.
::Brotherhood.CombatToolAmmoNouns <- {
	"weapon.smoke_bomb": ["smoke pot", "smoke pots"],
	"weapon.fire_bomb": ["fire pot", "fire pots"],
	"weapon.daze_bomb": ["flash pot", "flash pots"],
	"weapon.acid_flask": ["acid flask", "acid flasks"],
	"weapon.holy_water": ["holy water", "holy waters"],
	"tool.throwing_net": ["net", "nets"],
	"tool.reinforced_throwing_net": ["net", "nets"]
};

::Brotherhood.getCombatToolAmmoNoun <- function( _item, _count )
{
	local id = null;
	try { id = _item.getID(); }
	catch (error) { id = null; }
	local pair = id != null && (id in ::Brotherhood.CombatToolAmmoNouns) ? ::Brotherhood.CombatToolAmmoNouns[id] : null;
	if (pair == null) return _count == 1 ? "use" : "uses";
	return _count == 1 ? pair[0] : pair[1];
};

::Brotherhood.getCombatToolAmmoLeftText <- function( _item, _ammo )
{
	local noun = ::Brotherhood.getCombatToolAmmoNoun(_item, _ammo);
	if (_ammo > 0)
		return "Has " + ::MSU.Text.colorPositive(_ammo) + " " + noun + " left";
	local emptyNoun = ::Brotherhood.getCombatToolAmmoNoun(_item, 2);
	return ::MSU.Text.colorNegative("No " + emptyNoun + " left");
};

::Brotherhood.CombatToolThrowSkillScripts <- [
	"scripts/skills/actives/throw_smoke_bomb_skill",
	"scripts/skills/actives/throw_fire_bomb_skill",
	"scripts/skills/actives/throw_daze_bomb_skill",
	"scripts/skills/actives/throw_acid_flask",
	"scripts/skills/actives/throw_holy_water",
	"scripts/skills/actives/throw_net"
];

::Brotherhood.CombatToolItemScripts <- [
	"scripts/items/tools/smoke_bomb_item",
	"scripts/items/tools/fire_bomb_item",
	"scripts/items/tools/daze_bomb_item",
	"scripts/items/tools/acid_flask_item",
	"scripts/items/tools/holy_water_item",
	"scripts/items/tools/throwing_net",
	"scripts/items/tools/reinforced_throwing_net"
];

::Brotherhood.SpendingCombatToolChargeDepth <- 0;

::Brotherhood.isCombatToolConsumable <- function( _item )
{
	if (_item == null || ::MSU.isNull(_item)) return false;
	local id = null;
	try { id = _item.getID(); }
	catch (error) { id = null; }
	return id != null && (id in ::Brotherhood.CombatToolConsumableIDs);
};

::Brotherhood.applyCombatToolAmmoTrack <- function( _item )
{
	if (!::Brotherhood.isCombatToolConsumable(_item)) return;
	_item.m.ItemType = _item.m.ItemType | ::Const.Items.ItemType.Ammo;
	_item.m.AmmoCost = 10;
	if (_item.m.AmmoMax <= 0)
	{
		_item.m.AmmoMax = 1;
		_item.m.Ammo = 1;
	}
	else if (_item.m.Ammo > _item.m.AmmoMax)
	{
		_item.m.Ammo = _item.m.AmmoMax;
	}
	_item.m.BH_CombatToolAmmo <- true;
};

::Brotherhood.replaceDestroyedOnUseTooltip <- function( _entries )
{
	if (_entries == null) return _entries;
	local replaced = false;
	foreach (entry in _entries)
	{
		if (!("text" in entry) || entry.text == null) continue;
		local text = "" + entry.text;
		if (text.find("destroyed on use") == null && text.find("Destroyed on use") == null) continue;
		entry.icon <- "ui/icons/ammo.png";
		entry.text = "Refilled after battle for " + ::MSU.Text.colorPositive("10") + " company ammo";
		replaced = true;
	}
	if (!replaced)
	{
		_entries.push({
			id = 6,
			type = "text",
			icon = "ui/icons/ammo.png",
			text = "Refilled after battle for " + ::MSU.Text.colorPositive("10") + " company ammo"
		});
	}
	return _entries;
};

// Spend one tool charge and keep the item. Returns true when unequip should be blocked.
::Brotherhood.trySpendCombatToolCharge <- function( _item )
{
	if (!::Brotherhood.isCombatToolConsumable(_item)) return false;
	::Brotherhood.applyCombatToolAmmoTrack(_item);
	local ammo = _item.getAmmo();
	if (ammo <= 0) return false;

	_item.setAmmo(ammo - 1);
	local actor = null;
	if (_item.getContainer() != null) actor = _item.getContainer().getActor();
	if (actor != null && !::MSU.isNull(actor) && actor.isAlive())
	{
		actor.setDirty(true);
		::Brotherhood.logFleshcraftMechanic("COMBAT TOOL", actor, "Spent one use of " + _item.getName() + "; " + _item.getAmmo() + "/" + _item.getAmmoMax() + " remain.");
	}
	return true;
};

::Brotherhood.isConsumableMasterySkill <- function( _skill )
{
	if (_skill == null || _skill.getContainer() == null) return false;
	if (!_skill.getContainer().hasSkill("perk.bh_consumable_mastery")) return false;
	local item = null;
	try { item = _skill.getItem(); }
	catch (error) { item = null; }
	return ::Brotherhood.isCombatToolConsumable(item);
};

::Brotherhood.canCompareActorAlliance <- function( _actor )
{
	return _actor != null && _actor.isAlive() && !_actor.isDying() && _actor.isPlacedOnMap();
}

::Brotherhood.areActorsAllied <- function( _a, _b )
{
	if (!::Brotherhood.canCompareActorAlliance(_a) || !::Brotherhood.canCompareActorAlliance(_b)) return false;
	try
	{
		return _a.isAlliedWith(_b);
	}
	catch (error)
	{
		return false;
	}
}

::Brotherhood.collectSentinelCountersForAttack <- function( _attacker, _target )
{
	local sentinels = [];
	if (_attacker == null || _target == null) return sentinels;
	if (!::Brotherhood.canCompareActorAlliance(_attacker) || !::Brotherhood.canCompareActorAlliance(_target)) return sentinels;
	if (::Brotherhood.areActorsAllied(_attacker, _target)) return sentinels;

	foreach (entity in ::Tactical.Entities.getAllInstancesAsArray())
	{
		if (!::Brotherhood.canCompareActorAlliance(entity)) continue;
		if (!::Brotherhood.areActorsAllied(entity, _target)) continue;
		local sentinel = entity.getSkills().getSkillByID("perk.bh_sentinel");
		if (sentinel != null) sentinels.push(sentinel);
	}
	return sentinels;
}

::Brotherhood.processLungeLeaveZoneOfControlAttacks <- function( _actor, _originTile )
{
	if (_actor == null || _originTile == null) return true;
	for (local direction = 0; direction < 6; ++direction)
	{
		if (!_originTile.hasNextTile(direction)) continue;
		local neighbor = _originTile.getNextTile(direction);
		if (!neighbor.IsOccupiedByActor) continue;
		local enemy = neighbor.getEntity();
		if (enemy.isAlliedWith(_actor) || enemy.getCurrentProperties().IsStunned) continue;
		if (!enemy.onMovementInZoneOfControl(_actor, false)) continue;
		if (!enemy.onAttackOfOpportunity(_actor, false)) continue;
		::Brotherhood.logFleshcraftMechanic("LUNGE", _actor, "Stopped by " + enemy.getName() + "'s attack of opportunity while leaving a zone of control.");
		return false;
	}
	return true;
}

::Brotherhood.canContinueLungeAfterZoneOfControl <- function( _actor, _originTile )
{
	return ::Brotherhood.processLungeLeaveZoneOfControlAttacks(_actor, _originTile);
}

::Brotherhood.triggerLungeAttacksOfOpportunity <- function( _actor, _originTile = null )
{
	return ::Brotherhood.canContinueLungeAfterZoneOfControl(_actor, _originTile);
}

::Brotherhood.finishLungeMove <- function( _actor, _tag )
{
	_tag.Skill.getContainer().setBusy(false);
	if (!_actor.isAlive() || _actor.isDying()) return;
	::Brotherhood.logFleshcraftMechanic("LUNGE", _actor, "Moved to tile " + _actor.getTile().ID + " for " + _tag.MovementFatigue + " Fatigue (adjacent_enemies=" + _tag.AdjacentEnemies + ", enemy_zoc=" + _tag.EnemyZOC + ", bad_terrain=" + _tag.IsBadTerrain.tostring() + ", marked_for_impact=" + _tag.IsMarkedForImpact.tostring() + "), then used " + _tag.Skill.getName() + ".");
	_tag.Original.call(_tag.Skill, _tag.TargetTile, _tag.ForFree);
}

::Brotherhood.isFleshcraftThrowingWeapon <- function( _item )
{
	if (_item == null || !_item.isItemType(::Const.Items.ItemType.Weapon) || !_item.isItemType(::Const.Items.ItemType.Ammo)) return false;
	// Canonical IDs are stable across vanilla, named, barbarian, and greenskin
	// variants; WeaponType and inherited-method reflection are not.
	local id = _item.getID().tolower();
	return id.find("javelin") != null || id.find("throwing_axe") != null;
}

::Brotherhood.getGhostInjuryEffectID <- function( _injuryID )
{
	// Avoid another dotted ID segment: parts of the character UI collapse it.
	return "effects.bh_ghost_injury_" + ::String.replace(::String.replace(_injuryID, ".", "_"), "/", "_");
}

::Brotherhood.PorcupineIgnoreZoneOfControlDepth <- 0;

::Brotherhood.isPorcupineRangedAttack <- function( _skill )
{
	if (_skill == null || _skill.getContainer() == null || !_skill.isAttack() || !_skill.isRanged()) return false;
	local actor = _skill.getContainer().getActor();
	return actor != null && actor.getSkills().hasSkill("perk.bh_porcupine");
}

::Brotherhood.beginPorcupineRangedEvaluation <- function( _skill )
{
	if (!::Brotherhood.isPorcupineRangedAttack(_skill)) return false;
	++::Brotherhood.PorcupineIgnoreZoneOfControlDepth;
	return true;
}

::Brotherhood.endPorcupineRangedEvaluation <- function( _active )
{
	if (_active) ::Brotherhood.PorcupineIgnoreZoneOfControlDepth = ::Math.max(0, ::Brotherhood.PorcupineIgnoreZoneOfControlDepth - 1);
}

::Brotherhood.replaceFleshcraftTooltipText <- function( _text, _search, _replacement )
{
	local ret = "";
	local offset = 0;
	while (true)
	{
		local found = _text.find(_search, offset);
		if (found == null) return ret + _text.slice(offset);
		ret += _text.slice(offset, found) + _replacement;
		offset = found + _search.len();
	}
}

::Brotherhood.cleanPorcupineRangedTooltip <- function( _tooltip )
{
	local ret = [];
	foreach (entry in _tooltip)
	{
		if ("text" in entry && typeof entry.text == "string")
		{
			local lower = entry.text.tolower();
			local isWarning = "icon" in entry && entry.icon == "ui/tooltips/warning.png";
			if (isWarning && lower.find("cannot be used") != null && lower.find("engaged") != null) continue;
			if (isWarning && lower.find("can not be used") != null && lower.find("engaged") != null) continue;
			entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, " Can not be used while engaged in melee.", "");
			entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, " Cannot be used while engaged in melee.", "");
			entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, "Can not be used while engaged in melee. ", "");
			entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, "Cannot be used while engaged in melee. ", "");
			entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, ", more if shooting downhill", "");
			entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, ", more if slinging downhill", "");
		}
		ret.push(entry);
	}
	return ret;
}

::Brotherhood.configureVolleyWeaponSlot <- function( _item, _actor, _preferredSlot = null )
{
	if (!::Brotherhood.isFleshcraftThrowingWeapon(_item) || _actor == null) return;
	if (!_actor.getSkills().hasSkill("perk.bh_volley_mastery"))
	{
		_item.m.SlotType = ::Const.ItemSlot.Mainhand;
		_item.m.BlockedSlotType = null;
		if ("BH_VolleyRequestedSlot" in _item.m) delete _item.m.BH_VolleyRequestedSlot;
		if ("BH_VolleyEquippedSlot" in _item.m) delete _item.m.BH_VolleyEquippedSlot;
		return;
	}
	if (_preferredSlot == "mainhand") _preferredSlot = ::Const.ItemSlot.Mainhand;
	else if (_preferredSlot == "offhand") _preferredSlot = ::Const.ItemSlot.Offhand;
	if (_preferredSlot == ::Const.ItemSlot.Mainhand || _preferredSlot == ::Const.ItemSlot.Offhand)
	{
		_item.m.SlotType = _preferredSlot;
		_item.m.BlockedSlotType = null;
		_item.m.BH_VolleyEquippedSlot <- _preferredSlot;
		// The character screen decides which equipped item to remove before the
		// lower item_container.equip hook runs. Preserve that explicit hand choice
		// across both Modern Hooks layers so the lower hook cannot reset it.
		_item.m.BH_VolleyRequestedSlot <- _preferredSlot;
		return;
	}
	// Tactical-to-world inventory transfer unequips an item before equipping it
	// on the persistent actor. Preserve the last explicitly equipped Volley hand
	// so an offhand bundle is not forced onto an occupied main hand and lost.
	if ("BH_VolleyEquippedSlot" in _item.m && (_item.m.BH_VolleyEquippedSlot == ::Const.ItemSlot.Mainhand || _item.m.BH_VolleyEquippedSlot == ::Const.ItemSlot.Offhand))
	{
		_item.m.SlotType = _item.m.BH_VolleyEquippedSlot;
		_item.m.BlockedSlotType = null;
		return;
	}
	// Automatic and right-click equipment stays vanilla-like and targets the
	// main hand. Only an explicit paperdoll drop may request the off hand.
	_item.m.SlotType = ::Const.ItemSlot.Mainhand;
	_item.m.BlockedSlotType = null;
}

::Brotherhood.resetVolleyWeaponForBag <- function( _item )
{
	if (_item == null || !::Brotherhood.isFleshcraftThrowingWeapon(_item)) return;
	_item.m.SlotType = ::Const.ItemSlot.Mainhand;
	_item.m.BlockedSlotType = null;
	if ("BH_VolleyRequestedSlot" in _item.m) delete _item.m.BH_VolleyRequestedSlot;
	if ("BH_VolleyEquippedSlot" in _item.m) delete _item.m.BH_VolleyEquippedSlot;
}

// Consumable Mastery dual-wield: combat tools are natively Offhand-only. With the
// perk they may also occupy Mainhand, using the same requested-slot handoff as Volley.
::Brotherhood.hasConsumableMastery <- function( _actor )
{
	return _actor != null && _actor.getSkills().hasSkill("perk.bh_consumable_mastery");
}

::Brotherhood.configureConsumableToolSlot <- function( _item, _actor, _preferredSlot = null )
{
	if (!::Brotherhood.isCombatToolConsumable(_item) || _actor == null) return;
	if (!::Brotherhood.hasConsumableMastery(_actor))
	{
		_item.m.SlotType = ::Const.ItemSlot.Offhand;
		_item.m.BlockedSlotType = null;
		if ("BH_ConsumableRequestedSlot" in _item.m) delete _item.m.BH_ConsumableRequestedSlot;
		if ("BH_ConsumableEquippedSlot" in _item.m) delete _item.m.BH_ConsumableEquippedSlot;
		return;
	}
	if (_preferredSlot == "mainhand") _preferredSlot = ::Const.ItemSlot.Mainhand;
	else if (_preferredSlot == "offhand") _preferredSlot = ::Const.ItemSlot.Offhand;
	if (_preferredSlot == ::Const.ItemSlot.Mainhand || _preferredSlot == ::Const.ItemSlot.Offhand)
	{
		_item.m.SlotType = _preferredSlot;
		_item.m.BlockedSlotType = null;
		_item.m.BH_ConsumableEquippedSlot <- _preferredSlot;
		_item.m.BH_ConsumableRequestedSlot <- _preferredSlot;
		return;
	}
	if ("BH_ConsumableEquippedSlot" in _item.m
		&& (_item.m.BH_ConsumableEquippedSlot == ::Const.ItemSlot.Mainhand || _item.m.BH_ConsumableEquippedSlot == ::Const.ItemSlot.Offhand))
	{
		_item.m.SlotType = _item.m.BH_ConsumableEquippedSlot;
		_item.m.BlockedSlotType = null;
		return;
	}
	// Tools stay offhand by default; only an explicit / inferred mainhand drop switches.
	_item.m.SlotType = ::Const.ItemSlot.Offhand;
	_item.m.BlockedSlotType = null;
}

::Brotherhood.resetConsumableToolForBag <- function( _item )
{
	if (_item == null || !::Brotherhood.isCombatToolConsumable(_item)) return;
	_item.m.SlotType = ::Const.ItemSlot.Offhand;
	_item.m.BlockedSlotType = null;
	if ("BH_ConsumableRequestedSlot" in _item.m) delete _item.m.BH_ConsumableRequestedSlot;
	if ("BH_ConsumableEquippedSlot" in _item.m) delete _item.m.BH_ConsumableEquippedSlot;
}

::Brotherhood.PendingCombatToolSpendItem <- null;

::Brotherhood.hasSnappingTurtle <- function( _actor )
{
	return _actor != null && _actor.getSkills().hasSkill("perk.bh_snapping_turtle");
}

::Brotherhood.isSnappingTurtleTwoHandedWeapon <- function( _item )
{
	if (_item == null) return false;
	if (_item.isItemType(::Const.Items.ItemType.TwoHanded)) return true;
	return "m" in _item && "BlockedSlotType" in _item.m && _item.m.BlockedSlotType == ::Const.ItemSlot.Offhand;
}

::Brotherhood.canSnappingTurtleEquipShield <- function( _actor, _inventory, _shield )
{
	if (!::Brotherhood.hasSnappingTurtle(_actor) || _inventory == null || _shield == null) return false;
	if (!_shield.isItemType(::Const.Items.ItemType.Shield)) return false;
	return ::Brotherhood.isSnappingTurtleTwoHandedWeapon(_inventory.getItemAtSlot(::Const.ItemSlot.Mainhand));
}

::Brotherhood.configureSnappingTurtleWeapon <- function( _item, _actor )
{
	if (_actor == null || _item == null || !::Brotherhood.isSnappingTurtleTwoHandedWeapon(_item)) return;
	local allowed = ::Brotherhood.hasSnappingTurtle(_actor);
	if ("BH_SnappingTurtleAllowed" in _item.m) _item.m.BH_SnappingTurtleAllowed = allowed;
	else _item.m.BH_SnappingTurtleAllowed <- allowed;
	_item.m.BlockedSlotType = allowed ? null : ::Const.ItemSlot.Offhand;
}

::Brotherhood.prepareSnappingTurtleEquip <- function( _inventory, _actor, _item )
{
	if (_inventory == null || _actor == null) return;

	local main = _inventory.getItemAtSlot(::Const.ItemSlot.Mainhand);
	if (main != null) ::Brotherhood.configureSnappingTurtleWeapon(main, _actor);
	if (::Brotherhood.isSnappingTurtleTwoHandedWeapon(_item)) ::Brotherhood.configureSnappingTurtleWeapon(_item, _actor);

	if (::Brotherhood.hasSnappingTurtle(_actor) && _item != null && _item.isItemType(::Const.Items.ItemType.Shield))
		::Brotherhood.clearSnappingTurtleOffhandBlocker(_inventory);
}

::Brotherhood.clearSnappingTurtleOffhandBlocker <- function( _inventory )
{
	if (_inventory == null || !("m" in _inventory) || !("Items" in _inventory.m)) return;
	local offhand = ::Const.ItemSlot.Offhand;
	if (!(offhand in _inventory.m.Items)) return;
	for (local i = 0; i < _inventory.m.Items[offhand].len(); ++i)
	{
		if (_inventory.m.Items[offhand][i] == -1) _inventory.m.Items[offhand][i] = null;
	}
}

::Brotherhood.refreshSnappingTurtleLoadout <- function( _actor, _reason = "" )
{
	if (_actor == null) return;

	local items = _actor.getItems();
	local main = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
	local off = items.getItemAtSlot(::Const.ItemSlot.Offhand);
	if (!::Brotherhood.isSnappingTurtleTwoHandedWeapon(main)) return;

	local hasPerk = ::Brotherhood.hasSnappingTurtle(_actor);
	if (!hasPerk)
	{
		if (off == null && main.m.BlockedSlotType == null) main.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		::Brotherhood.refreshSnappingTurtleAppearance(_actor);
		return;
	}

	if (off == null && items.hasBlockedSlot(::Const.ItemSlot.Offhand) && main.m.BlockedSlotType != null)
	{
		local blocked = main.m.BlockedSlotType;
		if (items.unequip(main))
		{
			main.m.BlockedSlotType = null;
			items.equip(main);
		}
		else main.m.BlockedSlotType = blocked;
	}
	else main.m.BlockedSlotType = null;

	::Brotherhood.refreshSnappingTurtleAppearance(_actor);

	local perk = _actor.getSkills().getSkillByID("perk.bh_snapping_turtle");
	if (perk != null && "refreshLoadout" in perk) perk.refreshLoadout();
	_actor.getSkills().update();
	if (_reason != "" && ::Brotherhood.FleshcraftDebugLogging)
		::Brotherhood.logFleshcraftMechanic("SNAPPING TURTLE", _actor, "Refreshed loadout: " + _reason);
}

::Brotherhood.refreshSnappingTurtleAppearance <- function( _actor )
{
	if (_actor == null || !::Brotherhood.hasSnappingTurtle(_actor)) return;

	local items = _actor.getItems();
	local main = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
	local off = items.getItemAtSlot(::Const.ItemSlot.Offhand);
	if (!::Brotherhood.isSnappingTurtleTwoHandedWeapon(main)) return;

	if (off != null && off.isItemType(::Const.Items.ItemType.Shield) && "updateAppearance" in off) off.updateAppearance();
	if ("updateAppearance" in main) main.updateAppearance();
	if ("updateAppearance" in items) items.updateAppearance();
}

::Brotherhood.applyDistractedObservers <- function( _attacker, _targetName, _targetWasPlayerAllied, _attackerWasPlayerAllied, _isTargeted )
{
	if (_attacker == null || !_isTargeted || !_targetWasPlayerAllied || _attackerWasPlayerAllied || !("Tactical" in getroottable()) || ::Tactical.Entities == null) return;
	foreach (observer in ::Tactical.Entities.getAllInstancesAsArray())
	{
		if (observer == null || !observer.isAlive() || observer.isDying() || !observer.isPlacedOnMap() || !observer.isAlliedWithPlayer()) continue;
		if (observer.getSkills().getSkillByID("perk.bh_distracted") == null || observer.getTile().getDistanceTo(_attacker.getTile()) > 2) continue;
		local id = "effects.bh_distracted." + observer.getID();
		local existing = _attacker.getSkills().getSkillByID(id);
		if (existing != null) existing.m.AppliedRound = ::Time.getRound();
		else
		{
			local effect = ::new("scripts/skills/effects/bh_distracted_effect");
			effect.configure(observer.getID());
			_attacker.getSkills().add(effect);
		}
		_attacker.setDirty(true);
		::Brotherhood.logFleshcraftMechanic("DISTRACTED", observer, "Marked " + _attacker.getName() + " for targeting " + _targetName + ".");
	}
}

// Vanilla's onMissed carries no roll, so a perk cannot tell a near miss from a
// wide one. Modular Vanilla resolves the roll immediately before the miss
// propagates, so the margin is recorded here for the following onMissed only.
::Brotherhood.LastAttackMissMargin <- null;

// Nerves of Steel replaces the damage-triggered morale check rather than adding
// a second one. Vanilla fires exactly one negative check inside
// actor.onDamageReceived, with difficulty
//   Const.Morale.OnHitBaseDifficulty * (1.0 - hp / hpMax) - attacker.ThreatOnHit
// so the replacement is that same call with the missing-Hitpoints factor removed,
// leaving -ThreatOnHit. These fields mark the one check to rewrite.
::Brotherhood.NervesOfSteelPending <- false;
::Brotherhood.NervesOfSteelAttacker <- null;

::Brotherhood.initializeFleshcraftLive <- function()
{
	::Brotherhood.registerFleshcraftPerks();
	::Brotherhood.validateFleshcraftLiveData();
	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.MV_onAttackRolled = @(__original) { function MV_onAttackRolled( _attackInfo )
		{
			__original(_attackInfo);
			::Brotherhood.LastAttackMissMargin = _attackInfo.Roll > _attackInfo.ChanceToHit ? _attackInfo.Roll - _attackInfo.ChanceToHit : null;
		}}.MV_onAttackRolled;
	});

	::Brotherhood.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
		q.onDamageReceived = @(__original) { function onDamageReceived( _attacker, _skill, _hitInfo )
		{
			if (!this.getSkills().hasSkill("perk.bh_nerves_of_steel")) return __original(_attacker, _skill, _hitInfo);
			// Damage can nest, so the previous marker is restored rather than cleared.
			local wasPending = ::Brotherhood.NervesOfSteelPending;
			local wasAttacker = ::Brotherhood.NervesOfSteelAttacker;
			::Brotherhood.NervesOfSteelPending = true;
			::Brotherhood.NervesOfSteelAttacker = _attacker;
			local ret;
			try
			{
				ret = __original(_attacker, _skill, _hitInfo);
			}
			catch (error)
			{
				::Brotherhood.NervesOfSteelPending = wasPending;
				::Brotherhood.NervesOfSteelAttacker = wasAttacker;
				throw error;
			}
			::Brotherhood.NervesOfSteelPending = wasPending;
			::Brotherhood.NervesOfSteelAttacker = wasAttacker;
			return ret;
		}}.onDamageReceived;

		q.checkMorale = @(__original) { function checkMorale( _change, _difficulty, _type = ::Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
		{
			if (!::Brotherhood.NervesOfSteelPending || _change >= 0 || _type != ::Const.MoraleCheckType.Default
				|| !this.getSkills().hasSkill("perk.bh_nerves_of_steel"))
			{
				return __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
			}
			// Consume the marker so only the damage-triggered check is rewritten.
			::Brotherhood.NervesOfSteelPending = false;
			local attacker = ::Brotherhood.NervesOfSteelAttacker;
			local threat = attacker != null && attacker.getID() != this.getID() ? attacker.getCurrentProperties().ThreatOnHit : 0;
			::Brotherhood.logFleshcraftMechanic("NERVES OF STEEL", this, "Replaced the damage morale check with one unaffected by missing Hitpoints (difficulty " + (-threat) + " instead of " + _difficulty + ").");
			return __original(_change, -threat, _type, _showIconBeforeMoraleIcon, _noNewLine);
		}}.checkMorale;
	});
	if (!("BH_PorcupineNativeTileHooked" in ::Brotherhood))
	{
		local originalHasZoneOfControlOtherThan = ::TacticalTile.hasZoneOfControlOtherThan;
		::TacticalTile.hasZoneOfControlOtherThan <- { function hasZoneOfControlOtherThan( _factions )
		{
			if (::Brotherhood.PorcupineIgnoreZoneOfControlDepth > 0) return false;
			return originalHasZoneOfControlOtherThan(_factions);
		}}.hasZoneOfControlOtherThan;
		::Brotherhood.BH_PorcupineNativeTileHooked <- true;
	}
	::Brotherhood.Mod.Tooltips.setTooltips({
		PreparationStrength = ::MSU.Class.CustomTooltip(function( _data )
		{
			local raw = _data.ExtraData;
			return [
				{ id = 1, type = "title", text = "Preparation" },
				{ id = 2, type = "description", text = "This potion effect is strengthened by Preparation." },
				{ id = 3, type = "text", icon = "ui/icons/special.png", text = "Base value: " + ::MSU.Text.colorPositive(raw) },
				{ id = 4, type = "text", icon = "ui/icons/damage_dealt.png", text = "Strength modifier: " + ::MSU.Text.colorPositive("+25%") }
			];
		}),
		BHLightInjuries = ::MSU.Class.CustomTooltip(function( _data ) { return ::Brotherhood.getInjuryCategoryTooltip(false); }),
		BHHeavyInjuries = ::MSU.Class.CustomTooltip(function( _data ) { return ::Brotherhood.getInjuryCategoryTooltip(true); })
	});

	// The tactical UI can collapse a configured Ghost Injury ID back to its
	// base ID. Prefer the configured instance so its real injury name and
	// halved penalties are shown instead of the generic placeholder tooltip.
	::Brotherhood.getConfiguredGhostInjuryTooltip <- function( _entityID, _statusEffectID )
	{
		if (_statusEffectID == null || _statusEffectID.find("effects.bh_ghost_injury") != 0) return null;
		local entity = ::Tactical.getEntityByID(_entityID);
		if (entity == null) return null;
		local configured = null;
		foreach (skill in entity.getSkills().m.Skills)
		{
			if (skill == null || (skill.getID().find("effects.bh_ghost_injury_") != 0 && skill.getID().find("effects.bh_ghost_injury.") != 0)) continue;
			if (skill.getID() == _statusEffectID) return skill.getTooltip();
			if (configured == null) configured = skill;
		}
		return configured == null ? null : configured.getTooltip();
	}

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.onQueryStatusEffectTooltipData = @(__original) { function onQueryStatusEffectTooltipData( _entityID, _statusEffectID )
		{
			local ret = ::Brotherhood.getConfiguredGhostInjuryTooltip(_entityID, _statusEffectID);
			return ret == null ? __original(_entityID, _statusEffectID) : ret;
		}}.onQueryStatusEffectTooltipData;
		q.onQuerySkillTooltipData = @(__original) { function onQuerySkillTooltipData( _entityID, _skillID )
		{
			local ret = ::Brotherhood.getConfiguredGhostInjuryTooltip(_entityID, _skillID);
			return ret == null ? __original(_entityID, _skillID) : ret;
		}}.onQuerySkillTooltipData;
		q.general_queryStatusEffectTooltipData = @(__original) { function general_queryStatusEffectTooltipData( _entityID, _statusEffectID )
		{
			local ret = ::Brotherhood.getConfiguredGhostInjuryTooltip(_entityID, _statusEffectID);
			return ret == null ? __original(_entityID, _statusEffectID) : ret;
		}}.general_queryStatusEffectTooltipData;
		q.general_querySkillTooltipData = @(__original) { function general_querySkillTooltipData( _entityID, _skillID )
		{
			local ret = ::Brotherhood.getConfiguredGhostInjuryTooltip(_entityID, _skillID);
			return ret == null ? __original(_entityID, _skillID) : ret;
		}}.general_querySkillTooltipData;
	});

	// Nested Tooltips / some UI paths query the base effect ID (from the script
	// template), but configured marks rename to effects.bh_xyz.<entityId>.
	// Resolve those base IDs to the live configured instance so tooltips keep
	// owner names instead of falling back to an unconfigured template.
	::Brotherhood.resolveConfiguredEffectByBaseID <- function( _skills, _baseID )
	{
		if (_skills == null || _baseID == null) return null;
		local prefix = _baseID + ".";
		local altPrefix = _baseID + "_";
		foreach (skill in _skills)
		{
			if (skill == null || skill.isGarbage()) continue;
			local id = skill.getID();
			if (id.find(prefix) == 0 || id.find(altPrefix) == 0) return skill;
		}
		return null;
	}

	::Brotherhood.HooksMod.hook("scripts/skills/skill_container", function(q) {
		q.getSkillByID = @(__original) { function getSkillByID( _id )
		{
			local ret = __original(_id);
			if (ret != null) return ret;
			if (_id == "effects.bh_ghost_injury" || _id == "effects.bh_nidhogg")
				return ::Brotherhood.resolveConfiguredEffectByBaseID(this.m.Skills, _id);
			return null;
		}}.getSkillByID;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/disarm_skill", function(q) {
		q.getHitChanceModifier = @(__original) { function getHitChanceModifier()
		{
			return this.getContainer() != null && this.getContainer().hasSkill("perk.bh_cleaver_mastery") ? -10 : __original();
		}}.getHitChanceModifier;
	});

	foreach (throwingSkillScript in ["scripts/skills/actives/throw_axe", "scripts/skills/actives/throw_javelin"])
	{
		::Brotherhood.HooksMod.hook(throwingSkillScript, function(q) {
			q.bh_getAmmoItem <- function()
			{
				// The skill's bound weapon is authoritative. Slot inference is only a
				// fallback for old/save-loaded skills that lost their item pointer.
				local bound = this.getItem();
				if (!::MSU.isNull(bound) && ::Brotherhood.isFleshcraftThrowingWeapon(bound)) return bound;
				local actor = this.getContainer() == null ? null : this.getContainer().getActor();
				if (actor != null)
				{
					local slot = this.getID().find(".bh_volley_offhand") == null ? ::Const.ItemSlot.Mainhand : ::Const.ItemSlot.Offhand;
					local equipped = actor.getItems().getItemAtSlot(slot);
					if (!::MSU.isNull(equipped) && ::Brotherhood.isFleshcraftThrowingWeapon(equipped)) return equipped;
				}
				return null;
			}
			q.getAmmo = @(__original) { function getAmmo()
			{
				// Main-hand throwing must stay on the proven vanilla/Reforged path.
				// Only Volley's offhand clone needs Brotherhood slot resolution.
				if (this.getID().find(".bh_volley_offhand") == null) return __original();
				local item = this.bh_getAmmoItem();
				return item == null ? 0 : item.getAmmo();
			}}.getAmmo;
			q.consumeAmmo = @(__original) { function consumeAmmo()
			{
				if (this.getID().find(".bh_volley_offhand") == null) return __original();
				local item = this.bh_getAmmoItem();
				if (item != null) item.consumeAmmo();
			}}.consumeAmmo;
		});
	}

	::Brotherhood.HooksMod.hook("scripts/skills/actives/rf_gouge_skill", function(q) {
		q.getInjuryThresholdMult = @(__original) { function getInjuryThresholdMult()
		{
			return this.getContainer() != null && this.getContainer().hasSkill("perk.bh_cleaver_mastery") ? 0.5 : __original();
		}}.getInjuryThresholdMult;
	});

	::Brotherhood.HooksMod.hookTree("scripts/skills/skill", function(q) {
		q.isHidden = @(__original) { function isHidden()
		{
			return __original() || ::Brotherhood.shouldHideCombatSkillOutsideBattle(this);
		}}.isHidden;

		q.getTooltip = @(__original) { function getTooltip()
		{
			local porcupine = ::Brotherhood.isPorcupineRangedAttack(this);
			local suppressZoneOfControl = ::Brotherhood.beginPorcupineRangedEvaluation(this);
			local ret = __original();
			::Brotherhood.endPorcupineRangedEvaluation(suppressZoneOfControl);
			if (porcupine) ret = ::Brotherhood.cleanPorcupineRangedTooltip(ret);
			if (!::Brotherhood.isPreparationAmplifiedEffect(this)) return ret;
			foreach (entry in ret)
				if (("type" in entry) && entry.type == "text" && ("text" in entry)) entry.text = ::Brotherhood.decoratePreparationTooltipText(entry.text);
			return ret;
		}}.getTooltip;

		q.getFatigueCost = @(__original) { function getFatigueCost()
		{
			local cost = __original();
			if (this.getContainer() == null || !this.getContainer().hasSkill("perk.bh_cleaver_mastery")) return cost;
			local weapon = this.getItem();
			if (weapon == null || !("isWeaponType" in weapon) || !weapon.isWeaponType(::Const.Items.WeaponType.Cleaver)) return cost;
			return ::Math.max(0, ::Math.round(cost * 0.75));
		}}.getFatigueCost;

		q.onUpdate = @(__original) { function onUpdate( _properties )
		{
			local amplify = ::Brotherhood.isPreparationAmplifiedEffect(this);
			if (!amplify) return __original(_properties);
			local before = {};
			foreach (key, value in _properties)
				if (typeof value == "integer" || typeof value == "float") before[key] <- value;
			__original(_properties);
			foreach (key, oldValue in before)
				if (_properties[key] != oldValue) _properties[key] = oldValue + (_properties[key] - oldValue) * 1.25;
		}}.onUpdate;

		q.onAfterUpdate = @(__original) { function onAfterUpdate( _properties )
		{
			local item = this.getItem();
			local id = this.getID();
			local isThrowingAttack = id.find("actives.throw_axe") == 0 || id.find("actives.throw_javelin") == 0;
			local lacksAccuracyGetter = isThrowingAttack && (item == null || !("getAdditionalAccuracy" in item));
			if (lacksAccuracyGetter)
			{
				// Modular Vanilla calls the item getter unconditionally. During Volley
				// unequip transitions the skill can briefly have no compatible item.
				// Preserve Reforged's existing accuracy and apply only the shared mastery cost.
				if (_properties.IsSpecializedInThrowing)
					this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
			}
			else __original(_properties);
			if (::Brotherhood.isPorcupineRangedAttack(this))
			{
				this.m.MinRange = 1;
				this.m.MaxRange = 1;
				this.m.MaxRangeBonus = 0;
			}
			else ::Brotherhood.applyLungeWeaponSkillRange(this);
		}}.onAfterUpdate;

		q.getMaxRange = @(__original) { function getMaxRange()
		{
			local ret = __original();
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null && this.isAttack() && this.isRanged() && actor.getSkills().hasSkill("perk.bh_porcupine")) return 1;
			if (("BH_FleshcraftSuppressLungeRange" in this.m) && this.m.BH_FleshcraftSuppressLungeRange
				&& ("BH_LungeRangeBonus" in this.m) && this.m.BH_LungeRangeBonus != 0)
			{
				return ret - this.m.BH_LungeRangeBonus;
			}
			return ret;
		}}.getMaxRange;

		q.getMinRange = @(__original) { function getMinRange()
		{
			local ret = __original();
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			return actor != null && this.isAttack() && this.isRanged() && actor.getSkills().hasSkill("perk.bh_porcupine") ? 1 : ret;
		}}.getMinRange;

		q.isUsableOn = @(__original) { function isUsableOn( _targetTile, _userTile = null )
		{
			local suppressZoneOfControl = ::Brotherhood.beginPorcupineRangedEvaluation(this);
			local ret = __original(_targetTile, _userTile);
			::Brotherhood.endPorcupineRangedEvaluation(suppressZoneOfControl);
			if (("BH_FleshcraftSuppressLungeValidation" in this.m) && this.m.BH_FleshcraftSuppressLungeValidation) return ret;
			if (_targetTile == null) return ret;
			local perk = ::Brotherhood.getLungePerk(this);
			if (perk == null || !perk.isAvailable()) return ret;
			local origin = _userTile == null ? this.getContainer().getActor().getTile() : _userTile;
			local normalRange = ::Brotherhood.getNormalWeaponSkillRangeToTarget(this, origin, _targetTile);
			local distance = origin.getDistanceTo(_targetTile);
			if (distance <= normalRange) return ret;
			if (distance != normalRange + 1) return false;
			return ::Brotherhood.getLungeMove(this, origin, _targetTile, false) != null;
		}}.isUsableOn;

		q.isInRange = @(__original) { function isInRange( _targetTile, _userTile = null )
		{
			local suppressZoneOfControl = ::Brotherhood.beginPorcupineRangedEvaluation(this);
			local ret = __original(_targetTile, _userTile);
			::Brotherhood.endPorcupineRangedEvaluation(suppressZoneOfControl);
			if (_targetTile == null) return ret;
			local perk = ::Brotherhood.getLungePerk(this);
			if (perk == null || !perk.isAvailable()) return ret;
			local origin = _userTile == null ? this.getContainer().getActor().getTile() : _userTile;
			local normalRange = ::Brotherhood.getNormalWeaponSkillRangeToTarget(this, origin, _targetTile);
			local distance = origin.getDistanceTo(_targetTile);
			if (distance <= normalRange) return ret;
			if (distance != normalRange + 1) return false;
			return ::Brotherhood.getLungeMove(this, origin, _targetTile, false) != null;
		}}.isInRange;

		q.onTargetSelected = @(__original) { function onTargetSelected( _targetTile )
		{
			__original(_targetTile);
			::Brotherhood.previewLungeMove(this, _targetTile);
		}}.onTargetSelected;

		q.isUsable = @(__original) { function isUsable()
		{
			local suppressZoneOfControl = ::Brotherhood.beginPorcupineRangedEvaluation(this);
			local ret = __original();
			::Brotherhood.endPorcupineRangedEvaluation(suppressZoneOfControl);
			if (!ret || this.getContainer() == null) return ret;
			local disabled = this.getContainer().getSkillByID("effects.bh_disabled_off_hand");
			if (disabled == null || !disabled.isActiveNow()) return ret;
			local item = this.getItem();
			if (::MSU.isNull(item)) return ret;
			local actor = this.getContainer().getActor();
			local off = actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
			if (off != null && item.getInstanceID() == off.getInstanceID()) return false;
			if (item.isItemType(::Const.Items.ItemType.TwoHanded)) return false;
			return ret;
		}}.isUsable;
	});

	::Brotherhood.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
		q.isDoubleGrippingWeapon = @(__original) { function isDoubleGrippingWeapon()
		{
			local disabled = this.getSkills().getSkillByID("effects.bh_disabled_off_hand");
			if (disabled != null && disabled.isActiveNow()) return false;
			return __original();
		}}.isDoubleGrippingWeapon;

		q.onAppearanceChanged = @(__original) { function onAppearanceChanged( _appearance, _setDirty = true )
		{
			local result = __original(_appearance, _setDirty);
			local changed = ::Brotherhood.refreshVolleyOffhandAppearance(this, "appearance change");
			// Avoid portrait/UI feedback loops while a procedural bust is being baked.
			if (_setDirty && changed && ::Brotherhood.VolleyPortraitBakeDepth == 0) this.setDirty(true);

			return result;
		}}.onAppearanceChanged;

		q.resetRenderEffects = @(__original) { function resetRenderEffects()
		{
			local result = __original();
			::Brotherhood.refreshVolleyOffhandAppearance(this, "reset render effects");

			return result;
		}}.resetRenderEffects;

		q.onFactionChanged = @(__original) { function onFactionChanged()
		{
			local result = __original();
			::Brotherhood.refreshVolleyOffhandAppearance(this, "faction changed");

			return result;
		}}.onFactionChanged;

		q.MV_applyInjury = @(__original) { function MV_applyInjury( _skill, _hitInfo )
		{
			local source = _skill == null || _skill.getContainer() == null ? null : _skill.getContainer().getActor();
			local hasFleshcraftInjuryPerk = source != null && (
				source.getSkills().getSkillByID("perk.bh_ghost_pain") != null
				|| source.getSkills().getSkillByID("perk.bh_torture") != null
				|| source.getSkills().getSkillByID("perk.bh_shock") != null
				|| source.getSkills().getSkillByID("perk.bh_medieval_medicine") != null
			);
			if (!hasFleshcraftInjuryPerk)
			{
				local result = __original(_skill, _hitInfo);
				if (result != null) ::Brotherhood.refreshCrimsonActors();
				return result;
			}
			local injury = this.MV_selectInjury(_skill, _hitInfo);
			if (injury == null) return null;
			local secondary = source.getSkills().getSkillByID("perk.bh_torture") == null ? null : ::Brotherhood.selectTortureInjury(this, _skill, _hitInfo, injury);
			::Brotherhood.applyFleshcraftInjuryEvent(this, _skill, _hitInfo, injury);
			if (secondary != null && this.isAlive() && !this.isDying()) ::Brotherhood.applyFleshcraftInjuryEvent(this, _skill, _hitInfo, secondary);
			return source.getSkills().getSkillByID("perk.bh_medieval_medicine") == null ? injury : null;
		}}.MV_applyInjury;

		q.onDeath = @(__original) { function onDeath( _killer, _skill, _tile, _fatalityType )
		{
			::Brotherhood.recordStudentBaseXP(this);
			local result = __original(_killer, _skill, _tile, _fatalityType);
			::Brotherhood.refreshCrimsonActors();
			return result;
		}}.onDeath;

		q.onTurnStart = @(__original) { function onTurnStart()
		{
			::Brotherhood.removeShockFromSource(this.getID());
			return __original();
		}}.onTurnStart;

		q.setFaction = @(__original) { function setFaction( _faction )
		{
			local result = __original(_faction);
			::Brotherhood.refreshCrimsonActors();
			return result;
		}}.setFaction;

		q.onRemovedFromMap = @(__original) { function onRemovedFromMap()
		{
			local result = __original();
			::Brotherhood.refreshCrimsonActors();
			return result;
		}}.onRemovedFromMap;
	});

	::Brotherhood.HooksMod.hook("scripts/entity/tactical/player", function(q) {
		q.getImagePath = @(__original) { function getImagePath( _ignoreLayers = [] )
		{
			if (::Brotherhood.VolleyPortraitBakeDepth > 0) return __original(_ignoreLayers);

			// Campaign UI portraits request a procedural image without necessarily
			// firing onAppearanceChanged after the engine restores the shield offset.
			// Repair the live sprite immediately before that portrait is cached.
			local changed = ::Brotherhood.syncVolleyPortraitForBake(this);
			if (changed) this.setDirty(true);
			return __original(_ignoreLayers);
		}}.getImagePath;

		q.onDeserialize = @(__original) { function onDeserialize( _in )
		{
			__original(_in);
			::Brotherhood.clearLegacyVolleyPortraitActorFields(this);
			::Brotherhood.refreshVolleyOffhandAppearance(this, "load");
		}}.onDeserialize;

		q.onCombatStart = @(__original) { function onCombatStart()
		{
			__original();
			::Brotherhood.registerStudentDeployment(this);
		}}.onCombatStart;

		q.setAttributeLevelUpValues = @(__original) { function setAttributeLevelUpValues( _values )
		{
			::Brotherhood.recordFineBalanceSelection(this, _values);
			return __original(_values);
		}}.setAttributeLevelUpValues;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill_container", function(q) {
		q.remove = @(__original) { function remove( _skill )
		{
			local refresh = _skill != null && ((_skill.getType() & ::Const.SkillType.TemporaryInjury) != 0 || _skill.getID().find("effects.bh_ghost_injury_") == 0 || _skill.getID().find("effects.bh_ghost_injury.") == 0);
			local result = __original(_skill);
			if (refresh) ::Brotherhood.refreshCrimsonActors();
			return result;
		}}.remove;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.use = @(__original) { function use( _targetTile, _forFree = false )
		{
			local perk = ::Brotherhood.getLungePerk(this);
			if (perk == null || !perk.isAvailable() || _targetTile == null) return __original(_targetTile, _forFree);
			local actor = this.getContainer().getActor();
			local origin = actor.getTile();
			local normalRange = ::Brotherhood.getNormalWeaponSkillRangeToTarget(this, origin, _targetTile);
			local distance = origin.getDistanceTo(_targetTile);
			if (distance <= normalRange) return __original(_targetTile, _forFree);
			if (distance != normalRange + 1) return false;
			if (!_forFree && !this.isUsableOn(_targetTile, origin)) return false;
			if (_forFree && !this.isUsable()) return false;

			local move = ::Brotherhood.getLungeMove(this, origin, _targetTile, _forFree);
			if (move == null) return false;
			perk.spend();
			actor.setFatigue(actor.getFatigue() + move.Fatigue);
			actor.setDirty(true);
			this.getContainer().setBusy(true);
			actor.spawnTerrainDropdownEffect(origin);
			if (!::Brotherhood.processLungeLeaveZoneOfControlAttacks(actor, origin))
			{
				this.getContainer().setBusy(false);
				if (actor.isAlive() && !actor.isDying())
				{
					::Brotherhood.logFleshcraftMechanic("LUNGE", actor, "The lunge was interrupted; the weapon attack was not made.");
				}
				return true;
			}
			if (!actor.isAlive() || actor.isDying())
			{
				this.getContainer().setBusy(false);
				return true;
			}
			local tag = {
				Skill = this,
				Original = __original,
				TargetTile = _targetTile,
				ForFree = _forFree,
				OriginTile = origin,
				MovementFatigue = move.Fatigue,
				EnemyZOC = move.EnemyZOC,
				AdjacentEnemies = move.AdjacentEnemies,
				IsBadTerrain = move.IsBadTerrain,
				IsMarkedForImpact = move.IsMarkedForImpact
			};
			::Tactical.getNavigator().teleport(actor, move.Destination, ::Brotherhood.finishLungeMove, tag, false, 3.0);
			return true;
		}}.use;
	});

	// Observe successful skill dispatch after every other skill-use wrapper,
	// including Lunge. This records attention only for actions the engine accepted.
	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.MV_getDiversionTarget = @(__original) { function MV_getDiversionTarget( _user, _targetEntity, _propertiesForUse = null )
		{
			local perk = _user == null ? null : _user.getSkills().getSkillByID("perk.bh_juggling_mastery");
			if (perk != null && perk.valid(this) && perk.isSpear(this))
			{
				::Brotherhood.logFleshcraftMechanic("JUGGLING MASTERY", _user, "Locked a javelin attack to the clicked target " + (_targetEntity == null ? "none" : _targetEntity.getName()) + ".");
				return null;
			}
			return __original(_user, _targetEntity, _propertiesForUse);
		}}.MV_getDiversionTarget;

		q.MV_onAttackEntityMissed = @(__original) { function MV_onAttackEntityMissed( _attackInfo )
		{
			// A grazing spear connects with its intended target and must not scatter.
			// Resolve the stored graze only after Modular Vanilla finishes its normal
			// miss presentation so direct damage cannot interrupt the skill schedule.
			local user = _attackInfo == null ? null : _attackInfo.User;
			local perk = user == null ? null : user.getSkills().getSkillByID("perk.bh_juggling_mastery");
			if (perk != null && perk.valid(this) && perk.isSpear(this))
			{
				_attackInfo.AllowDiversion = false;
				::Brotherhood.logFleshcraftMechanic("JUGGLING MASTERY", user, "Suppressed projectile diversion for a javelin graze.");
			}
			local ret = __original(_attackInfo);
			if (perk != null) perk.schedulePendingGraze();
			return ret;
		}}.MV_onAttackEntityMissed;

		q.use = @(__original) { function use( _targetTile, _forFree = false )
		{
			local target = _targetTile != null && _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
			local attacker = this.getContainer() == null ? null : this.getContainer().getActor();
			local isTargeted = this.isTargeted();
			local targetName = target == null ? "unknown target" : target.getName();
			local targetWasPlayerAllied = target != null && target.isAlliedWithPlayer();
			local attackerWasPlayerAllied = attacker != null && attacker.isAlliedWithPlayer();
			local ret = __original(_targetTile, _forFree);
			// Consumable attacks may destroy their skill during __original (for example,
			// a thrown javelin using its last charge), so never touch `this` afterwards.
			if (ret) ::Brotherhood.applyDistractedObservers(attacker, targetName, targetWasPlayerAllied, attackerWasPlayerAllied, isTargeted);
			return ret;
		}}.use;
	});

	::Brotherhood.HooksMod.hook("scripts/items/item_container", function(q) {
		q.hasBlockedSlot = @(__original) function( _slotType )
		{
			if (_slotType == ::Const.ItemSlot.Offhand
				&& ::Brotherhood.hasSnappingTurtle(this.getActor())
				&& ::Brotherhood.isSnappingTurtleTwoHandedWeapon(this.getItemAtSlot(::Const.ItemSlot.Mainhand)))
				return false;
			return __original(_slotType);
		}

		q.unequip = @(__original) { function unequip( _item )
		{
			local actor = this.getActor();
			if (actor != null && _item != null && _item != -1 && _item.getCurrentSlotType() == ::Const.ItemSlot.Mainhand)
			{
				local bloodloaded = actor.getSkills().getSkillByID("perk.bh_bloodloaded");
				if (bloodloaded != null) bloodloaded.remember(_item);
			}
			// Throw skills unequip Offhand by hardcode. Spend the skill's bound
			// tool instead so a mainhand dual-wield tool is charged correctly.
			if (::Brotherhood.SpendingCombatToolChargeDepth > 0)
			{
				local spend = ::Brotherhood.PendingCombatToolSpendItem;
				if (spend == null) spend = _item;
				if (::Brotherhood.trySpendCombatToolCharge(spend)) return false;
			}
			return __original(_item);
		}}.unequip;

		q.equip = @(__original) { function equip( _item )
		{
			local actor = this.getActor();
			if (actor != null)
			{
				local bloodloaded = actor.getSkills().getSkillByID("perk.bh_bloodloaded");
				local current = this.getItemAtSlot(::Const.ItemSlot.Mainhand);
				if (bloodloaded != null && current != null && current != _item) bloodloaded.remember(current);
				local volleySlot = _item != null && "BH_VolleyRequestedSlot" in _item.m ? _item.m.BH_VolleyRequestedSlot : null;
				local toolSlot = _item != null && "BH_ConsumableRequestedSlot" in _item.m ? _item.m.BH_ConsumableRequestedSlot : null;
				::Brotherhood.configureVolleyWeaponSlot(_item, actor, volleySlot);
				::Brotherhood.configureConsumableToolSlot(_item, actor, toolSlot);
				::Brotherhood.prepareSnappingTurtleEquip(this, actor, _item);
			}
			if (_item != null) ::Brotherhood.applyCombatToolAmmoTrack(_item);
			local result = __original(_item);
			if (_item != null && "BH_VolleyRequestedSlot" in _item.m) delete _item.m.BH_VolleyRequestedSlot;
			if (_item != null && "BH_ConsumableRequestedSlot" in _item.m) delete _item.m.BH_ConsumableRequestedSlot;
			if (result && actor != null)
			{
				::Brotherhood.refreshSnappingTurtleLoadout(actor, _item == null ? "equip" : "equip " + _item.getName());
				local preparation = actor.getSkills().getSkillByID("perk.bh_preparation");
				if (preparation != null) preparation.refreshAfterEquip();
			}
			return result;
		}}.equip;
	});

	foreach (toolScript in ::Brotherhood.CombatToolItemScripts)
	{
		::Brotherhood.HooksMod.hook(toolScript, function(q) {
			q.create = @(__original) { function create()
			{
				__original();
				::Brotherhood.applyCombatToolAmmoTrack(this);
			}}.create;
			q.onDeserialize = @(__original) { function onDeserialize( _in )
			{
				__original(_in);
				::Brotherhood.applyCombatToolAmmoTrack(this);
			}}.onDeserialize;
			q.isAmountShown = @(__original) { function isAmountShown()
			{
				return this.m.AmmoMax > 0;
			}}.isAmountShown;
			q.getAmountString = @(__original) { function getAmountString()
			{
				return this.m.Ammo + "/" + this.m.AmmoMax;
			}}.getAmountString;
			q.getTooltip = @(__original) { function getTooltip()
			{
				return ::Brotherhood.replaceDestroyedOnUseTooltip(__original());
			}}.getTooltip;
		});
	}

	foreach (skillScript in ::Brotherhood.CombatToolThrowSkillScripts)
	{
		::Brotherhood.HooksMod.hook(skillScript, function(q) {
			q.isUsable = @(__original) { function isUsable()
			{
				if (!__original()) return false;
				local item = null;
				try { item = this.getItem(); }
				catch (error) { item = null; }
				if (::Brotherhood.isCombatToolConsumable(item) && item.getAmmo() <= 0) return false;
				return true;
			}}.isUsable;
			q.getTooltip = @(__original) { function getTooltip()
			{
				local ret = __original();
				local item = null;
				try { item = this.getItem(); }
				catch (error) { item = null; }
				if (::Brotherhood.isCombatToolConsumable(item) && item.getAmmoMax() > 0)
				{
					local ammo = item.getAmmo();
					ret.push({
						id = 8,
						type = "text",
						icon = ammo > 0 ? "ui/icons/ammo.png" : "ui/tooltips/warning.png",
						text = ::Brotherhood.getCombatToolAmmoLeftText(item, ammo)
					});
				}
				return ret;
			}}.getTooltip;
			q.onUse = @(__original) { function onUse( _user, _targetTile )
			{
				local bound = null;
				try { bound = this.getItem(); }
				catch (error) { bound = null; }
				::Brotherhood.PendingCombatToolSpendItem = bound;
				::Brotherhood.SpendingCombatToolChargeDepth += 1;
				local ret = __original(_user, _targetTile);
				::Brotherhood.SpendingCombatToolChargeDepth = ::Math.max(0, ::Brotherhood.SpendingCombatToolChargeDepth - 1);
				::Brotherhood.PendingCombatToolSpendItem = null;
				return ret;
			}}.onUse;
		});
	}
	// Character-screen helpers decide which equipped slot will be replaced before
	// item_container.equip runs, so configure Volley before that decision too.
	::Brotherhood.HooksMod.hook("scripts/ui/screens/character/character_screen", function(q) {
		q.helper_queryEquipmentTargetItems = @(__original) function( _inventory, _sourceItem )
		{
			local actor = _inventory == null ? null : _inventory.getActor();
			if (::Brotherhood.hasSnappingTurtle(actor) && ::Brotherhood.isSnappingTurtleTwoHandedWeapon(_sourceItem))
				::Brotherhood.configureSnappingTurtleWeapon(_sourceItem, actor);

			local ret = __original(_inventory, _sourceItem);

			if (::Brotherhood.hasSnappingTurtle(actor) && ::Brotherhood.isSnappingTurtleTwoHandedWeapon(_sourceItem))
			{
				local shield = _inventory.getItemAtSlot(::Const.ItemSlot.Offhand);
				if (shield != null && shield.isItemType(::Const.Items.ItemType.Shield))
				{
					ret.secondItem = null;
					ret.firstItem = _inventory.getItemAtSlot(::Const.ItemSlot.Mainhand);
					ret.slotsNeeded = ret.firstItem != null ? 1 : 0;
				}
			}

			return ret;
		}

		q.general_onEquipStashItem = @(__original) { function general_onEquipStashItem( _data )
		{
			local data = this.helper_queryStashItemData(_data);
			local preferred = _data.len() > 3 ? _data[3] : null;
			if (preferred == "mainhand") preferred = ::Const.ItemSlot.Mainhand;
			else if (preferred == "offhand") preferred = ::Const.ItemSlot.Offhand;
			if (!("error" in data)) ::logInfo("[Brotherhood][STASH TO HAND] " + data.sourceItem.getName() + " requested=" + (preferred == null ? "native" : preferred.tostring()) + ".");
			if (!("error" in data)) ::Brotherhood.configureVolleyWeaponSlot(data.sourceItem, data.entity, preferred);
			if (!("error" in data)) ::Brotherhood.configureConsumableToolSlot(data.sourceItem, data.entity, preferred);
			if (!("error" in data)) ::Brotherhood.prepareSnappingTurtleEquip(data.inventory, data.entity, data.sourceItem);
			if (!("error" in data)
				&& ::Brotherhood.hasSnappingTurtle(data.entity)
				&& ::Brotherhood.isSnappingTurtleTwoHandedWeapon(data.sourceItem)
				)
			{
				::logInfo("[Brotherhood][STASH TO HAND] Routing Snapping Turtle two-hander through direct main-hand placement.");
				return this.onBrotherhoodEquipSnappingTurtleStashItem(data);
			}
			local result = __original(_data);
			if (!("error" in data)) ::logInfo("[Brotherhood][STASH TO HAND] Result type=" + typeof result + "; final current=" + data.sourceItem.getCurrentSlotType() + ".");
			if (!("error" in data) && "BH_VolleyRequestedSlot" in data.sourceItem.m) delete data.sourceItem.m.BH_VolleyRequestedSlot;
			if (!("error" in data) && "BH_ConsumableRequestedSlot" in data.sourceItem.m) delete data.sourceItem.m.BH_ConsumableRequestedSlot;
			return result;
		}}.general_onEquipStashItem;

		q.general_onEquipBagItem = @(__original) { function general_onEquipBagItem( _data )
		{
			local data = this.helper_queryEntityItemData(_data);
			local preferred = _data.len() > 3 ? _data[3] : null;
			if (!("error" in data))
			{
				if (::Brotherhood.hasSnappingTurtle(data.entity)
					&& ::Brotherhood.isSnappingTurtleTwoHandedWeapon(data.sourceItem)
					)
				{
					::logInfo("[Brotherhood][NATIVE BAG EQUIP] Routing Snapping Turtle two-hander through the shield-preserving transaction.");
					return this.onBrotherhoodMoveBagItemToHand([_data[0], _data[1], data.targetItemIdx, ::Const.ItemSlot.Mainhand]);
				}
				if (preferred == null && ::Brotherhood.isFleshcraftThrowingWeapon(data.sourceItem) && data.entity.getSkills().hasSkill("perk.bh_volley_mastery"))
				{
					local main = data.inventory.getItemAtSlot(::Const.ItemSlot.Mainhand);
					local off = data.inventory.getItemAtSlot(::Const.ItemSlot.Offhand);
					if (main != null && off == null)
					{
						preferred = ::Const.ItemSlot.Offhand;
						::logInfo("[Brotherhood][NATIVE BAG EQUIP] Inferred the empty offhand for the second Volley throwing weapon.");
					}
				}
				if (preferred == null && ::Brotherhood.isCombatToolConsumable(data.sourceItem) && ::Brotherhood.hasConsumableMastery(data.entity))
				{
					local main = data.inventory.getItemAtSlot(::Const.ItemSlot.Mainhand);
					local off = data.inventory.getItemAtSlot(::Const.ItemSlot.Offhand);
					// Tools default to offhand; with offhand already holding a tool,
					// route the second into the empty mainhand.
					if (off != null && ::Brotherhood.isCombatToolConsumable(off) && main == null)
					{
						preferred = ::Const.ItemSlot.Mainhand;
						::logInfo("[Brotherhood][NATIVE BAG EQUIP] Inferred the empty mainhand for the second Consumable Mastery tool.");
					}
					else if (main != null && ::Brotherhood.isCombatToolConsumable(main) && off == null)
					{
						preferred = ::Const.ItemSlot.Offhand;
						::logInfo("[Brotherhood][NATIVE BAG EQUIP] Inferred the empty offhand for the second Consumable Mastery tool.");
					}
				}
				::logInfo("[Brotherhood][NATIVE BAG EQUIP] " + data.sourceItem.getName() + " preferred=" + (preferred == null ? "null" : preferred.tostring()) + " native=" + data.sourceItem.getSlotType() + " current=" + data.sourceItem.getCurrentSlotType() + " throwing=" + ::Brotherhood.isFleshcraftThrowingWeapon(data.sourceItem) + " volley=" + data.entity.getSkills().hasSkill("perk.bh_volley_mastery") + ".");
				::Brotherhood.configureVolleyWeaponSlot(data.sourceItem, data.entity, preferred);
				::Brotherhood.configureConsumableToolSlot(data.sourceItem, data.entity, preferred);
				::Brotherhood.prepareSnappingTurtleEquip(data.inventory, data.entity, data.sourceItem);
			}
			local result = __original(_data);
			if (!("error" in data)) ::logInfo("[Brotherhood][NATIVE BAG EQUIP] Result type=" + typeof result + "; final current=" + data.sourceItem.getCurrentSlotType() + ".");
			if (!("error" in data) && "BH_VolleyRequestedSlot" in data.sourceItem.m) delete data.sourceItem.m.BH_VolleyRequestedSlot;
			if (!("error" in data) && "BH_ConsumableRequestedSlot" in data.sourceItem.m) delete data.sourceItem.m.BH_ConsumableRequestedSlot;
			return result;
		}}.general_onEquipBagItem;
	});

	::Brotherhood.HooksMod.hookTree("scripts/items/item", function(q) {
		q.getBlockedSlotType = @(__original) { function getBlockedSlotType()
		{
			if ("BH_SnappingTurtleAllowed" in this.m && this.m.BH_SnappingTurtleAllowed
				&& ::Brotherhood.isSnappingTurtleTwoHandedWeapon(this)) return null;
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (::Brotherhood.hasSnappingTurtle(actor) && ::Brotherhood.isSnappingTurtleTwoHandedWeapon(this)) return null;
			return __original();
		}}.getBlockedSlotType;
	});

	::Brotherhood.HooksMod.hookTree("scripts/items/weapons/weapon", function(q) {
		q.updateAppearance = @(__original) { function updateAppearance()
		{
			__original();
			if (!this.isEquipped() || this.getContainer() == null) return;
			local actor = this.getContainer().getActor();
			if (!::Brotherhood.hasSnappingTurtle(actor) || !::Brotherhood.isSnappingTurtleTwoHandedWeapon(this)) return;
			if (this.getCurrentSlotType() != ::Const.ItemSlot.Mainhand) return;
			local off = actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
			if (off == null || !off.isItemType(::Const.Items.ItemType.Shield)) return;
			this.getContainer().getAppearance().TwoHanded = true;
			this.getContainer().updateAppearance();
		}}.updateAppearance;

		q.addSkill = @(__original) { function addSkill( _skill )
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null && this.getCurrentSlotType() == ::Const.ItemSlot.Offhand && actor.getSkills().hasSkill("perk.bh_volley_mastery")
				&& ::Brotherhood.isFleshcraftThrowingWeapon(this) && _skill != null && _skill.isAttack() && _skill.isRanged())
			{
				_skill.m.ID = _skill.getID() + ".bh_volley_offhand";
			}
			// Tools are natively Offhand. Mainhand dual-wield clones need a unique
			// ID so both throw actions appear (same collision Volley hit for throwing).
			if (actor != null && this.getCurrentSlotType() == ::Const.ItemSlot.Mainhand
				&& ::Brotherhood.hasConsumableMastery(actor)
				&& ::Brotherhood.isCombatToolConsumable(this) && _skill != null)
			{
				local id = _skill.getID();
				if (id.find(".bh_consumable_mainhand") == null)
					_skill.m.ID = id + ".bh_consumable_mainhand";
			}
			return __original(_skill);
		}}.addSkill;
		q.onPutIntoBag = @(__original) { function onPutIntoBag()
		{
			local result = __original();
			::Brotherhood.resetVolleyWeaponForBag(this);
			::Brotherhood.resetConsumableToolForBag(this);
			return result;
		}}.onPutIntoBag;
		q.getSlotType = @(__original) { function getSlotType()
		{
			local current = this.getCurrentSlotType();
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null && actor.getSkills().hasSkill("perk.bh_volley_mastery") && ::Brotherhood.isFleshcraftThrowingWeapon(this)
				&& (current == ::Const.ItemSlot.Mainhand || current == ::Const.ItemSlot.Offhand)) return current;
			if (actor != null && ::Brotherhood.hasConsumableMastery(actor) && ::Brotherhood.isCombatToolConsumable(this)
				&& (current == ::Const.ItemSlot.Mainhand || current == ::Const.ItemSlot.Offhand)) return current;
			return __original();
		}}.getSlotType;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/global/data_helper", function(q) {
		q.convertItemToUIData = @(__original) { function convertItemToUIData( _item, _forceSmallIcon, _owner = null )
		{
			local ret = __original(_item, _forceSmallIcon, _owner);
			if (ret != null) ret.bhVolleyThrowing <- ::Brotherhood.isFleshcraftThrowingWeapon(_item);
			return ret;
		}}.convertItemToUIData;
	});


	::Brotherhood.HooksMod.hook("scripts/states/tactical_state", function(q) {
		q.onBattleEnded = @(__original) { function onBattleEnded()
		{
			local result = __original();
			::Brotherhood.finishStudentBattle();
			return result;
		}}.onBattleEnded;

		q.setActionStateBySkill = @(__original) { function setActionStateBySkill( _activeEntity, _skill )
		{
			::Brotherhood.applyLungeWeaponSkillRange(_skill);
			return __original(_activeEntity, _skill);
		}}.setActionStateBySkill;
	});

	::Brotherhood.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
		q.checkMorale = @(__original) { function checkMorale( _change, _difficulty, _type = ::Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
		{
			local ret = __original(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
			if (ret && _change < 0)
			{
				local determination = this.getSkills().getSkillByID("perk.bh_determination");
				if (determination != null) determination.onMoraleEffect(_type, true);
			}
			return ret;
		}}.checkMorale;
	});

	::Brotherhood.HooksMod.hookTree("scripts/skills/skill", function(q) {
		q.getActionPointCost = @(__original) { function getActionPointCost()
		{
			local cost = __original();
			if (this.getContainer() == null) return cost;
			local actor = this.getContainer().getActor();
			if (actor != null && this.isAttack() && actor.getSkills().hasSkill("effects.bh_ragnarok")) return 3;
			if (::Brotherhood.isConsumableMasterySkill(this) && this.m.ActionPointCost > 0)
				return ::Math.max(1, cost - 1);
			return cost;
		}}.getActionPointCost;
		q.getFatigueCost = @(__original) { function getFatigueCost()
		{
			local cost = __original();
			if (this.getContainer() == null) return cost;
			local actor = this.getContainer().getActor();
			if (actor != null && actor.getSkills().hasSkill("effects.bh_ragnarok") && this.isAttack()) return cost * 2;
			if (::Brotherhood.isConsumableMasterySkill(this) && this.m.FatigueCost > 0)
				return ::Math.max(0, ::Math.round(cost * 0.75));
			return cost;
		}}.getFatigueCost;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.use = @(__original) { function use( _targetTile, _forFree = false )
		{
			local attacker = this.getContainer() == null ? null : this.getContainer().getActor();
			local target = _targetTile != null && _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;
			// Snapshot before the attack resolves; a killing blow leaves the target dying and
			// would otherwise skip Sentinel entirely via canCompareActorAlliance.
			local sentinels = this.isAttack() ? ::Brotherhood.collectSentinelCountersForAttack(attacker, target) : [];
			local ret = __original(_targetTile, _forFree);
			if (ret && sentinels.len() > 0 && ::Brotherhood.canCompareActorAlliance(attacker))
			{
				foreach (sentinel in sentinels)
					sentinel.tryCounter(attacker, target);
			}
			return ret;
		}}.use;
	});
}
