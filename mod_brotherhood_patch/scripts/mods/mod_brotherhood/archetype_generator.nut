::Brotherhood.selectTemporaryArchetypes <- function()
{
	local pool = ::Brotherhood.TemporaryArchetypeTestPool.filter(@(_, _archetype) ::Brotherhood.isArchetypeEnabled(_archetype.ID));
	local count = ::Math.min(::Brotherhood.GeneratedArchetypeCount, pool.len());

	if (count == 0) return [];

	local seen = {};
	foreach (archetype in pool)
	{
		if (archetype.ID in seen)
		{
			throw "Brotherhood five-archetype test pool contains duplicate ID: " + archetype.ID;
		}

		seen[archetype.ID] <- true;
	}

	if (::Brotherhood.TestingMode && ::Brotherhood.DebugForceCurrentObsidianArchetypes)
	{
		local debugSpawn = ::Brotherhood.getCurrentObsidianDebugSpawn();
		local forced = [];
		local forcedSeen = {};
		foreach (archetypeID in debugSpawn.ArchetypeIDs)
		{
			if (!::Brotherhood.isArchetypeEnabled(archetypeID)) continue;
			if (archetypeID in forcedSeen)
			{
				throw "Brotherhood current Obsidian debug list contains duplicate ID: " + archetypeID;
			}

			local found = null;
			foreach (archetype in pool)
			{
				if (archetype.ID != archetypeID) continue;
				found = archetype;
				break;
			}

			if (found == null)
			{
				throw "Brotherhood current Obsidian debug archetype is missing from the test pool: " + archetypeID;
			}

			forcedSeen[archetypeID] <- true;
			forced.push(found);
		}

		::logInfo("[Brotherhood][OBSIDIAN DEBUG SPAWN] Forced archetypes: [" + ::Brotherhood.formatSelectedDefinitionsForLog(forced) + "]");
		return forced;
	}

	local selected = [];
	for (local i = 0; i < count; ++i)
	{
		// Removing the chosen entry makes every ordered sample of five distinct
		// archetypes equally likely and prevents selecting an archetype twice.
		selected.push(pool.remove(::Math.rand(0, pool.len() - 1)));
	}

	return selected;
}

::Brotherhood.logCurrentObsidianDebugCatalog <- function( _perkTree, _archetypes, _duos )
{
	foreach (archetype in _archetypes)
	{
		local entries = [];
		foreach (perk in _perkTree.getPerks())
		{
			if (!("BH_NativePerkSources" in _perkTree.m) || !(perk.ID in _perkTree.m.BH_NativePerkSources)) continue;
			if (_perkTree.m.BH_NativePerkSources[perk.ID].find(archetype.ID) == null) continue;
			entries.push("T" + (perk.Row + 1) + " " + perk.ID);
		}
		::logInfo("[Brotherhood][OBSIDIAN DEBUG CATALOG] " + archetype.Name + " (" + archetype.ID + "): [" + ::Brotherhood.formatIDsForLog(entries) + "]");
	}
	local duoEntries = [];
	foreach (duo in _duos) duoEntries.push("T" + duo.Tier + " " + duo.ID);
	::logInfo("[Brotherhood][OBSIDIAN DEBUG CATALOG] Direct DUOs: [" + ::Brotherhood.formatIDsForLog(duoEntries) + "]");
}

::Brotherhood.selectArmorDoctrines <- function( _random = null )
{
	local count = ::Brotherhood.ArmorDoctrineRollCount;
	local pool = clone ::Brotherhood.ArmorDoctrinePool;

	if (pool.len() < count)
	{
		throw "Brotherhood Armor Doctrine pool contains fewer than " + count.tostring() + " doctrines";
	}

	local seen = {};
	foreach (doctrine in pool)
	{
		if (doctrine.ID in seen)
		{
			throw "Brotherhood Armor Doctrine pool contains duplicate ID: " + doctrine.ID;
		}

		seen[doctrine.ID] <- true;
	}

	local selected = [];
	for (local i = 0; i < count; ++i)
	{
		local index = _random == null ? ::Math.rand(0, pool.len() - 1) : ::Math.floor(_random() * pool.len()).tointeger();
		if (index >= pool.len()) index = pool.len() - 1;
		selected.push(pool.remove(index));
	}

	return selected;
}

