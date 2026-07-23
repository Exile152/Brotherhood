::Brotherhood.getWildActorName <- function( _perkTree )
{
	local actor = _perkTree.getActor();
	return ::MSU.isNull(actor) ? "unknown character" : actor.getName();
}

::Brotherhood.getArchetypeDefinitionByID <- function( _id )
{
	foreach (definition in ::Brotherhood.WildArchetypeRegistry)
	{
		if (definition.ID == _id) return definition;
	}
	return null;
}

::Brotherhood.isArchetypeGroupID <- function( _id )
{
	return ::Brotherhood.getArchetypeDefinitionByID(_id) != null;
}

::Brotherhood.isArchetypeEnabled <- function( _id )
{
	return ::Brotherhood.ArchetypesEnabled
		&& typeof _id == "string"
		&& ::Brotherhood.EnabledArchetypeIDs.find(_id) != null;
}

::Brotherhood.hasEnabledArchetypes <- function()
{
	return ::Brotherhood.ArchetypesEnabled && ::Brotherhood.EnabledArchetypeIDs.len() != 0;
}

::Brotherhood.shouldInitializeArchetypeModule <- function( _ids )
{
	if (!::Brotherhood.hasEnabledArchetypes()) return false;
	foreach (id in _ids)
	{
		if (::Brotherhood.isArchetypeEnabled(id)) return true;
	}
	return false;
}

::Brotherhood.validateEnabledArchetypes <- function()
{
	local seen = {};
	foreach (id in ::Brotherhood.EnabledArchetypeIDs)
	{
		if (typeof id != "string" || id == "") throw "Brotherhood enabled archetype ID must be a non-empty string";
		if (id in seen) throw "Brotherhood enabled archetype list contains duplicate ID: " + id;
		seen[id] <- true;
		if (::Brotherhood.getArchetypeDefinitionByID(id) == null) throw "Brotherhood enabled archetype is missing from the registry: " + id;

		local inPool = false;
		foreach (definition in ::Brotherhood.TemporaryArchetypeTestPool)
		{
			if (definition.ID == id) { inPool = true; break; }
		}
		if (!inPool) throw "Brotherhood enabled archetype is missing from the generation pool: " + id;
	}
}

::Brotherhood.restoreNativeArchetypeProvenance <- function( _perkTree )
{
	if ("BH_SelectedArchetypes" in _perkTree.m && "BH_NativePerkSources" in _perkTree.m) return;

	local selected = [];
	local actor = _perkTree.getActor();
	if (!::MSU.isNull(actor) && actor.getFlags().has("BH_SelectedNativeArchetypes"))
	{
		foreach (archetypeID in ::split(actor.getFlags().get("BH_SelectedNativeArchetypes"), "|"))
		{
			local definition = ::Brotherhood.getArchetypeDefinitionByID(archetypeID);
			if (definition != null) selected.push({ ID = definition.ID, Name = definition.Name });
		}
	}
	else if (::Brotherhood.TestingMode && ::Brotherhood.DebugForceCurrentObsidianArchetypes)
	{
		// Compatibility for forced-debug characters generated before native
		// archetype provenance was stored on the actor.
		foreach (archetypeID in ::Brotherhood.getCurrentObsidianDebugSpawn().ArchetypeIDs)
		{
			local definition = ::Brotherhood.getArchetypeDefinitionByID(archetypeID);
			if (definition != null) selected.push({ ID = definition.ID, Name = definition.Name });
		}
	}
	if (selected.len() == 0) return;

	if ("BH_SelectedArchetypes" in _perkTree.m) _perkTree.m.BH_SelectedArchetypes = selected;
	else _perkTree.m.BH_SelectedArchetypes <- selected;

	local nativePerkSources = ::Brotherhood.buildNativePerkSourceMap(_perkTree, selected);
	if ("BH_NativePerkSources" in _perkTree.m) _perkTree.m.BH_NativePerkSources = nativePerkSources;
	else _perkTree.m.BH_NativePerkSources <- nativePerkSources;

	if (::Brotherhood.FleshcraftDebugLogging) ::logInfo("[Brotherhood][ArchetypeProvenance] Restored native archetype ownership after perk-tree load.");
}

