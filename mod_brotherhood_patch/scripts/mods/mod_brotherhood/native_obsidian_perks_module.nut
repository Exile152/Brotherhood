if (!("Brotherhood" in getroottable())) return;

::Brotherhood.NativeObsidianPerks <- [
	{ ID="perk.colossus", Script="scripts/skills/perks/perk_colossus" },
	{ ID="perk.nine_lives", Script="scripts/skills/perks/perk_nine_lives" },
	{ ID="perk.pathfinder", Script="scripts/skills/perks/perk_pathfinder" },
	{ ID="perk.bags_and_belts", Script="scripts/skills/perks/perk_bags_and_belts" },
	{ ID="perk.fortified_mind", Script="scripts/skills/perks/perk_fortified_mind" },
	{ ID="perk.steel_brow", Script="scripts/skills/perks/perk_steel_brow" },
	{ ID="perk.brawny", Script="scripts/skills/perks/perk_brawny" },
	{ ID="perk.dodge", Script="scripts/skills/perks/perk_dodge" },
	{ ID="perk.berserk", Script="scripts/skills/perks/perk_berserk" },
	{ ID="perk.head_hunter", Script="scripts/skills/perks/perk_head_hunter" },
	{ ID="perk.killing_frenzy", Script="scripts/skills/perks/perk_killing_frenzy" },
	// Pulled in by the Attack Banner, Tank Banner and Tank parents. The vanilla
	// mechanics are unchanged; only the tooltip becomes the authored Obsidian card.
	{ ID="perk.rally_the_troops", Script="scripts/skills/perks/perk_rally_the_troops" },
	{ ID="perk.rotation", Script="scripts/skills/perks/perk_rotation" },
	{ ID="perk.taunt", Script="scripts/skills/perks/perk_taunt" },
	{ ID="perk.indomitable", Script="scripts/skills/perks/perk_indomitable" }
];

// Perks whose Obsidian card describes an unlocked active skill rather than a
// passive bonus. Their cards are rendered with the Active effect type.
::Brotherhood.NativeObsidianActivePerks <- {
	"perk.rally_the_troops": true,
	"perk.rotation": true,
	"perk.taunt": true,
	"perk.indomitable": true
};

