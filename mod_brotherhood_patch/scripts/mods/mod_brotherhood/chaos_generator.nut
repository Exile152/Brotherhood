// Chaos is deliberately unrelated to the five identities, but every entry is
// a self-contained passive or utility perk that does not need an archetype-only
// active, status, weapon, or paired perk to function.
::Brotherhood.ChaosPerkPool <- [
	{ ID="perk.fast_adaption", Tier=1 }, { ID="perk.crippling_strikes", Tier=1 },
	{ ID="perk.colossus", Tier=1 }, { ID="perk.nine_lives", Tier=1 },
	{ ID="perk.bags_and_belts", Tier=1 }, { ID="perk.pathfinder", Tier=1 },
	{ ID="perk.adrenaline", Tier=1 }, { ID="perk.recover", Tier=1 },
	{ ID="perk.executioner", Tier=2 }, { ID="perk.dodge", Tier=2 },
	{ ID="perk.fortified_mind", Tier=2 }, { ID="perk.gifted", Tier=2 },
	{ ID="perk.backstabber", Tier=2 }, { ID="perk.anticipation", Tier=2 },
	{ ID="perk.brawny", Tier=3 }, { ID="perk.relentless", Tier=3 },
	{ ID="perk.rotation", Tier=3 }, { ID="perk.steel_brow", Tier=3 },
	{ ID="perk.overwhelm", Tier=4 }, { ID="perk.underdog", Tier=5 },
	{ ID="perk.lone_wolf", Tier=5 }, { ID="perk.footwork", Tier=5 },
	{ ID="perk.berserk", Tier=6 }, { ID="perk.fearsome", Tier=6 },
	{ ID="perk.killing_frenzy", Tier=7 }
];

// Weapon masteries are valid Chaos safety valves. They are kept separate from
// the general pool so selection can strongly prefer the first one and then
// reduce that preference for every mastery already present in the tree.
::Brotherhood.ChaosWeaponMasteryPool <- [
	{ ID="perk.bh_axe_mastery", Tier=4 }, { ID="perk.bh_bow_mastery", Tier=4 },
	{ ID="perk.bh_cleaver_mastery", Tier=4 }, { ID="perk.bh_crossbow_mastery", Tier=4 },
	{ ID="perk.bh_dagger_mastery", Tier=4 }, { ID="perk.bh_flail_mastery", Tier=4 },
	{ ID="perk.bh_gunpowder_mastery", Tier=4 }, { ID="perk.bh_hammer_mastery", Tier=4 },
	{ ID="perk.bh_mace_mastery", Tier=4 }, { ID="perk.bh_polearm_mastery", Tier=4 },
	{ ID="perk.bh_spear_mastery", Tier=4 }, { ID="perk.bh_sword_mastery", Tier=4 },
	{ ID="perk.bh_throwing_mastery", Tier=4 }
];

::Brotherhood.getChaosPerkDisplayName <- function( _perkID )
{
	local definition = ::Const.Perks.findById(_perkID);
	return definition == null || !("Name" in definition) ? _perkID.tolower() : definition.Name.tolower();
}

::Brotherhood.getRecordedChaosPerks <- function( _perkTree )
{
	if ("BH_ChaosPerks" in _perkTree.m && typeof _perkTree.m.BH_ChaosPerks == "array") return clone _perkTree.m.BH_ChaosPerks;
	local actor = _perkTree.getActor();
	if (::MSU.isNull(actor) || !actor.getFlags().has("BH_ChaosPerks")) return [];
	local serialized = actor.getFlags().get("BH_ChaosPerks");
	return serialized == "" ? [] : ::split(serialized, "|");
}

::Brotherhood.storeRecordedChaosPerks <- function( _perkTree, _perkIDs )
{
	if ("BH_ChaosPerks" in _perkTree.m) _perkTree.m.BH_ChaosPerks = clone _perkIDs;
	else _perkTree.m.BH_ChaosPerks <- clone _perkIDs;

	local actor = _perkTree.getActor();
	if (::MSU.isNull(actor)) return;
	local serialized = "";
	foreach (index, perkID in _perkIDs)
	{
		if (index != 0) serialized += "|";
		serialized += perkID;
	}
	actor.getFlags().set("BH_ChaosPerks", serialized);
}

::Brotherhood.getWildPerkOwnership <- function( _perkTree )
{
	local ret = { IDs = {}, Names = {} };
	if (!("BH_WildSources" in _perkTree.m)) return ret;
	foreach (record in _perkTree.m.BH_WildSources)
	{
		if (!("AddedPerkIDs" in record) || typeof record.AddedPerkIDs != "array") continue;
		foreach (perkID in record.AddedPerkIDs)
		{
			ret.IDs[perkID] <- true;
			ret.Names[::Brotherhood.getChaosPerkDisplayName(perkID)] <- true;
		}
	}
	return ret;
}

::Brotherhood.getChaosWeaponMasteryNameMap <- function()
{
	local ret = {};
	foreach (entry in ::Brotherhood.ChaosWeaponMasteryPool)
	{
		ret[::Brotherhood.getChaosPerkDisplayName(entry.ID)] <- true;
	}
	return ret;
}

::Brotherhood.countWeaponMasteriesInTree <- function( _perkTree )
{
	local masteryNames = ::Brotherhood.getChaosWeaponMasteryNameMap();
	local seen = {};
	foreach (perkID, perk in _perkTree.getPerks())
	{
		local name = ::Brotherhood.getChaosPerkDisplayName(perkID);
		if (name in masteryNames) seen[name] <- true;
	}
	return seen.len();
}