::Brotherhood.getPerkArchetypeProvenance <- function( _perkTree, _perkID )
{
	::Brotherhood.restoreNativeArchetypeProvenance(_perkTree);
	local ret = { Native = [], Wild = [] };
	local seenNative = {};
	local seenWild = {};

	if ("BH_NativePerkSources" in _perkTree.m && _perkID in _perkTree.m.BH_NativePerkSources)
	{
		foreach (sourceID in _perkTree.m.BH_NativePerkSources[_perkID])
		{
			if (sourceID in seenNative) continue;
			local definition = ::Brotherhood.getArchetypeDefinitionByID(sourceID);
			if (definition == null) continue;
			seenNative[sourceID] <- true;
			ret.Native.push({ ID = sourceID, Name = definition.Name });
		}
	}

	if ("BH_WildSources" in _perkTree.m)
	{
		foreach (record in _perkTree.m.BH_WildSources)
		{
			if (record.AddedPerkIDs.find(_perkID) == null || record.SourceArchetypeID in seenWild) continue;
			seenWild[record.SourceArchetypeID] <- true;
			ret.Wild.push({ ID = record.SourceArchetypeID, Name = record.SourceArchetypeName });
		}
	}

	return ret;
}

::Brotherhood.decoratePerkTreeUIWithArchetypeProvenance <- function( _perkTree, _uiData )
{
	::Brotherhood.restoreNativeArchetypeProvenance(_perkTree);
	local rolledArchetypes = [];
	if ("BH_SelectedArchetypes" in _perkTree.m)
	{
		foreach (source in _perkTree.m.BH_SelectedArchetypes)
		{
			local group = ::DynamicPerks.PerkGroups.findById(source.ID);
			rolledArchetypes.push({
				ID = source.ID,
				Name = source.Name,
				Icon = group == null ? "ui/icons/special.png" : group.getIcon()
			});
		}
	}

	foreach (row in _uiData)
	{
		foreach (perk in row)
		{
			// Repeat the tiny five-entry manifest on each perk because the vanilla
			// character-screen bridge transports the tree rows but has no dedicated
			// metadata object. The UI reads the first available copy.
			perk.BH_RolledArchetypes <- rolledArchetypes;
			local provenance = ::Brotherhood.getPerkArchetypeProvenance(_perkTree, perk.ID);
			local nativeIDs = [];
			local wildIDs = [];
			foreach (source in provenance.Native) nativeIDs.push(source.ID);
			foreach (source in provenance.Wild) wildIDs.push(source.ID);
			perk.BH_NativeArchetypeIDs <- nativeIDs;
			perk.BH_WildArchetypeIDs <- wildIDs;
			if (provenance.Native.len() == 0 && provenance.Wild.len() == 0) continue;

			// Replace Dynamic Perks' inferred complete-group list with the exact
			// native and Wild sources rolled for this perk. The existing overlay
			// then highlights every perk sharing any of those rolled archetypes.
			// Perk definitions can belong to many framework groups globally, but
			// this character only owns the sources recorded by Brotherhood. Showing
			// unrelated groups here (for example Anticipation's Agile membership on
			// a Marksman) makes global eligibility look like character ownership.
			local groupIDs = [];
			foreach (source in provenance.Native)
			{
				if (groupIDs.find(source.ID) == null) groupIDs.push(source.ID);
			}
			foreach (source in provenance.Wild)
			{
				if (groupIDs.find(source.ID) == null) groupIDs.push(source.ID);
			}
			perk.PerkGroupIDs = groupIDs;
		}
	}

	return _uiData;
}

::Brotherhood.removeGenericPerkGroupHints <- function( _tooltip, _perkDefinition )
{
	if (_tooltip == null) return _tooltip;
	return _tooltip.filter(function( _index, _entry )
	{
		if (!("type" in _entry && _entry.type == "hint"
			&& "text" in _entry && typeof _entry.text == "string")) return true;
		local text = _entry.text.tolower();
		if (text.find("assigned archetype") != null
			|| text.find("assigned wild archetype") != null
			|| text.find("archetypes with this perk") != null) return true;
		return text.find("perk group") == null && text.find("archetype") == null;
	});
}

