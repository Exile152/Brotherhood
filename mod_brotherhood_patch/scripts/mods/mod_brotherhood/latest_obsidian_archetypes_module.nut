if (!("Brotherhood" in getroottable())) return;

::Brotherhood.logLatestObsidianTest <- function( _tag, _actor, _message )
{
	::Brotherhood.logActivePerkMechanic(_tag, _actor, _message);
}

::Brotherhood.getLatestObsidianTooltip <- function( _id )
{
	local data = {
		"perk.bh_ambition": ["I can become anything!", ["Gain " + ::MSU.Text.colorPositive("+1") + " in every attribute without a talent star.", "After that, each of those attributes gains one talent star."]],
		"perk.bh_small_head": ["Accustomed to hitting apples and melons, you can hit heads too.", [::MSU.Text.colorPositive("+10%") + " chance to hit the head."]],
		"perk.bh_big_bones": ["Yes, momma always told me I had those.", ["Whenever you would become Stunned, become Dazed instead."]],
		"perk.bh_birthright": ["You are the result of years of careful reproduction, allegedly.", ["The numerical positive and negative effects of your traits are doubled."]],
		"perk.bh_breach": ["Destroy their defenses.", ["Hitting an enemy ends active effects granted by their equipped weapon or shield, such as Shieldwall."]],
		"perk.bh_hope": ["It burns brightest in the darkest night.", ["Gain " + ::MSU.Text.colorPositive("+15") + " [Resolve|Concept.Bravery] for each morale level below Steady up to Wavering."]],
		"perk.bh_shatter": ["Destroy their bodies.", ["Deal " + ::MSU.Text.colorPositive("+10%") + " damage on hits to the head."]],
		"perk.bh_unmovable": ["No. Not happening.", ["You cannot be knocked back, pulled, forcibly repositioned, or swapped by enemies."]],
		"perk.bh_forsworn": ["Their problem is not mine.", ["While no ally is within " + ::MSU.Text.colorPositive("3") + " tiles, ally deaths and fleeing allies do not trigger negative morale checks for you."]],
		"perk.bh_steady_hands": ["They do not tremble.", ["You can use ranged attacks while an enemy is adjacent to you."]],
		"perk.bh_resilient": ["Keep it together!", ["Negative status effects with a finite duration are reduced to " + ::MSU.Text.colorPositive("1") + " turn.", "Status effects that weaken over time begin at their weakest state.", "The numerical penalties from injuries are halved."]],
		"perk.bh_virtuous": ["Appointed by God.", ["Gain another trait with at least one numerical positive bonus."]],
		"perk.bh_big_game_hunter": ["The hunt is on!", ["Ranged attacks gain damage as the target's maximum Hitpoints exceed yours, reaching " + ::MSU.Text.colorPositive("+20%") + " at double and capping at " + ::MSU.Text.colorPositive("+25%") + "."]],
		"perk.bh_arrogance": ["You are simply of a different lot.", ["While Confident, the attribute bonuses from your morale state are doubled."]],
		"perk.bh_despair": ["They will not flee!", ["Deal " + ::MSU.Text.colorPositive("+50%") + " damage to fleeing enemies.", "Killing a fleeing enemy grants a stacking " + ::MSU.Text.colorPositive("+2") + " Melee Skill and Resolve for the remainder of combat."]],
		"perk.bh_veteran": ["I know a lot of stuff, kid.", ["The first weapon skill used each round costs " + ::MSU.Text.colorPositive("1") + " fewer [Action Points|Concept.ActionPoints]."]],
		"perk.bh_scholarship": ["An expensive education produces results when you make it worth it.", ["Gain the Bright trait.", "Gain one talent star in a random attribute that has fewer than three stars."]],
		"perk.bh_poach": ["Is what needs to be done.", ["After a ranged attack hits the head, automatically repeat that attack against the same target without paying Action Points; it still builds Fatigue.", "A crossbow reloads instead of repeating the attack."]],
		"perk.bh_bloodletting": ["Your pain shall be mine.", ["Unlocks Bloodletting, which transfers the most recent temporary injury from an adjacent ally to you.", "The first Bloodletting used on each ally per battle also restores " + ::MSU.Text.colorPositive("30%") + " of their maximum Hitpoints.", "Costs " + ::MSU.Text.colorNegative("4") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue]."]],
		"perk.bh_dragonet": ["You. Should duck.", ["After an enemy misses an attack against you, reload your handgonne.", "If the handgonne is already loaded, fire it at that enemy instead."]],
		"perk.bh_learning_devil": ["Is what they are calling me.", ["Whenever you gain a level, a random attribute is permanently increased by " + ::MSU.Text.colorPositive("+2") + ".", "There is a " + ::MSU.Text.colorNegative("10%") + " chance for that attribute to be permanently reduced by " + ::MSU.Text.colorNegative("-2") + " instead.", "This effect applies only when gaining levels up to and including Level " + ::MSU.Text.colorPositive("11") + "."]],
		"perk.bh_flail_mastery": ["Master flails and circumvent your opponent's shield.", ["Flail skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Lash and Hail ignore the defense bonus of shields.", "Pound ignores an additional " + ::MSU.Text.colorPositive("15%") + " of armor on head hits.", "Thresh gains " + ::MSU.Text.colorPositive("+5%") + " chance to hit."]],
		"perk.bh_polearm_mastery": ["Master polearms and hitting from behind the cover of your allies.", ["Polearm skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Polearm skills have their [Action Point|Concept.ActionPoints] cost reduced to " + ::MSU.Text.colorPositive("5") + ", and no longer have a penalty for attacking targets directly adjacent."]],
		"perk.bh_shield_mastery": ["Learn to better deflect hits to the side instead of blocking them head on.", ["The shield defense bonus is increased by " + ::MSU.Text.colorPositive("25%") + ".", "Shield damage is reduced by " + ::MSU.Text.colorPositive("50%") + " to a minimum of " + ::MSU.Text.colorPositive("1") + ".", "Knock Back gains " + ::MSU.Text.colorPositive("+15%") + " chance to hit."]],
		"perk.bh_spear_mastery": ["Master fighting with spears and keeping your enemies at bay.", ["Spear skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Spearwall is no longer disabled once an opponent manages to overcome it.", "The Spetum and Warfork no longer have a penalty for attacking targets directly adjacent."]]
	};
	if (!(_id in data)) return "";
	return ::Reforged.Mod.Tooltips.parseString(::UPD.getDescription({
		Fluff = data[_id][0],
		Effects = [{ Type = _id == "perk.bh_bloodletting" ? ::UPD.EffectType.Active : ::UPD.EffectType.Passive, Description = data[_id][1] }]
	}));
}

::Brotherhood.captureNumericProperties <- function( _properties )
{
	local ret = {};
	foreach (key, value in _properties)
	{
		local kind = typeof value;
		if (kind == "integer" || kind == "float") ret[key] <- value;
		else if (kind == "array") ret[key] <- clone value;
	}
	return ret;
}

::Brotherhood.repeatNumericPropertyDeltas <- function( _properties, _before, _negativeOnly = false, _scale = 1.0 )
{
	local changed = 0;
	foreach (key, oldValue in _before)
	{
		if (!(key in _properties)) continue;
		local value = _properties[key];
		local kind = typeof oldValue;
		if (kind == "integer" || kind == "float")
		{
			local delta = value - oldValue;
			if (delta != 0 && (!_negativeOnly || delta < 0))
			{
				_properties[key] = value + delta * _scale;
				++changed;
			}
		}
		else if (kind == "array" && typeof value == "array")
		{
			for (local i = 0; i < oldValue.len() && i < value.len(); ++i)
			{
				if ((typeof oldValue[i] != "integer" && typeof oldValue[i] != "float") || (typeof value[i] != "integer" && typeof value[i] != "float")) continue;
				local delta = value[i] - oldValue[i];
				if (delta != 0 && (!_negativeOnly || delta < 0))
				{
					value[i] += delta * _scale;
					++changed;
				}
			}
		}
	}
	return changed;
}

::Brotherhood.hasNearbyAlly <- function( _actor, _distance )
{
	if (_actor == null || !::Tactical.isActive()) return false;
	foreach (other in ::Tactical.Entities.getAllInstancesAsArray())
	{
		if (other == null || other.getID() == _actor.getID() || !other.isAlive() || !other.isAlliedWith(_actor)) continue;
		if (other.getTile().getDistanceTo(_actor.getTile()) <= _distance) return true;
	}
	return false;
}

::Brotherhood.registerLatestObsidianPerks <- function()
{
	local defs = [
		["perk.bh_ambition","Ambition","perk.gifted"],
		["perk.bh_small_head","Small Head","perk.head_hunter"], ["perk.bh_big_bones","Big Bones","perk.steel_brow"], ["perk.bh_birthright","Birthright","perk.gifted"],
		["perk.bh_breach","Breach","perk.shield_expert"], ["perk.bh_hope","Hope","perk.fortified_mind"], ["perk.bh_shatter","Shatter","perk.head_hunter"],
		["perk.bh_unmovable","Unmovable","perk.steel_brow"], ["perk.bh_forsworn","Forsworn","perk.lone_wolf"], ["perk.bh_steady_hands","Steady Hands","perk.bullseye"],
		["perk.bh_resilient","Resilient","perk.hold_out"], ["perk.bh_virtuous","Virtuous","perk.gifted"], ["perk.bh_big_game_hunter","Big Game Hunter","perk.head_hunter"],
		["perk.bh_arrogance","Arrogance","perk.lone_wolf"], ["perk.bh_despair","Despair","perk.fearsome"], ["perk.bh_veteran","Veteran","perk.student"],
		["perk.bh_scholarship","Scholarship","perk.student"], ["perk.bh_poach","Poach","perk.head_hunter"], ["perk.bh_bloodletting","Bloodletting","perk.hold_out"],
		["perk.bh_dragonet","Dragonet","perk.mastery.crossbow"], ["perk.bh_learning_devil","Learning Devil","perk.student"],
		["perk.bh_flail_mastery","Flail Mastery","perk.mastery.flail"], ["perk.bh_polearm_mastery","Polearm Mastery","perk.mastery.polearm"],
		["perk.bh_shield_mastery","Shield Mastery","perk.shield_expert"], ["perk.bh_spear_mastery","Spear Mastery","perk.mastery.spear"]
	];
	local perks = [];
	foreach (d in defs)
	{
		local source = ::Const.Perks.findById(d[2]);
		local custom = ::Brotherhood.getCustomPerkIcons(d[0]);
		perks.push({ID=d[0],Script="scripts/skills/perks/perk_"+d[0].slice(5),Name=d[1],Tooltip=::Brotherhood.getLatestObsidianTooltip(d[0]),Icon=custom==null?(source==null?"ui/perks/perk_10.png":source.Icon):custom[0],IconDisabled=custom==null?(source==null?"ui/perks/perk_10_sw.png":source.IconDisabled):custom[1],PerkGroupIDs=[]});
	}
	::DynamicPerks.Perks.addPerks(perks);
}

::Brotherhood.initializeLatestObsidianArchetypes <- function()
{
	::Brotherhood.registerLatestObsidianPerks();
	if (!::Brotherhood.shouldInitializeArchetypeModule(["pg.bh_blackguard", "pg.bh_blueblood", "pg.bh_conqueror", "pg.bh_devout", "pg.bh_hunter", "pg.bh_man_at_arms", "pg.bh_strongman", "pg.bh_wildling"])) return;

	::Brotherhood.HooksMod.hook("scripts/entity/tactical/player", function(q) {
		q.updateLevel = @(__original) { function updateLevel()
		{
			local oldLevel = this.getLevel();
			local ret = __original();
			local perk = this.getSkills().getSkillByID("perk.bh_learning_devil");
			if (perk != null)
			{
				for (local level = oldLevel + 1; level <= this.getLevel(); ++level) perk.onLevelGained(level);
			}
			return ret;
		}}.updateLevel;
	});

	::Brotherhood.HooksMod.hook(::DynamicPerks.Class.PerkTree, function(q) {
		q.build = @(__original) { function build()
		{
			local ret = __original();
			if ("BH_SelectedFleshcraftParents" in this.m) return ret;
			if (this.hasPerkGroup("pg.bh_prodigy") && this.hasPerkGroup("pg.bh_braggart")) this.addPerk("perk.bh_ambition", 3);
			if (this.hasPerkGroup("pg.bh_blueblood") && this.hasPerkGroup("pg.bh_prodigy")) this.addPerk("perk.bh_scholarship", 2);
			if (this.hasPerkGroup("pg.bh_laborer") && this.hasPerkGroup("pg.bh_hunter")) this.addPerk("perk.bh_poach", 5);
			if (this.hasPerkGroup("pg.bh_plague_doctor") && this.hasPerkGroup("pg.bh_flagellant")) this.addPerk("perk.bh_bloodletting", 6);
			if (this.hasPerkGroup("pg.bh_dragon") && this.hasPerkGroup("pg.bh_impish")) this.addPerk("perk.bh_dragonet", 7);
			if (this.hasPerkGroup("pg.bh_prodigy") && this.hasPerkGroup("pg.bh_impish")) this.addPerk("perk.bh_learning_devil", 1);
			return ret;
		}}.build;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill_container", function(q) {
		q.add = @(__original) { function add( _skill, _order = 0 )
		{
			local actor = this.getActor();
			if (actor != null && _skill != null && _skill.getID() == "effects.stunned" && this.hasSkill("perk.bh_big_bones"))
			{
				local replacement = ::new("scripts/skills/effects/dazed_effect");
				::Brotherhood.logLatestObsidianTest("BIG BONES", actor, "Converted an incoming Stunned effect into Dazed.");
				return __original(replacement, _order);
			}
			return __original(_skill, _order);
		}}.add;
	});

	// hookTree does not reliably wrap trait scripts that override onUpdate.
	// Hook every concrete numerical trait path so Tough, Bright, Strong, and
	// the rest all use the same Birthright delta-doubling rule.
	local birthrightTraitPaths = [
		"scripts/skills/traits/addict_trait", "scripts/skills/traits/arena_fighter_trait", "scripts/skills/traits/arena_veteran_trait", "scripts/skills/traits/asthmatic_trait",
		"scripts/skills/traits/athletic_trait", "scripts/skills/traits/brave_trait", "scripts/skills/traits/bright_trait", "scripts/skills/traits/brute_trait",
		"scripts/skills/traits/clubfooted_trait", "scripts/skills/traits/clumsy_trait", "scripts/skills/traits/cocky_trait", "scripts/skills/traits/craven_trait",
		"scripts/skills/traits/cultist_acolyte_trait", "scripts/skills/traits/cultist_chosen_trait", "scripts/skills/traits/cultist_disciple_trait", "scripts/skills/traits/cultist_fanatic_trait",
		"scripts/skills/traits/cultist_prophet_trait", "scripts/skills/traits/cultist_zealot_trait", "scripts/skills/traits/dastard_trait", "scripts/skills/traits/deathwish_trait",
		"scripts/skills/traits/dexterous_trait", "scripts/skills/traits/disloyal_trait", "scripts/skills/traits/drunkard_trait", "scripts/skills/traits/dumb_trait",
		"scripts/skills/traits/eagle_eyes_trait", "scripts/skills/traits/fainthearted_trait", "scripts/skills/traits/fat_trait", "scripts/skills/traits/fear_beasts_trait",
		"scripts/skills/traits/fear_greenskins_trait", "scripts/skills/traits/fear_undead_trait", "scripts/skills/traits/fearless_trait", "scripts/skills/traits/fragile_trait",
		"scripts/skills/traits/glorious_endurance_trait", "scripts/skills/traits/glorious_resolve_trait", "scripts/skills/traits/gluttonous_trait", "scripts/skills/traits/greedy_trait",
		"scripts/skills/traits/hate_beasts_trait", "scripts/skills/traits/hate_greenskins_trait", "scripts/skills/traits/hate_undead_trait", "scripts/skills/traits/hesitant_trait",
		"scripts/skills/traits/huge_trait", "scripts/skills/traits/impatient_trait", "scripts/skills/traits/iron_jaw_trait", "scripts/skills/traits/iron_lungs_trait",
		"scripts/skills/traits/lucky_trait", "scripts/skills/traits/mad_trait", "scripts/skills/traits/night_blind_trait", "scripts/skills/traits/night_owl_trait",
		"scripts/skills/traits/oath_of_camaraderie_trait", "scripts/skills/traits/oath_of_distinction_trait", "scripts/skills/traits/oath_of_dominion_trait", "scripts/skills/traits/oath_of_endurance_trait",
		"scripts/skills/traits/oath_of_fortification_trait", "scripts/skills/traits/oath_of_humility_trait", "scripts/skills/traits/oath_of_righteousness_trait", "scripts/skills/traits/oath_of_sacrifice_trait",
		"scripts/skills/traits/oath_of_valor_trait", "scripts/skills/traits/oath_of_vengeance_trait", "scripts/skills/traits/oath_of_wrath_trait", "scripts/skills/traits/old_trait",
		"scripts/skills/traits/paranoid_trait", "scripts/skills/traits/player_character_trait", "scripts/skills/traits/quick_trait", "scripts/skills/traits/short_sighted_trait",
		"scripts/skills/traits/spartan_trait", "scripts/skills/traits/strong_trait", "scripts/skills/traits/sure_footing_trait", "scripts/skills/traits/survivor_trait",
		"scripts/skills/traits/swift_trait", "scripts/skills/traits/tiny_trait", "scripts/skills/traits/tough_trait"
	];
	foreach (traitPath in birthrightTraitPaths)
	{
		::Brotherhood.HooksMod.hook(traitPath, function(q) {
			q.m.BH_BirthrightDoubled <- false;
			q.onUpdate = @(__original) { function onUpdate( _properties )
			{
				local actor = this.getContainer() == null ? null : this.getContainer().getActor();
				if (actor == null || !actor.getSkills().hasSkill("perk.bh_birthright"))
				{
					this.m.BH_BirthrightDoubled = false;
					return __original(_properties);
				}
				local wasDoubled = this.m.BH_BirthrightDoubled;
				local before = ::Brotherhood.captureNumericProperties(_properties);
				__original(_properties);
				local changed = ::Brotherhood.repeatNumericPropertyDeltas(_properties, before, false, 1.0);
				this.m.BH_BirthrightDoubled = changed > 0;
				if (changed > 0 && !wasDoubled) ::Brotherhood.logLatestObsidianTest("BIRTHRIGHT", actor, "Doubled " + this.getName() + " across " + changed + " numerical trait value(s).");
			}}.onUpdate;

			q.getTooltip = @(__original) { function getTooltip()
			{
				local ret = __original();
				local actor = this.getContainer() == null ? null : this.getContainer().getActor();
				if (actor != null && actor.getSkills().hasSkill("perk.bh_birthright") && this.m.BH_BirthrightDoubled)
				{
					ret.push({ id = 98, type = "text", icon = "ui/icons/special.png", text = ::MSU.Text.colorPositive("Doubled by Birthright") });
				}
				return ret;
			}}.getTooltip;
		});
	}

	::Brotherhood.HooksMod.hook("scripts/skills/perks/perk_brawny", function(q) {
		q.getDescription = @(__original) { function getDescription()
		{
			local text = __original();
			local colored = ::MSU.Text.colorPositive("30%");
			local negative = ::MSU.Text.colorNegative("30%");
			local negativeIndex = text.find(negative);
			if (negativeIndex != null)
			{
				return text.slice(0, negativeIndex) + colored + text.slice(negativeIndex + negative.len());
			}
			if (text.find(colored) != null) return text;
			local index = text.find("30%");
			return index == null ? text : text.slice(0, index) + colored + text.slice(index + 3);
		}}.getDescription;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/special/morale_check", function(q) {
		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret = __original();
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor == null || actor.getMoraleState() != ::Const.MoraleState.Confident || !actor.getSkills().hasSkill("perk.bh_arrogance")) return ret;

			foreach (entry in ret)
			{
				if (!("text" in entry)) continue;
				local index = entry.text.find("+10%");
				if (index != null) entry.text = entry.text.slice(0, index) + "+20%" + entry.text.slice(index + 4);
			}
			ret.push({ id = 98, type = "text", icon = "ui/icons/special.png", text = ::MSU.Text.colorPositive("Doubled by Arrogance") });
			return ret;
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hookTree("scripts/skills/injury/injury", function(q) {
		q.onUpdate = @(__original) { function onUpdate( _properties )
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor == null || !actor.getSkills().hasSkill("perk.bh_resilient")) return __original(_properties);
			local before = ::Brotherhood.captureNumericProperties(_properties);
			__original(_properties);
			::Brotherhood.repeatNumericPropertyDeltas(_properties, before, true, -0.5);
		}}.onUpdate;
	});

	::Brotherhood.HooksMod.hookTree("scripts/skills/skill", function(q) {
		q.isUsable = @(__original) { function isUsable()
		{
			local ret = __original();
			if (ret || !this.isAttack() || !this.isRanged() || this.getContainer() == null)
			{
				if ("BH_SteadyHandsAllowedLogged" in this.m) this.m.BH_SteadyHandsAllowedLogged = false;
				return ret;
			}
			local actor = this.getContainer().getActor();
			if (actor == null || !actor.getSkills().hasSkill("perk.bh_steady_hands") || !::Tactical.isActive() || !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
			{
				if ("BH_SteadyHandsAllowedLogged" in this.m) this.m.BH_SteadyHandsAllowedLogged = false;
				return ret;
			}
			local p = actor.getCurrentProperties();
			if (!this.m.IsUsable || !p.IsAbleToUseSkills || (this.m.IsWeaponSkill && !p.IsAbleToUseWeaponSkills) || this.isHidden())
			{
				if ("BH_SteadyHandsAllowedLogged" in this.m) this.m.BH_SteadyHandsAllowedLogged = false;
				return false;
			}
			if ("IsSpent" in this.m && this.m.IsSpent)
			{
				if ("BH_SteadyHandsAllowedLogged" in this.m) this.m.BH_SteadyHandsAllowedLogged = false;
				return false;
			}
			if ("getAmmo" in this && this.getAmmo() <= 0)
			{
				if ("BH_SteadyHandsAllowedLogged" in this.m) this.m.BH_SteadyHandsAllowedLogged = false;
				return false;
			}
			if ("getItem" in this)
			{
				local item = this.getItem();
				if (item != null && "isLoaded" in item && !item.isLoaded())
				{
					if ("BH_SteadyHandsAllowedLogged" in this.m) this.m.BH_SteadyHandsAllowedLogged = false;
					return false;
				}
			}
			local alreadyLogged = "BH_SteadyHandsAllowedLogged" in this.m && this.m.BH_SteadyHandsAllowedLogged;
			if (!alreadyLogged)
			{
				::Brotherhood.logLatestObsidianTest("STEADY HANDS", actor, "Allowed " + this.getName() + " while engaged in melee.");
				if ("BH_SteadyHandsAllowedLogged" in this.m) this.m.BH_SteadyHandsAllowedLogged = true;
				else this.m.BH_SteadyHandsAllowedLogged <- true;
			}
			return true;
		}}.isUsable;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.getActionPointCost = @(__original) { function getActionPointCost()
		{
			local cost = __original();
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null && actor.getSkills().hasSkill("perk.bh_polearm_mastery") && ::Brotherhood.isWeaponSkillType(this, ::Const.Items.WeaponType.Polearm))
			{
				cost = ::Math.min(cost, 5);
			}
			local veteran = actor == null ? null : actor.getSkills().getSkillByID("perk.bh_veteran");
			if (veteran != null && this.m.IsWeaponSkill && !veteran.m.IsSpent) cost = ::Math.max(0, cost - 1);
			return cost;
		}}.getActionPointCost;

		q.getFatigueCost = @(__original) { function getFatigueCost()
		{
			local cost = __original();
			if (this.getContainer() != null && this.getContainer().hasSkill("perk.bh_flail_mastery") && ::Brotherhood.isWeaponSkillType(this, ::Const.Items.WeaponType.Flail))
			{
				cost = ::Math.max(0, ::Math.round(cost * 0.75));
			}
			return cost;
		}}.getFatigueCost;
	});

	foreach (path in ["scripts/skills/actives/lash_skill", "scripts/skills/actives/hail_skill"])
	{
		::Brotherhood.HooksMod.hook(path, function(q) {
			q.onAfterUpdate = @(__original) { function onAfterUpdate( _properties )
			{
				__original(_properties);
				if (this.getContainer() != null && this.getContainer().hasSkill("perk.bh_flail_mastery")) this.m.IsShieldRelevant = false;
			}}.onAfterUpdate;

			q.getTooltip = @(__original) { function getTooltip()
			{
				local ret = __original();
				if (this.getContainer() != null && this.getContainer().hasSkill("perk.bh_flail_mastery"))
				{
					ret.push({ id = 91, type = "text", icon = "ui/icons/special.png", text = "Ignores the Melee Defense bonus granted by shields" });
				}
				return ret;
			}}.getTooltip;
		});
	}

	::Brotherhood.HooksMod.hook("scripts/skills/actives/pound", function(q) {
		q.onBeforeTargetHit = @(__original) { function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
		{
			__original(_skill, _targetEntity, _hitInfo);
			if (_skill == this && _hitInfo.BodyPart == ::Const.BodyPart.Head && !_targetEntity.getCurrentProperties().IsImmuneToHeadshots && this.getContainer().hasSkill("perk.bh_flail_mastery"))
			{
				_hitInfo.DamageDirect += 0.15;
				::Brotherhood.logLatestObsidianTest("FLAIL MASTERY", this.getContainer().getActor(), "Pound head hit gained +15% armor penetration.");
			}
		}}.onBeforeTargetHit;

		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret = __original();
			if (this.getContainer() != null && this.getContainer().hasSkill("perk.bh_flail_mastery"))
			{
				ret.push({ id = 91, type = "text", icon = "ui/icons/special.png", text = "Head hits ignore an additional " + ::MSU.Text.colorPositive("15%") + " of armor from Flail Mastery" });
			}
			return ret;
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/thresh", function(q) {
		q.getHitChanceModifier = @(__original) { function getHitChanceModifier()
		{
			local ret = __original();
			return this.getContainer() != null && this.getContainer().hasSkill("perk.bh_flail_mastery") ? ret + 5 : ret;
		}}.getHitChanceModifier;
	});

	::Brotherhood.HooksMod.hook("scripts/items/shields/shield", function(q) {
		q.onUpdateProperties = @(__original) { function onUpdateProperties( _properties )
		{
			__original(_properties);
			if (this.m.Condition == 0 || this.getContainer() == null || this.getContainer().getActor() == null || !this.getContainer().getActor().getSkills().hasSkill("perk.bh_shield_mastery")) return;
			_properties.MeleeDefense += ::Math.floor(this.getMeleeDefense() * 0.25);
			_properties.RangedDefense += ::Math.floor(this.getRangedDefense() * 0.25);
		}}.onUpdateProperties;

		q.applyShieldDamage = @(__original) { function applyShieldDamage( _damage, _playHitSound = true )
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null && actor.getSkills().hasSkill("perk.bh_shield_mastery"))
			{
				_damage = ::Math.max(1, ::Math.ceil(_damage * 0.5));
				::Brotherhood.logLatestObsidianTest("SHIELD MASTERY", actor, "Reduced incoming shield damage to " + _damage + ".");
			}
			return __original(_damage, _playHitSound);
		}}.applyShieldDamage;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/knock_back", function(q) {
		q.onAnySkillUsed = @(__original) { function onAnySkillUsed( _skill, _targetEntity, _properties )
		{
			__original(_skill, _targetEntity, _properties);
			if (_skill == this && this.getContainer().hasSkill("perk.bh_shield_mastery")) _properties.MeleeSkill += 15;
		}}.onAnySkillUsed;

		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret = __original();
			if (this.getContainer() != null && this.getContainer().hasSkill("perk.bh_shield_mastery"))
			{
				ret.push({ id = 91, type = "text", icon = "ui/icons/hitchance.png", text = "Has " + ::MSU.Text.colorPositive("+15%") + " chance to hit from Shield Mastery" });
			}
			return ret;
		}}.getTooltip;
	});

	::Brotherhood.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
		q.onOtherActorDeath = @(__original) { function onOtherActorDeath( _killer, _victim, _skill )
		{
			if (_victim != null && _victim.isAlliedWith(this) && this.getSkills().hasSkill("perk.bh_forsworn") && !::Brotherhood.hasNearbyAlly(this, 3))
			{
				::Brotherhood.logLatestObsidianTest("FORSWORN", this, "Ignored the morale check caused by " + _victim.getName() + " dying while isolated.");
				return;
			}
			return __original(_killer, _victim, _skill);
		}}.onOtherActorDeath;
		q.onOtherActorFleeing = @(__original) { function onOtherActorFleeing( _actor )
		{
			if (_actor != null && _actor.isAlliedWith(this) && this.getSkills().hasSkill("perk.bh_forsworn") && !::Brotherhood.hasNearbyAlly(this, 3))
			{
				::Brotherhood.logLatestObsidianTest("FORSWORN", this, "Ignored the morale check caused by " + _actor.getName() + " fleeing while isolated.");
				return;
			}
			return __original(_actor);
		}}.onOtherActorFleeing;
	});

	::Reforged.QueueBucket.AfterHooks.push(function() {
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		local memberships = {
			"perk.bh_ambition":["pg.bh_prodigy","pg.bh_braggart"],
			"perk.bh_forsworn":["pg.bh_blackguard"], "perk.bh_birthright":["pg.bh_blueblood"], "perk.bh_virtuous":["pg.bh_blueblood"], "perk.bh_arrogance":["pg.bh_blueblood"],
			"perk.bh_breach":["pg.bh_conqueror"], "perk.bh_shatter":["pg.bh_conqueror"], "perk.bh_despair":["pg.bh_conqueror"], "perk.bh_hope":["pg.bh_devout"],
			"perk.bh_small_head":["pg.bh_hunter"], "perk.bh_steady_hands":["pg.bh_hunter"], "perk.bh_big_game_hunter":["pg.bh_hunter"], "perk.bh_veteran":["pg.bh_man_at_arms"],
			"perk.bh_big_bones":["pg.bh_strongman"], "perk.bh_unmovable":["pg.bh_strongman"], "perk.bh_resilient":["pg.bh_flagellant"],
			"perk.bh_scholarship":["pg.bh_blueblood","pg.bh_prodigy"], "perk.bh_poach":["pg.bh_laborer","pg.bh_hunter"],
			"perk.bh_bloodletting":["pg.bh_plague_doctor","pg.bh_flagellant"], "perk.bh_dragonet":["pg.bh_dragon","pg.bh_impish"],
			"perk.bh_learning_devil":["pg.bh_prodigy","pg.bh_impish"]
		};
		foreach (id, groups in memberships) { local perk=::Const.Perks.findById(id); if(perk!=null) perk.PerkGroupIDs=clone groups; }

		local nativeMemberships = {
			"perk.adrenaline":["pg.bh_berserker"], "perk.dodge":["pg.bh_fencer"],
			"perk.lone_wolf":["pg.bh_blackguard","pg.bh_wildling"],
			"perk.fortified_mind":["pg.bh_devout"], "perk.head_hunter":["pg.bh_hunter"],
			"perk.steel_brow":["pg.bh_strongman"],
			"perk.brawny":["pg.bh_strongman"], "perk.pathfinder":["pg.bh_wildling"]
		};
		foreach (id, groups in nativeMemberships) foreach (groupID in groups) ::Brotherhood.appendPerkGroupMembership(id, groupID);

		local customShared = {
			"perk.bh_axe_mastery":["pg.bh_blackguard","pg.bh_man_at_arms"], "perk.bh_hammer_mastery":["pg.bh_blackguard","pg.bh_conqueror","pg.bh_devout","pg.bh_man_at_arms"],
			"perk.bh_mace_mastery":["pg.bh_blackguard","pg.bh_conqueror","pg.bh_devout","pg.bh_man_at_arms"], "perk.bh_sword_mastery":["pg.bh_blueblood","pg.bh_conqueror","pg.bh_man_at_arms"],
			"perk.bh_cleaver_mastery":["pg.bh_conqueror"], "perk.bh_fearsome":["pg.bh_blackguard","pg.bh_conqueror"],
			"perk.bh_bow_mastery":["pg.bh_hunter"], "perk.bh_crossbow_mastery":["pg.bh_hunter"], "perk.bh_throwing_mastery":["pg.bh_hunter","pg.bh_wildling"],
			"perk.bh_net_mastery":["pg.bh_hunter"], "perk.bh_fast_adaptation":["pg.bh_wildling"],
			"perk.bh_flail_mastery":["pg.bh_blackguard","pg.bh_conqueror","pg.bh_man_at_arms"],
			"perk.bh_polearm_mastery":["pg.bh_man_at_arms"], "perk.bh_shield_mastery":["pg.bh_man_at_arms"], "perk.bh_spear_mastery":["pg.bh_man_at_arms"]
		};
		foreach (id, groups in customShared) foreach (groupID in groups) ::Brotherhood.appendPerkGroupMembership(id, groupID);

		local category = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_fighting_style");
		if (category != null)
		{
			local groups = clone category.getGroups();
			foreach (id in ["pg.bh_blackguard","pg.bh_blueblood","pg.bh_conqueror","pg.bh_devout","pg.bh_hunter","pg.bh_man_at_arms","pg.bh_strongman","pg.bh_wildling"]) if (groups.find(id)==null) groups.push(id);
			category.setGroups(groups);
		}
	});
}
