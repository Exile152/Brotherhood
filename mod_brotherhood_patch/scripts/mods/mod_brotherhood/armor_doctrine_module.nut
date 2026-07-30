if (!("Brotherhood" in getroottable())) return;

// Armor Doctrines are always-present direct perk rolls. They intentionally do
// not have a Dynamic Perks group or category of their own.
::Brotherhood.ArmorDoctrinePool <- [
	{ ID = "perk.bh_nimble", Name = "Nimble" },
	{ ID = "perk.bh_battle_forged", Name = "Battle Forged" },
	{ ID = "perk.bh_evasive", Name = "Evasive" },
	{ ID = "perk.bh_endurance", Name = "Endurance" }
];

::Brotherhood.ArmorDoctrineRollCount <- 3;

::Brotherhood.isArmorDoctrine <- function( _perkID )
{
	foreach (doctrine in ::Brotherhood.ArmorDoctrinePool)
	{
		if (doctrine.ID == _perkID) return true;
	}

	return false;
}

::Brotherhood.getEvasiveTooltip <- function()
{
	return ::Brotherhood.formatSurvivalPerkTooltip({
		Fluff = "Why take some damage, when I can take none?",
		Effects = [{
			Type = ::UPD.EffectType.Passive,
			Description = [
				"While the combined [Fatigue|Concept.MaximumFatigue] penalty of your head and body armor is " + ::MSU.Text.colorPositive("5") + " or less, you begin combat Evasive.",
				"At the start of your turn, become Evasive if you are not adjacent to an enemy.",
				"When a direct attack would hit you while Evasive, the attack misses instead and Evasive is removed.",
				"Natural misses do not remove Evasive."
			]
		}]
	});
}

::Brotherhood.getVanillaNimbleTooltip <- function()
{
	return ::Brotherhood.formatSurvivalPerkTooltip({
		Fluff = "Specialize in light armor! By nimbly dodging or deflecting blows, convert any hits to glancing hits.",
		Effects = [{
			Type = ::UPD.EffectType.Passive,
			Description = [
				"[Hitpoint|Concept.Hitpoints] damage taken is reduced by up to " + ::MSU.Text.colorPositive("60%") + ", but lowered exponentially by the total penalty to [Maximum Fatigue|Concept.MaximumFatigue] from body and head armor above " + ::MSU.Text.colorPositive("15") + "."
			]
		}]
	});
}

::Brotherhood.getVanillaBattleForgedTooltip <- function()
{
	return ::Brotherhood.formatSurvivalPerkTooltip({
		Fluff = "Specialize in heavy armor! By making your armor even more resilient, you can take more blows and hit back.",
		Effects = [{
			Type = ::UPD.EffectType.Passive,
			Description = [
				"Armor damage taken is reduced by a percentage equal to " + ::MSU.Text.colorPositive("5%") + " of the current total armor value of both body and head armor."
			]
		}]
	});
}

::Brotherhood.getEnduranceTooltip <- function()
{
	return ::Brotherhood.formatSurvivalPerkTooltip({
		Fluff = "Specialize in medium armor! By letting your stamina absorb some of the force behind incoming blows, you can stay standing longer.",
		Effects = [{
			Type = ::UPD.EffectType.Passive,
			Description = [
				"When an attack deals [Hitpoint|Concept.Hitpoints] damage through armor, " + ::MSU.Text.colorPositive("50%") + " of that damage is converted into [Fatigue|Concept.Fatigue] instead.",
				"The amount converted cannot exceed the combined [Fatigue|Concept.MaximumFatigue] penalty of your head and body armor or your remaining [Fatigue|Concept.Fatigue] capacity.",
				"Any damage that cannot be converted is dealt to your [Hitpoints|Concept.Hitpoints] normally."
			]
		}]
	});
}

::Brotherhood.logArmorDoctrineTest <- function( _actor, _message )
{
	local name = _actor == null ? "Unknown" : _actor.getName();
	local text = "[BH ARMOR DOCTRINE TEST] " + name + ": " + _message;
	::logInfo(text);

	if (::Tactical.isActive() && _actor != null && _actor.isPlayerControlled())
	{
		::Tactical.EventLog.log(text);
	}
}