::Brotherhood.getArchetypesContainingPerk <- function( _perkID )
{
	local ret = [];
	local targetName = ::Brotherhood.getChaosPerkDisplayName(_perkID);
	foreach (definition in ::Brotherhood.WildArchetypeRegistry)
	{
		if (!::Brotherhood.isArchetypeEnabled(definition.ID)) continue;
		local group = ::DynamicPerks.PerkGroups.findById(definition.ID);
		if (group == null) continue;

		local containsMatchingPerk = false;
		foreach (row in group.getTree())
		{
			foreach (groupPerkID in row)
			{
				// Chaos uses vanilla perks while some archetypes use Brotherhood
				// counterparts with the same player-facing name and mechanic.
				if (::Brotherhood.getChaosPerkDisplayName(groupPerkID) == targetName)
				{
					containsMatchingPerk = true;
					break;
				}
			}
			if (containsMatchingPerk) break;
		}
		if (containsMatchingPerk) ret.push({ ID = definition.ID, Name = definition.Name });
	}
	return ret;
}

::Brotherhood.isChaosPerkForActor <- function( _perkTree, _actor, _perkID )
{
	if ("BH_ChaosPerks" in _perkTree.m && _perkTree.m.BH_ChaosPerks.find(_perkID) != null) return true;
	if (::MSU.isNull(_actor) || !_actor.getFlags().has("BH_ChaosPerks")) return false;
	return ::split(_actor.getFlags().get("BH_ChaosPerks"), "|").find(_perkID) != null;
}

::Brotherhood.sanitizeWheelPerkTreeGroups <- function( _perkTree )
{
	_perkTree.m.PerkGroupIDs = _perkTree.m.PerkGroupIDs.filter(@(_, _id) ::Brotherhood.isAllowedWheelGroupID(_id));
	foreach (perk in _perkTree.getPerks())
	{
		if (!("PerkGroupIDs" in perk) || perk.PerkGroupIDs == null) continue;
		perk.PerkGroupIDs = perk.PerkGroupIDs.filter(@(_, _id) ::Brotherhood.isAllowedWheelGroupID(_id));
	}
}

// DUO perks require every listed archetype at once. They must never be shown
// as ordinary, independent perk-group memberships in the player-facing UI.
::Brotherhood.DuoPerkArchetypeIDs <- {
	"perk.bh_ambition": ["pg.bh_prodigy", "pg.bh_braggart"],
	"perk.bh_bladed_arm": ["pg.bh_brawler", "pg.bh_knave"],
	"perk.bh_parry_a_gun": ["pg.bh_artillerist", "pg.bh_swashbuckler"],
	"perk.bh_gods_eyes": ["pg.bh_duelist", "pg.bh_marksman"],
	"perk.bh_swords_and_sandals": ["pg.bh_bard", "pg.bh_gladiator"],
	"perk.bh_scholarship": ["pg.bh_blueblood", "pg.bh_prodigy"],
	"perk.bh_bloodletting": ["pg.bh_plague_doctor", "pg.bh_flagellant"],
	"perk.bh_dragonet": ["pg.bh_dragon", "pg.bh_impish"],
	"perk.bh_learning_devil": ["pg.bh_prodigy", "pg.bh_impish"]
};

::Brotherhood.decorateDuoPerkTooltip <- function( _tooltip, _perkID )
{
	if (_tooltip == null || !(_perkID in ::Brotherhood.DuoPerkArchetypeIDs)) return _tooltip;

	local perkDefinition = ::Const.Perks.findById(_perkID);
	if (perkDefinition != null && "PerkGroupIDs" in perkDefinition)
	{
		_tooltip = ::Brotherhood.removeGenericPerkGroupHints(_tooltip, perkDefinition);
	}

	local links = "";
	foreach (i, groupID in ::Brotherhood.DuoPerkArchetypeIDs[_perkID])
	{
		local group = ::DynamicPerks.PerkGroups.findById(groupID);
		local name = group == null ? groupID : group.getName();
		if (i != 0) links += " + ";
		links += format("[%s|PerkGroup+%s]", name, groupID);
	}

	_tooltip.insert(2, {
		id = 3,
		type = "hint",
		icon = "ui/icons/special.png",
		text = ::DynamicPerks.Mod.Tooltips.parseString(links + " ") + ::MSU.Text.colorPositive("Duo Perk")
	});
	return _tooltip;
}