::Brotherhood.getNativeObsidianTooltip <- function( _id )
{
	local data = {
		"perk.colossus": ["Bring it on!", ["Maximum [Hitpoints|Concept.Hitpoints] are increased by " + ::MSU.Text.colorPositive("25%") + ".", "The additional [Hitpoints|Concept.Hitpoints] also make injuries less likely by raising injury thresholds."]],
		"perk.nine_lives": ["Death gets one chance. You get another.", ["Once per battle, survive a killing blow with " + ::MSU.Text.colorPositive("11 to 15") + " [Hitpoints|Concept.Hitpoints].", "Remove damage-over-time effects when Nine Lives triggers.", "Gain " + ::MSU.Text.colorPositive("+15") + " [Melee Defense|Concept.MeleeDefense], [Ranged Defense|Concept.RangeDefense], [Resolve|Concept.Bravery], and [Initiative|Concept.Initiative] until your next turn."]],
		"perk.pathfinder": ["Learn to move on difficult terrain.", ["[Action Point|Concept.ActionPoints] costs for movement on all terrain are reduced by " + ::MSU.Text.colorPositive("1") + ", to a minimum of " + ::MSU.Text.colorPositive("2") + " [Action Points|Concept.ActionPoints], and [Fatigue|Concept.Fatigue] costs are reduced by half.", "Changing height levels also has no additional [Action Point|Concept.ActionPoints] cost anymore."]],
		"perk.bags_and_belts": ["Extra pockets.", ["Unlocks two extra bag slots to carry all your favorite things.", "Non-two-handed items placed in bags no longer give a penalty to [Maximum Fatigue|Concept.MaximumFatigue]."]],
		"perk.fortified_mind": ["An iron will is not swayed from the true path easily.", ["[Resolve|Concept.Bravery] is increased by " + ::MSU.Text.colorPositive("25%") + "."]],
		"perk.steel_brow": ["Protect your head.", ["Hits to the head no longer cause critical hits."]],
		"perk.brawny": ["Shake those muscles.", ["The [Fatigue|Concept.Fatigue] penalty from wearing armor and a helmet is reduced by " + ::MSU.Text.colorPositive("30%") + "."]],
		"perk.dodge": ["Too fast for you!", ["Gain " + ::MSU.Text.colorPositive("15%") + " of your current [Initiative|Concept.Initiative] as a bonus to Melee and Ranged Defense."]],
		"perk.berserk": ["RAARGH!", ["Once per turn, upon killing an enemy, " + ::MSU.Text.colorPositive("4") + " [Action Points|Concept.ActionPoints] are immediately regained.", "You can gain only " + ::MSU.Text.colorPositive("4") + " [Action Points|Concept.ActionPoints] per attack."]],
		"perk.head_hunter": ["Go for the head!", ["Hitting the head of a target will give you a guaranteed hit to the head with your next attack."]],
		"perk.killing_frenzy": ["Go into a killing frenzy!", ["A kill increases all damage by " + ::MSU.Text.colorPositive("25%") + " for " + ::MSU.Text.colorPositive("2") + " turns.", "Does not stack, but another kill will reset the timer."]],
		"perk.rally_the_troops": ["Call the company back from the edge.", ["Unlocks Rally the Troops, which attempts to raise the [morale|Concept.Morale] of nearby wavering or fleeing allies.", "Success improves with the user's [Resolve|Concept.Bravery] and worsens with distance.", "Costs " + ::MSU.Text.colorPositive("5") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("25") + " [Fatigue|Concept.Fatigue]."]],
		"perk.rotation": ["Trade places before the line breaks.", ["Unlocks Rotation, allowing you to exchange places with an adjacent ally while ignoring [Zones of Control|Concept.ZoneOfControl].", "Rotation cannot be used if either character is stunned, rooted, or otherwise unable to move.", "Costs " + ::MSU.Text.colorPositive("3") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue]."]],
		"perk.taunt": ["Hey!", ["Unlocks Taunt, compelling an enemy within " + ::MSU.Text.colorPositive("3") + " tiles to favor offensive actions and attack the user when it can reach them.", "Costs " + ::MSU.Text.colorPositive("4") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("15") + " [Fatigue|Concept.Fatigue]."]],
		"perk.indomitable": ["You shall not fall!", ["Unlocks Indomitable, reducing damage received by " + ::MSU.Text.colorPositive("50%") + " for one turn.", "While active, become immune to being stunned, knocked back, or grabbed.", "Costs " + ::MSU.Text.colorPositive("5") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("25") + " [Fatigue|Concept.Fatigue]."]]
	};
	local d = data[_id];
	local type = _id in ::Brotherhood.NativeObsidianActivePerks ? ::UPD.EffectType.Active : ::UPD.EffectType.Passive;
	return ::Brotherhood.formatSurvivalPerkTooltip({ Fluff=d[0], Effects=[{ Type=type, Description=d[1] }] });
}

::Brotherhood.initializeNativeObsidianPerks <- function()
{
	foreach (definition in ::Brotherhood.NativeObsidianPerks)
	{
		local perk = ::Const.Perks.findById(definition.ID);
		if (perk == null) throw "Brotherhood active native perk is missing: " + definition.ID;
		perk.Tooltip = ::Brotherhood.getNativeObsidianTooltip(definition.ID);
		::Brotherhood.HooksMod.hook(definition.Script, function(q) {
			q.create = @(__original) { function create()
			{
				__original();
				this.m.Description = ::Brotherhood.getNativeObsidianTooltip(this.m.ID);
			}}.create;
		});
	}
}