::Brotherhood.getArchetypeGroup <- function( _archetype )
{
	local group = ::DynamicPerks.PerkGroups.findById(_archetype.ID);
	if (group == null)
	{
		throw "Brotherhood five-archetype generator could not find perk group: " + _archetype.ID;
	}

	return group;
}

::Brotherhood.countUniqueArchetypePerks <- function( _archetypes )
{
	local uniquePerks = {};

	foreach (archetype in _archetypes)
	{
		foreach (row in ::Brotherhood.getArchetypeGroup(archetype).getTree())
		{
			foreach (perkID in row)
			{
				uniquePerks[perkID] <- true;
			}
		}
	}

	return uniquePerks.len();
}

::Brotherhood.formatSelectedDefinitionsForLog <- function( _definitions )
{
	local ret = "";
	foreach (i, definition in _definitions)
	{
		if (i != 0) ret += ", ";
		ret += definition.Name + " (" + definition.ID + ")";
	}

	return ret;
}

::Brotherhood.formatIDsForLog <- function( _ids )
{
	if (_ids.len() == 0) return "none";

	local ret = "";
	foreach (i, id in _ids)
	{
		if (i != 0) ret += ", ";
		ret += id;
	}

	return ret;
}

::Brotherhood.buildNativePerkSourceMap <- function( _perkTree, _archetypes )
{
	local ret = {};
	foreach (perk in _perkTree.getPerks())
	{
		local perkDefinition = ::Const.Perks.findById(perk.ID);
		if (perkDefinition == null || !("PerkGroupIDs" in perkDefinition)) continue;

		foreach (archetype in _archetypes)
		{
			if (perkDefinition.PerkGroupIDs.find(archetype.ID) == null) continue;
			if (!(perk.ID in ret)) ret[perk.ID] <- [];
			if (ret[perk.ID].find(archetype.ID) == null) ret[perk.ID].push(archetype.ID);
		}
	}
	return ret;
}

::Brotherhood.storeSelectedNativeArchetypes <- function( _perkTree, _archetypes )
{
	local actor = _perkTree.getActor();
	if (::MSU.isNull(actor)) return;

	local serialized = "";
	foreach (i, archetype in _archetypes)
	{
		if (i != 0) serialized += "|";
		serialized += archetype.ID;
	}

	actor.getFlags().set("BH_SelectedNativeArchetypes", serialized);
}

::Brotherhood.storeGeneratedPerkTreeDebugData <- function( _perkTree, _archetypes, _doctrines, _uniqueArchetypePerks )
{
	if ("BH_SelectedArchetypes" in _perkTree.m) _perkTree.m.BH_SelectedArchetypes = _archetypes;
	else _perkTree.m.BH_SelectedArchetypes <- _archetypes;

	if ("BH_SelectedArmorDoctrines" in _perkTree.m) _perkTree.m.BH_SelectedArmorDoctrines = _doctrines;
	else _perkTree.m.BH_SelectedArmorDoctrines <- _doctrines;

	if ("BH_UniqueArchetypePerkCount" in _perkTree.m) _perkTree.m.BH_UniqueArchetypePerkCount = _uniqueArchetypePerks;
	else _perkTree.m.BH_UniqueArchetypePerkCount <- _uniqueArchetypePerks;

	local nativePerkSources = "BH_NativePerkSources" in _perkTree.m
		? _perkTree.m.BH_NativePerkSources
		: ::Brotherhood.buildNativePerkSourceMap(_perkTree, _archetypes);
	if ("BH_NativePerkSources" in _perkTree.m) _perkTree.m.BH_NativePerkSources = nativePerkSources;
	else _perkTree.m.BH_NativePerkSources <- nativePerkSources;

	::Brotherhood.storeSelectedNativeArchetypes(_perkTree, _archetypes);
}