::Brotherhood.decoratePerkTooltipWithArchetypeProvenance <- function( _tooltip, _entityID, _perkID )
{
	if (_tooltip == null) return _tooltip;
	// DPF builds these footer rows from global metadata. Strip them by meaning,
	// not by array position, before adding Brotherhood's exact assignment label.
	_tooltip = ::Brotherhood.removeGenericPerkGroupHints(_tooltip, null);
	if (_perkID in ::Brotherhood.DuoPerkArchetypeIDs) return ::Brotherhood.decorateDuoPerkTooltip(_tooltip, _perkID);
	local actor = ::Tactical.getEntityByID(_entityID);
	if (actor == null) return _tooltip;
	local perkTree = actor.getPerkTree();
	if (!::Brotherhood.isTestingPerkTree(perkTree)) return _tooltip;

	local provenance = ::Brotherhood.getPerkArchetypeProvenance(perkTree, _perkID);
	local isChaos = ::Brotherhood.isChaosPerkForActor(perkTree, actor, _perkID);
	if (provenance.Native.len() == 0 && provenance.Wild.len() == 0 && !isChaos) return _tooltip;

	local insertIndex = 2;
	if (isChaos)
	{
		_tooltip.insert(insertIndex++, { id = 3, type = "hint", icon = "ui/icons/special.png", text = ::MSU.Text.colorPositive("Chaos Perk") });
	}

	foreach (source in provenance.Native)
	{
		local group = ::DynamicPerks.PerkGroups.findById(source.ID);
		_tooltip.insert(insertIndex++, {
			id = 3,
			type = "hint",
			icon = group == null ? "ui/icons/special.png" : group.getIcon(),
			text = ::MSU.Text.colorPositive("Assigned Archetype") + ": "
				+ ::DynamicPerks.Mod.Tooltips.parseString(format("[%s|PerkGroup+%s]", source.Name, source.ID))
		});
	}

	if (provenance.Wild.len() != 0)
	{
		_tooltip.insert(insertIndex++, {
			id = 3,
			type = "hint",
			icon = "ui/icons/special.png",
			text = ::MSU.Text.colorPositive("Wild Perk")
		});
	}

	// This is deliberately broader than assignment provenance: it answers where
	// the perk could have appeared. Wild is presented as a perk source, not as a
	// newly assigned archetype. Keep all possible memberships in one row.
	local membershipLinks = "";
	local memberships = ::Brotherhood.getArchetypesContainingPerk(_perkID);
	foreach (index, source in memberships)
	{
		if (index != 0) membershipLinks += ", ";
		membershipLinks += format("[%s|PerkGroup+%s]", source.Name, source.ID);
	}
	if (memberships.len() != 0)
	{
		_tooltip.insert(insertIndex++, {
			id = 4,
			type = "hint",
			icon = "ui/icons/special.png",
			text = "Archetypes with this perk: " + ::DynamicPerks.Mod.Tooltips.parseString(membershipLinks)
		});
	}

	return _tooltip;
}

