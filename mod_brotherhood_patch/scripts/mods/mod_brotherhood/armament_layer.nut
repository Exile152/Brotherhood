// Armament layer — runs once after all four parent halves are seated.
// Counts unique weapon masteries already dealt by parents, then fills the
// recruit toward 3–7 total. Cap is 7 across the whole deal; owned parent
// masteries are never removed. Past the floor of 3, each extra mastery is
// rolled with diminishing continue chance.

if (!("Brotherhood" in getroottable())) return;

// Active Obsidian weapon masteries only. Shield / consumable / medicine /
// fencing / martial stay out of this layer. Flail and generic throwing are
// omitted until they are live Active Obsidian generation IDs.
::Brotherhood.ArmamentWeaponMasteryPool <- [
	"perk.bh_axe_mastery",
	"perk.bh_bow_mastery",
	"perk.bh_cleaver_mastery",
	"perk.bh_crossbow_mastery",
	"perk.bh_dagger_mastery",
	"perk.bh_gunpowder_mastery",
	"perk.bh_hammer_mastery",
	"perk.bh_juggling_mastery",
	"perk.bh_mace_mastery",
	"perk.bh_polearm_mastery",
	"perk.bh_skirmishing_mastery",
	"perk.bh_spear_mastery",
	"perk.bh_sword_mastery",
	"perk.bh_volley_mastery"
];

::Brotherhood.ArmamentMinMasteries <- 3;
::Brotherhood.ArmamentMaxMasteries <- 7;

::Brotherhood.isArmamentWeaponMastery <- function( _perkID )
{
	return ::Brotherhood.ArmamentWeaponMasteryPool.find(_perkID) != null;
}

::Brotherhood.getArmamentMasteriesFromHalf <- function( _half )
{
	local owned = [];
	foreach (perkID in _half)
	{
		if (::Brotherhood.isArmamentWeaponMastery(perkID) && owned.find(perkID) == null)
			owned.push(perkID);
	}
	return owned;
}

::Brotherhood.getArmamentMasteriesFromParents <- function( _realizedParents )
{
	local owned = [];
	foreach (parent in _realizedParents)
	{
		foreach (perkID in ::Brotherhood.getArmamentMasteriesFromHalf(parent.Half))
			if (owned.find(perkID) == null) owned.push(perkID);
	}
	return owned;
}

::Brotherhood.getArmamentCandidatePool <- function( _owned )
{
	local candidates = [];
	foreach (perkID in ::Brotherhood.ArmamentWeaponMasteryPool)
	{
		if (_owned.find(perkID) != null) continue;
		if (!(perkID in ::Brotherhood.FleshcraftPerkTiers)) continue;
		if (!::Brotherhood.isActiveObsidianPerk(perkID)) continue;
		candidates.push(perkID);
	}
	candidates.sort(@(a, b) a <=> b);
	return candidates;
}

// Chance to attempt one more mastery when the recruit already has this many.
// Floor fills to 3 are guaranteed; these apply only for counts 3..6.
::Brotherhood.armamentContinueChance <- function( _count )
{
	if (_count == 3) return 0.80;
	if (_count == 4) return 0.55;
	if (_count == 5) return 0.35;
	if (_count == 6) return 0.18;
	return 0.0;
}

::Brotherhood.pickArmamentMastery <- function( _candidates, _random )
{
	if (_candidates.len() == 0) return null;
	local index = ::Math.floor(::Brotherhood.fleshcraftRandomUnit(_random) * _candidates.len()).tointeger();
	if (index >= _candidates.len()) index = _candidates.len() - 1;
	return _candidates[index];
}

::Brotherhood.stampArmamentReportOnParents <- function( _realizedParents, _report )
{
	foreach (parent in _realizedParents)
	{
		parent.ArmamentBefore <- _report.Before;
		parent.ArmamentAdded <- _report.Added;
		parent.ArmamentFinal <- _report.Final;
		parent.ArmamentNote <- _report.Note;
	}
}