::Brotherhood.logGeneratedPerkTree <- function( _perkTree, _duoPerkIDs )
{
	if (!("BH_SelectedArchetypes" in _perkTree.m)) return;

	local actor = _perkTree.getActor();
	local actorName = ::MSU.isNull(actor) ? "unknown character" : actor.getName();

	::logInfo(
		"[Brotherhood][FiveArchetypeGeneration] " + actorName
		+ " selected archetypes: [" + ::Brotherhood.formatSelectedDefinitionsForLog(_perkTree.m.BH_SelectedArchetypes) + "]"
		+ "; Armor Doctrines: [" + ::Brotherhood.formatSelectedDefinitionsForLog(_perkTree.m.BH_SelectedArmorDoctrines) + "]"
		+ "; duo perks: [" + ::Brotherhood.formatIDsForLog(_duoPerkIDs) + "]"
		+ "; unique archetype perks: " + _perkTree.m.BH_UniqueArchetypePerkCount.tostring()
		+ "; pre-Wild tree perks including survivability, doctrines, and duos: " + _perkTree.getPerks().len().tostring()
	);
}

::Brotherhood.generateFiveArchetypePerkTree <- function( _perkTree )
{
	// Survivability is an always-present support group and does not count as
	// one of the five native archetypes selected below.
	_perkTree.addPerkGroup("pg.bh_survival");

	if (!::Brotherhood.hasEnabledArchetypes())
	{
		local doctrines = ::Brotherhood.selectArmorDoctrines();
		foreach (doctrine in doctrines)
		{
			_perkTree.addPerk(doctrine.ID, 6);
		}

		if ("BH_SelectedArmorDoctrines" in _perkTree.m) _perkTree.m.BH_SelectedArmorDoctrines = doctrines;
		else _perkTree.m.BH_SelectedArmorDoctrines <- doctrines;

		local actor = _perkTree.getActor();
		local actorName = ::MSU.isNull(actor) ? "unknown character" : actor.getName();
		::logInfo(
			"[Brotherhood][ARCHETYPE KEEP-LIST] " + actorName
			+ " received Survivability and Armor Doctrines: ["
			+ ::Brotherhood.formatSelectedDefinitionsForLog(doctrines) + "]; awaiting approved archetype IDs."
		);
		return;
	}

	local selected = ::Brotherhood.selectTemporaryArchetypes(_perkTree);
	if ("BH_NativePerkSources" in _perkTree.m)
	{
		_perkTree.m.BH_NativePerkSources = {};
	}
	else
	{
		_perkTree.m.BH_NativePerkSources <- {};
	}
	foreach (archetype in selected)
	{
		// Dynamic Perks' native addPerkGroup() reads the package's getTree(),
		// retains each row index, and ignores perk IDs already in the tree.
		::Brotherhood.getArchetypeGroup(archetype);
		_perkTree.m.BH_CapturingNativeArchetypeID <- archetype.ID;
		_perkTree.addPerkGroup(archetype.ID);
		delete _perkTree.m.BH_CapturingNativeArchetypeID;
		if (::Brotherhood.TestingMode && ::Brotherhood.DebugForceCurrentObsidianArchetypes)
		{
			::logInfo("[Brotherhood][OBSIDIAN DEBUG TREE] " + archetype.Name + " (" + archetype.ID + ") inserted=" + (_perkTree.hasPerkGroup(archetype.ID) ? "true" : "false") + ".");
		}
	}

	// DUOs are evaluated only after all five complete native packages exist.
	// Their centralized registry also verifies the mechanical feeder perks.
	::Brotherhood.addCompatibleDuoPerks(_perkTree);

	if (::Brotherhood.TestingMode && ::Brotherhood.DebugForceCurrentObsidianArchetypes)
	{
		local debugSpawn = ::Brotherhood.getCurrentObsidianDebugSpawn();
		foreach (duo in debugSpawn.DuoPerks)
		{
			_perkTree.addPerk(duo.ID, duo.Tier);
		}
		::Brotherhood.logCurrentObsidianDebugCatalog(_perkTree, selected, debugSpawn.DuoPerks);
		::logInfo("[Brotherhood][OBSIDIAN DEBUG SPAWN] Added the current direct test DUO batch.");
	}

	local doctrines = ::Brotherhood.selectArmorDoctrines();
	foreach (doctrine in doctrines)
	{
		// Armor Doctrines are direct tier-6 perks, not a perk group.
		_perkTree.addPerk(doctrine.ID, 6);
	}

	local uniqueArchetypePerks = ::Brotherhood.countUniqueArchetypePerks(selected);
	::Brotherhood.storeGeneratedPerkTreeDebugData(_perkTree, selected, doctrines, uniqueArchetypePerks);
}