::Brotherhood.registerWildPerkTooltip <- function()
{
	::DynamicPerks.Mod.Tooltips.setTooltips({
		BrotherhoodWildPerk = ::MSU.Class.CustomTooltip(function( _data )
		{
			local source = ::Brotherhood.getArchetypeDefinitionByID(_data.ExtraData);
			local sourceName = source == null ? "Unknown" : source.Name;
			local sourceID = source == null ? "" : source.ID;
			local sourceText = source == null
				? "The source archetype is unavailable."
				: ::DynamicPerks.Mod.Tooltips.parseString(format("Assigned later from the [%s|PerkGroup+%s] archetype.", sourceName, sourceID));

			return [
				{ id = 1, type = "title", text = sourceName + " Wild Perk" },
				{ id = 2, type = "description", text = "Wild perks are normal archetype perks assigned after the character's native archetypes." },
				{ id = 3, type = "text", icon = "ui/icons/special.png", text = sourceText },
				{ id = 4, type = "text", icon = "ui/icons/special.png", text = "Wild sources are weighted by the recruit's still-unused Wheel of Fortune signals." }
			];
		})
	});
}

::Brotherhood.getNativeArchetypeIDMap <- function( _perkTree )
{
	local nativeIDs = {};
	if (!("BH_SelectedArchetypes" in _perkTree.m)) return nativeIDs;

	foreach (archetype in _perkTree.m.BH_SelectedArchetypes)
	{
		if ("ID" in archetype) nativeIDs[archetype.ID] <- true;
	}

	return nativeIDs;
}

::Brotherhood.isWildEligibleArchetype <- function( _definition, _nativeIDs, _allowDormant = false )
{
	if (!("WildEligible" in _definition) || !_definition.WildEligible) return false;
	if (!("ID" in _definition) || typeof _definition.ID != "string" || _definition.ID == "") return false;
	if (!_allowDormant && !::Brotherhood.isArchetypeEnabled(_definition.ID)) return false;
	if (_definition.ID in _nativeIDs) return false;
	return true;
}

::Brotherhood.buildWildSourceCandidates <- function( _perkTree )
{
	local candidates = [];
	local seen = {};
	local nativeIDs = ::Brotherhood.getNativeArchetypeIDMap(_perkTree);
	local allowDormant = "BH_SelectedFleshcraftParents" in _perkTree.m;
	local snapshot = "BH_WheelSnapshot" in _perkTree.m ? _perkTree.m.BH_WheelSnapshot : ::Brotherhood.captureWheelSnapshot(_perkTree);
	local factors = "BH_WheelRemainingSignalFactors" in _perkTree.m ? _perkTree.m.BH_WheelRemainingSignalFactors : {};

	foreach (definition in ::Brotherhood.WildArchetypeRegistry)
	{
		if (!::Brotherhood.isWildEligibleArchetype(definition, nativeIDs, allowDormant)) continue;
		if (definition.ID in seen)
		{
			if (::Brotherhood.FleshcraftDebugLogging) ::logWarning("[Brotherhood][WildGeneration] Ignoring duplicate Wild registry ID: " + definition.ID);
			continue;
		}

		seen[definition.ID] <- true;
		if (::DynamicPerks.PerkGroups.findById(definition.ID) == null)
		{
			if (::Brotherhood.FleshcraftDebugLogging) ::logWarning("[Brotherhood][WildGeneration] Ignoring missing Wild source group: " + definition.ID);
			continue;
		}

		local profile = ::Brotherhood.getWheelProfileByID(definition.ID);
		if (profile == null) continue;
		local result = ::Brotherhood.scoreWheelProfile(profile, snapshot, factors);
		if (!result.Eligible) continue;
		local candidate = clone definition;
		candidate.BH_WheelScore <- result.Score;
		candidate.BH_WheelReasons <- result.Reasons;
		candidates.push(candidate);
	}

	return candidates;
}

::Brotherhood.isValidWildPerkDefinition <- function( _perkID )
{
	if (typeof _perkID != "string" || _perkID == "") return false;
	local perk = ::Const.Perks.findById(_perkID);
	if (perk == null || !("PerkGroupIDs" in perk) || typeof perk.PerkGroupIDs != "array") return false;

	// Dynamic Perks' safe addPerk() path queries every declared source group.
	// Reject malformed metadata before insertion instead of letting it crash.
	foreach (groupID in perk.PerkGroupIDs)
	{
		if (::DynamicPerks.PerkGroups.findById(groupID) == null) return false;
	}

	return true;
}