// One pass for the whole recruit. Does not mutate parent halves; extras are
// stored on ArmamentAdded and seated during tree assembly.
::Brotherhood.applyArmamentLayerToParents <- function( _realizedParents, _random = null )
{
	local owned = ::Brotherhood.getArmamentMasteriesFromParents(_realizedParents);
	local before = clone owned;
	local added = [];
	local note = null;

	if (owned.len() >= ::Brotherhood.ArmamentMaxMasteries)
	{
		note = "already at or above the armament cap of " + ::Brotherhood.ArmamentMaxMasteries;
		local report = { Before = before, Added = added, Final = owned, Note = note };
		::Brotherhood.stampArmamentReportOnParents(_realizedParents, report);
		return _realizedParents;
	}

	local candidates = ::Brotherhood.getArmamentCandidatePool(owned);

	while (owned.len() < ::Brotherhood.ArmamentMinMasteries && candidates.len() != 0)
	{
		local pick = ::Brotherhood.pickArmamentMastery(candidates, _random);
		if (pick == null) break;
		owned.push(pick);
		added.push(pick);
		candidates = ::Brotherhood.getArmamentCandidatePool(owned);
	}

	while (owned.len() < ::Brotherhood.ArmamentMaxMasteries && candidates.len() != 0)
	{
		local chance = ::Brotherhood.armamentContinueChance(owned.len());
		if (chance <= 0.0) break;
		if (::Brotherhood.fleshcraftRandomUnit(_random) >= chance)
		{
			note = "soft-stop at " + owned.len() + " masteries (continue chance " + ::format("%.0f", chance * 100.0) + "%)";
			break;
		}
		local pick = ::Brotherhood.pickArmamentMastery(candidates, _random);
		if (pick == null) break;
		owned.push(pick);
		added.push(pick);
		candidates = ::Brotherhood.getArmamentCandidatePool(owned);
	}

	if (note == null && owned.len() >= ::Brotherhood.ArmamentMaxMasteries)
		note = "reached armament cap of " + ::Brotherhood.ArmamentMaxMasteries;
	else if (note == null && candidates.len() == 0)
		note = "armament pool exhausted at " + owned.len() + " masteries";

	local report = { Before = before, Added = added, Final = owned, Note = note };
	::Brotherhood.stampArmamentReportOnParents(_realizedParents, report);
	return _realizedParents;
}

::Brotherhood.getArmamentLayerAdded <- function( _realizedParents )
{
	if (_realizedParents == null || _realizedParents.len() == 0) return [];
	local first = _realizedParents[0];
	if (!("ArmamentAdded" in first) || typeof first.ArmamentAdded != "array") return [];
	return first.ArmamentAdded;
}

::Brotherhood.formatArmamentLayerLog <- function( _realizedParents )
{
	if (_realizedParents == null || _realizedParents.len() == 0)
		return "[Brotherhood][FLESHCRAFT][ARMAMENT] before=0; added=[]; final=0; masteries=[]; note=no parents";
	local first = _realizedParents[0];
	local before = "ArmamentBefore" in first ? first.ArmamentBefore : [];
	local added = "ArmamentAdded" in first ? first.ArmamentAdded : [];
	local finalMasteries = "ArmamentFinal" in first ? first.ArmamentFinal : [];
	local note = "ArmamentNote" in first && first.ArmamentNote != null ? first.ArmamentNote : "none";
	local parentBits = [];
	foreach (parent in _realizedParents)
	{
		local owned = ::Brotherhood.getArmamentMasteriesFromHalf(parent.Half);
		parentBits.push(parent.TemplateID + "=" + owned.len());
	}
	return "[Brotherhood][FLESHCRAFT][ARMAMENT] parents=[" + ::Brotherhood.fleshcraftFormatIDs(parentBits) + "]"
		+ "; before=" + before.len()
		+ "; added=[" + ::Brotherhood.fleshcraftFormatIDs(added) + "]"
		+ "; final=" + finalMasteries.len()
		+ "; masteries=[" + ::Brotherhood.fleshcraftFormatIDs(finalMasteries) + "]"
		+ "; note=" + note;
}