::Brotherhood.selectChaosPoolIndex <- function( _pool, _masteryCount )
{
	local masteries = [];
	local utilities = [];
	foreach (index, entry in _pool)
	{
		(entry.IsWeaponMastery ? masteries : utilities).push(index);
	}
	if (masteries.len() == 0) return ::Math.rand(0, utilities.len() - 1);
	if (utilities.len() == 0) return masteries[::Math.rand(0, masteries.len() - 1)];

	// No-mastery trees are guaranteed one. Further mastery preference falls
	// from 60% to 30% to 10%, avoiding mastery floods while still filling thin
	// weapon rows more often than uniform Chaos selection would.
	local masteryChance = _masteryCount == 0 ? 100 : (_masteryCount == 1 ? 60 : (_masteryCount == 2 ? 30 : 10));
	local candidates = ::Math.rand(1, 100) <= masteryChance ? masteries : utilities;
	return candidates[::Math.rand(0, candidates.len() - 1)];
}

::Brotherhood.removeDuplicateRecordedChaosPerks <- function( _perkTree )
{
	local recorded = ::Brotherhood.getRecordedChaosPerks(_perkTree);
	local recordedMap = {};
	foreach (perkID in recorded) recordedMap[perkID] <- true;
	local wildOwnership = ::Brotherhood.getWildPerkOwnership(_perkTree);

	// Native, Wild, Survivability, Doctrine, and DUO perks take precedence.
	// A Chaos perk with the same displayed name is the duplicate and is removed.
	local usedNames = {};
	foreach (name, value in wildOwnership.Names) usedNames[name] <- true;
	foreach (perkID, perk in _perkTree.getPerks())
	{
		if (perkID in recordedMap) continue;
		usedNames[::Brotherhood.getChaosPerkDisplayName(perkID)] <- true;
	}

	local kept = [];
	local removed = [];
	local removedFromTree = [];
	foreach (perkID in recorded)
	{
		if (!_perkTree.hasPerk(perkID)) continue;
		local name = ::Brotherhood.getChaosPerkDisplayName(perkID);
		if (name in usedNames)
		{
			removed.push(perkID);
			// If Wild owns this exact ID, only remove Chaos ownership. There is one
			// tree entry and it must remain as the Wild perk. Same-name counterparts
			// are separate entries, so the Chaos copy itself is removed.
			if (!(perkID in wildOwnership.IDs)) removedFromTree.push(perkID);
			continue;
		}
		usedNames[name] <- true;
		kept.push(perkID);
	}

	foreach (perkID in removedFromTree) _perkTree.removePerk(perkID);
	::Brotherhood.storeRecordedChaosPerks(_perkTree, kept);
	if (removed.len() != 0)
	{
		if (::Brotherhood.FleshcraftDebugLogging) ::logInfo("[Brotherhood][ChaosGeneration] Removed duplicate-name Chaos perks: [" + ::Brotherhood.formatIDsForLog(removed) + "]");
	}
	return kept;
}

::Brotherhood.fillChaosPerksToFinalTarget <- function( _perkTree )
{
	local chaosPerks = ::Brotherhood.removeDuplicateRecordedChaosPerks(_perkTree);
	local nonChaosCount = _perkTree.getPerks().len() - chaosPerks.len();
	local targetChaosCount = ::Math.min(::Brotherhood.RESERVED_CHAOS_SLOTS, ::Math.max(0, ::Brotherhood.FINAL_PERK_TARGET - nonChaosCount));
	local usedNames = {};
	foreach (perkID, perk in _perkTree.getPerks()) usedNames[::Brotherhood.getChaosPerkDisplayName(perkID)] <- true;

	local pool = [];
	local addCandidate = function( _entry, _isWeaponMastery )
	{
		if (_perkTree.hasPerk(_entry.ID)) return;
		if (!::Brotherhood.isValidWildPerkDefinition(_entry.ID)) return;
		local name = ::Brotherhood.getChaosPerkDisplayName(_entry.ID);
		if (name in usedNames) return;
		usedNames[name] <- true;
		pool.push({ ID = _entry.ID, Tier = _entry.Tier, IsWeaponMastery = _isWeaponMastery });
	}
	foreach (entry in ::Brotherhood.ChaosPerkPool) addCandidate(entry, false);
	foreach (entry in ::Brotherhood.ChaosWeaponMasteryPool) addCandidate(entry, true);

	local newlyAdded = [];
	local masteryCount = ::Brotherhood.countWeaponMasteriesInTree(_perkTree);
	while (chaosPerks.len() < targetChaosCount && pool.len() != 0 && _perkTree.getPerks().len() < ::Brotherhood.FINAL_PERK_TARGET)
	{
		local entry = pool.remove(::Brotherhood.selectChaosPoolIndex(pool, masteryCount));
		_perkTree.addPerk(entry.ID, entry.Tier);
		if (_perkTree.hasPerk(entry.ID))
		{
			chaosPerks.push(entry.ID);
			newlyAdded.push(entry.ID);
			if (entry.IsWeaponMastery) ++masteryCount;
		}
	}

	::Brotherhood.storeRecordedChaosPerks(_perkTree, chaosPerks);
	_perkTree.m.BH_FinalGeneratedPerkCount <- _perkTree.getPerks().len();
	_perkTree.m.BH_ChaosReconciled <- true;
	if (::Brotherhood.FleshcraftDebugLogging) ::logInfo(
		"[Brotherhood][ChaosGeneration] Added " + newlyAdded.len().tostring() + " new perk(s); retained " + chaosPerks.len().tostring() + "/" + targetChaosCount.tostring()
		+ " independently usable, name-unique Chaos perks: [" + ::Brotherhood.formatIDsForLog(chaosPerks) + "]"
		+ "; weapon masteries: " + masteryCount.tostring()
		+ "; final unique count: " + _perkTree.getPerks().len().tostring()
	);
}