::Brotherhood.getFleshcraftWildExclusionMap <- function( _perkTree )
{
	local excluded = {};
	// Spine status is constitutional: no spine from any authored parent may
	// ever enter a tree through Wild.
	foreach (templateID, template in ::Brotherhood.FleshcraftTemplates)
		foreach (perkID in template.spine_pool) excluded[perkID] <- "spine:" + templateID;
	// A selected parent owns its complete authored genome, not only the five
	// seats that happened to be dealt. Its whole pool is therefore unavailable
	// as Wild material for this recruit.
	if ("BH_SelectedFleshcraftParents" in _perkTree.m)
	{
		foreach (parent in _perkTree.m.BH_SelectedFleshcraftParents)
		{
			if (!(parent.TemplateID in ::Brotherhood.FleshcraftTemplates)) continue;
			local template = ::Brotherhood.FleshcraftTemplates[parent.TemplateID];
			foreach (pool in [template.spine_pool, template.flesh_pool])
				foreach (perkID in pool) excluded[perkID] <- "selected_parent:" + parent.TemplateID;
		}
	}
	return excluded;
}

::Brotherhood.collectValidMissingWildPerks <- function( _perkTree, _source )
{
	local group = ::DynamicPerks.PerkGroups.findById(_source.ID);
	if (group == null) return [];

	local tree = group.getTree();
	if (typeof tree != "array") return [];

	local ret = [];
	local seen = {};
	local fleshcraftExcluded = ::Brotherhood.getFleshcraftWildExclusionMap(_perkTree);
	foreach (rowIndex, row in tree)
	{
		if (typeof row != "array") continue;
		foreach (perkID in row)
		{
			if (typeof perkID != "string" || perkID == "")
			{
				if (::Brotherhood.FleshcraftDebugLogging) ::logWarning("[Brotherhood][WildGeneration] " + _source.ID + " contains a non-string or empty perk ID");
				continue;
			}
			if (perkID in seen) continue;
			seen[perkID] <- true;
			if (_perkTree.hasPerk(perkID)) continue;
			if (perkID in fleshcraftExcluded)
			{
				if (::Brotherhood.FleshcraftDebugLogging) ::logInfo("[Brotherhood][WildGeneration] Excluded " + perkID + " from " + _source.ID + " because " + fleshcraftExcluded[perkID]);
				continue;
			}
			if (!::Brotherhood.isValidWildPerkDefinition(perkID))
			{
				if (::Brotherhood.FleshcraftDebugLogging) ::logWarning("[Brotherhood][WildGeneration] " + _source.ID + " contains invalid perk ID: " + perkID);
				continue;
			}

			ret.push({ ID = perkID, Tier = rowIndex + 1 });
		}
	}

	return ret;
}

::Brotherhood.selectWildSource <- function( _candidates )
{
	local weighted = [];
	foreach (candidate in _candidates)
	{
		weighted.push({ Definition = candidate, Result = { Score = candidate.BH_WheelScore } });
	}
	return _candidates.remove(::Brotherhood.selectWeightedWheelCandidate(weighted));
}

::Brotherhood.selectWildContributionSize <- function( _maximum )
{
	return ::Math.rand(1, _maximum);
}

::Brotherhood.selectWildPerkSubset <- function( _missingPerks, _count )
{
	local pool = clone _missingPerks;
	local selected = [];
	for (local i = 0; i < _count; ++i)
	{
		selected.push(pool.remove(::Math.rand(0, pool.len() - 1)));
	}
	return selected;
}