::Brotherhood.initializeArmorDoctrines <- function()
{
	::DynamicPerks.Perks.addPerks([
		{
			ID = "perk.bh_nimble",
			Script = "scripts/skills/perks/perk_bh_nimble",
			Name = "Nimble",
			Tooltip = ::Brotherhood.getVanillaNimbleTooltip(),
			Icon = "ui/perks/perk_29.png",
			IconDisabled = "ui/perks/perk_29_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_battle_forged",
			Script = "scripts/skills/perks/perk_bh_battle_forged",
			Name = "Battle Forged",
			Tooltip = ::Brotherhood.getVanillaBattleForgedTooltip(),
			Icon = "ui/perks/perk_03.png",
			IconDisabled = "ui/perks/perk_03_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_evasive",
			Script = "scripts/skills/perks/perk_bh_evasive",
			Name = "Evasive",
			Tooltip = ::Brotherhood.getEvasiveTooltip(),
			Icon = "ui/perks/bh_evasive.png",
			IconDisabled = "ui/perks/bh_evasive_sw.png",
			PerkGroupIDs = []
		},
		{
			ID = "perk.bh_endurance",
			Script = "scripts/skills/perks/perk_bh_endurance",
			Name = "Endurance",
			Tooltip = ::Brotherhood.getEnduranceTooltip(),
			Icon = "ui/perks/bh_endurance.png",
			IconDisabled = "ui/perks/bh_endurance_sw.png",
			PerkGroupIDs = []
		}
	]);

	foreach (doctrine in ::Brotherhood.ArmorDoctrinePool)
	{
		local perk = ::Const.Perks.findById(doctrine.ID);
		if (perk == null) throw "Brotherhood Armor Doctrine was not registered: " + doctrine.ID;
		if (!("PerkGroupIDs" in perk)) perk.PerkGroupIDs <- [];
	}

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.general_queryUIPerkTooltipData = @(__original) { function general_queryUIPerkTooltipData( _entityId, _perkId )
		{
			local ret = __original(_entityId, _perkId);
			if (ret == null || !::Brotherhood.isArmorDoctrine(_perkId)) return ret;
			local actor = ::Tactical.getEntityByID(_entityId);
			if (actor == null || !::Brotherhood.isTestingPerkTree(actor.getPerkTree())) return ret;

			ret = ret.filter(function( _index, _entry )
			{
				return !("type" in _entry && _entry.type == "hint" && "text" in _entry && typeof _entry.text == "string" && _entry.text.find("perk group") != null);
			});
			ret.insert(2, {
				id = 3,
				type = "hint",
				icon = "ui/icons/special.png",
				text = "Armor Doctrine"
			});
			return ret;
		}}.general_queryUIPerkTooltipData;
	});

	// Modular Vanilla exposes the completed attack roll before hit/miss feedback
	// and dispatch. Only convert a roll which already succeeded; natural misses
	// therefore leave Evasive untouched and continue down the normal miss path.
	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.MV_onAttackRolled = @(__original) { function MV_onAttackRolled( _attackInfo )
		{
			__original(_attackInfo);
			if (!this.isAttack() || !this.isUsingHitchance() || _attackInfo.Roll > _attackInfo.ChanceToHit) return;

			local target = _attackInfo.Target;
			if (target != null && target.isAlive())
			{
				local elusive = target.getSkills().getSkillByID("effects.bh_elusive");
				if (elusive != null && elusive.consumeElusive(this, _attackInfo.User))
				{
					_attackInfo.Roll = _attackInfo.ChanceToHit + 1;
				}
			}
		}}.MV_onAttackRolled;
	});

	// Modular Vanilla has finalized both armor and Hitpoint damage by the time
	// this function runs, but has not yet applied Fatigue or Hitpoint loss. That
	// lets Endurance convert the exact resolved damage and update every later
	// consumer (injuries, morale, hit sounds, logs, and other damage perks).
	::Brotherhood.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
		q.MV_calcFatigueDamageReceived = @(__original) { function MV_calcFatigueDamageReceived( _skill, _hitInfo )
		{
			local normalFatigueDamage = __original(_skill, _hitInfo);
			if (_skill == null || !_skill.isAttack() || _hitInfo.DamageInflictedHitpoints <= 0) return normalFatigueDamage;

			local endurance = this.getSkills().getSkillByID("perk.bh_endurance");
			if (endurance == null || !("MV_PropertiesForBeingHit" in _hitInfo)) return normalFatigueDamage;

			local properties = _hitInfo.MV_PropertiesForBeingHit;
			local armorBeforeHit = properties.Armor[_hitInfo.BodyPart] * properties.ArmorMult[_hitInfo.BodyPart];
			if (armorBeforeHit <= 0) return normalFatigueDamage;

			local armorFatiguePenalty = endurance.getArmorFatiguePenalty();
			local fatigueAfterNormalDamage = this.Math.min(
				this.getFatigueMax(),
				this.Math.round(this.getFatigue() + normalFatigueDamage)
			);
			local remainingFatigueCapacity = this.Math.max(0, this.getFatigueMax() - fatigueAfterNormalDamage);
			local requestedConversion = this.Math.floor(_hitInfo.DamageInflictedHitpoints * 0.50);
			local converted = this.Math.min(requestedConversion, this.Math.min(armorFatiguePenalty, remainingFatigueCapacity));
			if (converted <= 0) return normalFatigueDamage;

			local originalHitpointDamage = _hitInfo.DamageInflictedHitpoints;
			_hitInfo.DamageInflictedHitpoints -= converted;
			::Brotherhood.logArmorDoctrineTest(
				this,
				"Endurance converted " + converted.tostring() + " of " + originalHitpointDamage.tostring()
				+ " Hitpoint damage into Fatigue; " + _hitInfo.DamageInflictedHitpoints.tostring() + " Hitpoint damage remains."
			);
			return normalFatigueDamage + converted;
		}}.MV_calcFatigueDamageReceived;
	});
}