::Brotherhood.addAndRecordWildPerks <- function( _perkTree, _source, _missingPerks, _maximum, _selectedPerks )
{
	local before = _perkTree.getPerks().len();
	local addedIDs = [];

	foreach (perk in _selectedPerks)
	{
		if (_perkTree.hasPerk(perk.ID)) continue;
		_perkTree.addPerk(perk.ID, perk.Tier);
		if (!_perkTree.hasPerk(perk.ID))
		{
			if (::Brotherhood.FleshcraftDebugLogging) ::logWarning("[Brotherhood][WildGeneration] Safe insertion rejected " + perk.ID + " from " + _source.ID);
			continue;
		}

		addedIDs.push(perk.ID);
		if (::Brotherhood.FleshcraftDebugLogging) ::logInfo("[Brotherhood][WildGeneration] Added " + perk.ID + " at tier " + perk.Tier.tostring() + " from " + _source.ID);
	}

	local after = _perkTree.getPerks().len();
	local record = {
		SourceArchetypeID = _source.ID,
		SourceArchetypeName = _source.Name,
		EligibleMissingPerkCount = _missingPerks.len(),
		MaximumContributionSize = _maximum,
		SelectedContributionSize = _selectedPerks.len(),
		AddedPerkIDs = addedIDs,
		UniquePerkCountBefore = before,
		UniquePerkCountAfter = after
	};
	_perkTree.m.BH_WildSources.push(record);

	if (::Brotherhood.FleshcraftDebugLogging) ::logInfo(
		"[Brotherhood][WildGeneration] Source " + _source.Name + " (" + _source.ID + ")"
		+ "; eligible missing perks: " + _missingPerks.len().tostring()
		+ "; maximum contribution: " + _maximum.tostring()
		+ "; selected contribution: " + _selectedPerks.len().tostring()
		+ "; unique perks before/after: " + before.tostring() + "/" + after.tostring()
	);
}

::Brotherhood.fillWildPerksToPreChaosTarget <- function( _perkTree )
{
	local actorName = ::Brotherhood.getWildActorName(_perkTree);
	local startingCount = _perkTree.getPerks().len();
	if ("BH_WildSources" in _perkTree.m) _perkTree.m.BH_WildSources = [];
	else _perkTree.m.BH_WildSources <- [];
	if ("BH_WildUniquePerkCountBefore" in _perkTree.m) _perkTree.m.BH_WildUniquePerkCountBefore = startingCount;
	else _perkTree.m.BH_WildUniquePerkCountBefore <- startingCount;
	if ("BH_WildPreChaosTarget" in _perkTree.m) _perkTree.m.BH_WildPreChaosTarget = ::Brotherhood.PRE_CHAOS_PERK_TARGET;
	else _perkTree.m.BH_WildPreChaosTarget <- ::Brotherhood.PRE_CHAOS_PERK_TARGET;

	if (::Brotherhood.FleshcraftDebugLogging) ::logInfo(
		"[Brotherhood][WildGeneration] " + actorName
		+ " begins Wild phase with " + startingCount.tostring() + " unique perks"
		+ "; pre-Chaos target: " + ::Brotherhood.PRE_CHAOS_PERK_TARGET.tostring()
	);

	if (startingCount < ::Brotherhood.PRE_CHAOS_PERK_TARGET)
	{
		local candidates = ::Brotherhood.buildWildSourceCandidates(_perkTree);
		while (_perkTree.getPerks().len() < ::Brotherhood.PRE_CHAOS_PERK_TARGET && candidates.len() != 0)
		{
			local source = ::Brotherhood.selectWildSource(candidates);
			local missingPerks = ::Brotherhood.collectValidMissingWildPerks(_perkTree, source);
			if (missingPerks.len() == 0)
			{
				if (::Brotherhood.FleshcraftDebugLogging) ::logInfo("[Brotherhood][WildGeneration] Removed " + source.ID + ": no valid missing perks remained");
				continue;
			}

			local remainingSlots = ::Brotherhood.PRE_CHAOS_PERK_TARGET - _perkTree.getPerks().len();
			local maximum = ::Math.min(missingPerks.len(), remainingSlots);
			local contributionSize = ::Brotherhood.selectWildContributionSize(maximum);
			local selectedPerks = ::Brotherhood.selectWildPerkSubset(missingPerks, contributionSize);

			if (::Brotherhood.FleshcraftDebugLogging) ::logInfo(
				"[Brotherhood][WildGeneration] Selected source " + source.Name + " (" + source.ID + ")"
				+ "; remaining-signal weight: " + source.BH_WheelScore.tostring()
				+ "; reasons: [" + ::Brotherhood.formatIDsForLog(source.BH_WheelReasons) + "]"
				+ "; maximum contribution: " + maximum.tostring()
				+ "; randomly selected contribution: " + contributionSize.tostring()
			);
			::Brotherhood.addAndRecordWildPerks(_perkTree, source, missingPerks, maximum, selectedPerks);
		}
	}

	local finalCount = _perkTree.getPerks().len();
	if ("BH_WildUniquePerkCountAfter" in _perkTree.m) _perkTree.m.BH_WildUniquePerkCountAfter = finalCount;
	else _perkTree.m.BH_WildUniquePerkCountAfter <- finalCount;
	if (::Brotherhood.FleshcraftDebugLogging) ::logInfo("[Brotherhood][WildGeneration] " + actorName + " finished Wild phase with " + finalCount.tostring() + " unique perks");

	if (finalCount < ::Brotherhood.PRE_CHAOS_PERK_TARGET)
	{
		if (::Brotherhood.FleshcraftDebugLogging) ::logWarning(
			"[Brotherhood][WildGeneration] " + actorName
			+ " could not reach the pre-Chaos target of " + ::Brotherhood.PRE_CHAOS_PERK_TARGET.tostring()
			+ "; no eligible unused Wild sources remain; final unique perk count: " + finalCount.tostring()
		);
	}
}

::Brotherhood.initializeWildGeneration <- function()
{
	::Brotherhood.registerWildPerkTooltip();

	// Registered after Artillerist's build hook. Therefore __original() resolves
	// native packages, promised support/armor slots, Artillerist, and existing
	// duo perks before Wild begins. No duo pass is called after Wild.
	::Brotherhood.HooksMod.hook(::DynamicPerks.Class.PerkTree, function(q) {
		q.build = @(__original) { function build()
		{
			local ret = __original();
			local isFleshcraft = "BH_SelectedFleshcraftParents" in this.m;
			if (!isFleshcraft && !::Brotherhood.hasEnabledArchetypes()) return ret;
			if (isFleshcraft)
			{
				if (!::Brotherhood.isFleshcraftPerkTree(this)) return ret;
			}
			else if (!::Brotherhood.isTestingPerkTree(this) || !("BH_SelectedArchetypes" in this.m)) return ret;
			if (!isFleshcraft && ::Brotherhood.DebugForceCurrentObsidianArchetypes)
			{
				if (::Brotherhood.FleshcraftDebugLogging) ::logInfo("[Brotherhood][OBSIDIAN DEBUG SPAWN] Wild generation skipped so only current Obsidian archetypes appear.");
				return ret;
			}
			if (::Brotherhood.WildGenerationEnabled) ::Brotherhood.fillWildPerksToPreChaosTarget(this);
			if (::Brotherhood.ChaosGenerationEnabled) ::Brotherhood.fillChaosPerksToFinalTarget(this);
			return ret;
		}}.build;

		q.toUIData = @(__original) { function toUIData()
		{
			local isFleshcraft = "BH_SelectedFleshcraftParents" in this.m;
			if (!isFleshcraft && !::Brotherhood.hasEnabledArchetypes()) return __original();
			if (isFleshcraft)
			{
				if (!::Brotherhood.isFleshcraftPerkTree(this)) return __original();
			}
			else if (!::Brotherhood.isTestingPerkTree(this) || !("BH_SelectedArchetypes" in this.m)) return __original();
			if (::Brotherhood.ChaosGenerationEnabled && (!("BH_ChaosReconciled" in this.m) || !this.m.BH_ChaosReconciled)) ::Brotherhood.fillChaosPerksToFinalTarget(this);
			::Brotherhood.sanitizeWheelPerkTreeGroups(this);
			local ret = __original();
			return ::Brotherhood.decoratePerkTreeUIWithArchetypeProvenance(this, ret);
		}}.toUIData;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.general_queryUIPerkTooltipData = @(__original) { function general_queryUIPerkTooltipData( _entityId, _perkId )
		{
			return ::Brotherhood.decoratePerkTooltipWithArchetypeProvenance(__original(_entityId, _perkId), _entityId, _perkId);
		}}.general_queryUIPerkTooltipData;
	});
}
