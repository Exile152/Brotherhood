// Fleshcraft Wild / Chaos fill driven by Obsidian Experimental Stars.
// Wild: match active stars → weight 1.2 (non-stacking). Chaos: same rule reversed.
if (!("Brotherhood" in getroottable())) return;

::Brotherhood.STAR_BASE_WEIGHT <- 1.0;
::Brotherhood.STAR_MATCH_WEIGHT <- 1.2;
::Brotherhood.CHAOS_MIN_PER_RECRUIT <- 1;
::Brotherhood.CHAOS_MAX_PER_RECRUIT <- 2;
// Wild prefers seating into tiers that still have this many or fewer perks.
::Brotherhood.STAR_WILD_THIN_TIER_MAX <- 3;

::Brotherhood.gatherActiveStarsFromTree <- function( _perkTree )
{
	local active = {};
	foreach (perkID, perk in _perkTree.getPerks())
	{
		foreach (star in ::Brotherhood.getPerkStars(perkID))
			active[star] <- true;
	}
	return active;
};

::Brotherhood.perkMatchesActiveStars <- function( _perkID, _activeStars )
{
	foreach (star in ::Brotherhood.getPerkStars(_perkID))
	{
		if (star in _activeStars) return true;
	}
	return false;
};

::Brotherhood.starCandidateWeight <- function( _perkID, _activeStars, _reverse )
{
	local matched = ::Brotherhood.perkMatchesActiveStars(_perkID, _activeStars);
	if (_reverse)
		return matched ? ::Brotherhood.STAR_BASE_WEIGHT : ::Brotherhood.STAR_MATCH_WEIGHT;
	return matched ? ::Brotherhood.STAR_MATCH_WEIGHT : ::Brotherhood.STAR_BASE_WEIGHT;
};

::Brotherhood.addStarsToActiveSet <- function( _activeStars, _perkID )
{
	foreach (star in ::Brotherhood.getPerkStars(_perkID))
		_activeStars[star] <- true;
};

::Brotherhood.countTreePerksByTier <- function( _perkTree )
{
	local counts = {};
	for (local tier = 1; tier <= 7; ++tier) counts[tier] <- 0;
	foreach (perkID, perk in _perkTree.getPerks())
	{
		local tier = 0;
		if (typeof perk == "table" && ("Row" in perk)) tier = perk.Row + 1;
		else if (perkID in ::Brotherhood.FleshcraftPerkTiers) tier = ::Brotherhood.FleshcraftPerkTiers[perkID];
		if (tier in counts) counts[tier] += 1;
	}
	return counts;
};

::Brotherhood.starTierFillMultiplier <- function( _tierCount )
{
	// Emptier thin tiers win harder: 0→4, 1→3, 2→2, 3→1.
	if (_tierCount > ::Brotherhood.STAR_WILD_THIN_TIER_MAX) return 1.0;
	return (::Brotherhood.STAR_WILD_THIN_TIER_MAX + 1 - _tierCount).tofloat();
};

::Brotherhood.buildFleshcraftStarCandidatePool <- function( _perkTree )
{
	local excluded = ::Brotherhood.getFleshcraftWildExclusionMap(_perkTree);
	local usedNames = {};
	foreach (perkID, perk in _perkTree.getPerks())
		usedNames[::Brotherhood.getChaosPerkDisplayName(perkID)] <- true;

	local pool = [];
	foreach (entry in ::Brotherhood.ActiveObsidianPerks)
	{
		local perkID = entry.ID;
		if (_perkTree.hasPerk(perkID)) continue;
		if (perkID in excluded) continue;
		if (!(perkID in ::Brotherhood.FleshcraftPerkTiers)) continue;
		if (!::Brotherhood.isValidWildPerkDefinition(perkID)) continue;
		local name = ::Brotherhood.getChaosPerkDisplayName(perkID);
		if (name in usedNames) continue;
		pool.push({
			ID = perkID,
			Tier = ::Brotherhood.FleshcraftPerkTiers[perkID],
			Name = name
		});
	}

	// Stable order so weighted draws are deterministic for a given RNG stream.
	pool.sort(@(a, b) a.ID <=> b.ID);
	return pool;
};

::Brotherhood.pickStarWeightedCandidateIndex <- function( _pool, _activeStars, _reverse, _state, _perkTree = null, _preferThinTiers = false )
{
	local counts = _preferThinTiers && _perkTree != null ? ::Brotherhood.countTreePerksByTier(_perkTree) : null;
	local candidateIndices = [];
	if (counts != null)
	{
		foreach (index, entry in _pool)
		{
			local tierCount = (entry.Tier in counts) ? counts[entry.Tier] : 0;
			if (tierCount <= ::Brotherhood.STAR_WILD_THIN_TIER_MAX) candidateIndices.push(index);
		}
	}
	if (candidateIndices.len() == 0)
	{
		foreach (index, entry in _pool) candidateIndices.push(index);
	}

	local total = 0.0;
	local weights = [];
	foreach (poolIndex in candidateIndices)
	{
		local entry = _pool[poolIndex];
		local weight = ::Brotherhood.starCandidateWeight(entry.ID, _activeStars, _reverse);
		if (counts != null)
		{
			local tierCount = (entry.Tier in counts) ? counts[entry.Tier] : 0;
			weight *= ::Brotherhood.starTierFillMultiplier(tierCount);
		}
		weights.push(weight);
		total += weight;
	}
	if (total <= 0.0) return candidateIndices[0];

	local draw = ::Brotherhood.ParentRNG.nextUnit(_state) * total;
	local cumulative = 0.0;
	foreach (index, weight in weights)
	{
		cumulative += weight;
		if (draw < cumulative) return candidateIndices[index];
	}
	return candidateIndices[weights.len() - 1];
};

::Brotherhood.createStarWildChaosRNG <- function( _perkTree )
{
	local actor = _perkTree.getActor();
	local seed = 1;
	if (!::MSU.isNull(actor))
	{
		local parentData = ::Brotherhood.getParentGenerationData(actor);
		if (parentData != null && ("Seed" in parentData)) seed = parentData.Seed;
		else seed = ::Brotherhood.ParentRNG.deriveRecruitSeed(actor);
	}
	return ::Brotherhood.ParentRNG.create(::Brotherhood.ParentRNG.deriveSeed(seed, "brotherhood-star-wild-chaos-v1"));
};

::Brotherhood.fillFleshcraftStarWildAndChaos <- function( _perkTree )
{
	if (("BH_ChaosReconciled" in _perkTree.m) && _perkTree.m.BH_ChaosReconciled) return;

	local actorName = ::Brotherhood.getWildActorName(_perkTree);
	local startingCount = _perkTree.getPerks().len();
	local state = ::Brotherhood.createStarWildChaosRNG(_perkTree);
	local finalTarget = ::Brotherhood.FINAL_PERK_TARGET;

	local chaosCount = 0;
	if (::Brotherhood.ChaosGenerationEnabled)
		chaosCount = ::Brotherhood.ParentRNG.nextInt(state, ::Brotherhood.CHAOS_MIN_PER_RECRUIT, ::Brotherhood.CHAOS_MAX_PER_RECRUIT);

	local wildTarget = startingCount;
	if (::Brotherhood.WildGenerationEnabled)
		wildTarget = ::Math.max(startingCount, finalTarget - chaosCount);

	if ("BH_WildSources" in _perkTree.m) _perkTree.m.BH_WildSources = [];
	else _perkTree.m.BH_WildSources <- [];
	_perkTree.m.BH_WildUniquePerkCountBefore <- startingCount;
	_perkTree.m.BH_WildPreChaosTarget <- wildTarget;
	_perkTree.m.BH_StarChaosSlots <- chaosCount;

	if (::Brotherhood.FleshcraftDebugLogging) ::logInfo(
		"[Brotherhood][StarWildChaos] " + actorName
		+ " begins with " + startingCount.tostring() + " unique perks"
		+ "; final target=" + finalTarget.tostring()
		+ "; chaos slots=" + chaosCount.tostring()
		+ "; wild target=" + wildTarget.tostring()
	);

	local pool = ::Brotherhood.buildFleshcraftStarCandidatePool(_perkTree);
	local activeStars = ::Brotherhood.gatherActiveStarsFromTree(_perkTree);
	local wildAdded = [];

	if (::Brotherhood.WildGenerationEnabled)
	{
		while (_perkTree.getPerks().len() < wildTarget && pool.len() != 0)
		{
			local index = ::Brotherhood.pickStarWeightedCandidateIndex(pool, activeStars, false, state, _perkTree, true);
			local entry = pool.remove(index);
			if (!::Brotherhood.addActiveObsidianPerk(_perkTree, entry.ID, entry.Tier, "star_wild"))
				continue;
			wildAdded.push(entry.ID);
			::Brotherhood.addStarsToActiveSet(activeStars, entry.ID);
		}

		// Record for debug/logs only. Player tooltips never label these as Wild.
		_perkTree.m.BH_WildSources.push({
			SourceArchetypeID = "bh.star_wild",
			SourceArchetypeName = "Star",
			EligibleMissingPerkCount = wildAdded.len(),
			MaximumContributionSize = wildTarget - startingCount,
			SelectedContributionSize = wildAdded.len(),
			AddedPerkIDs = wildAdded,
			UniquePerkCountBefore = startingCount,
			UniquePerkCountAfter = _perkTree.getPerks().len(),
			PlayerHidden = true
		});
	}

	_perkTree.m.BH_WildUniquePerkCountAfter <- _perkTree.getPerks().len();

	local chaosAdded = [];
	if (::Brotherhood.ChaosGenerationEnabled)
	{
		// Rebuild after Wild so seated Wild IDs / names leave the pool.
		pool = ::Brotherhood.buildFleshcraftStarCandidatePool(_perkTree);
		activeStars = ::Brotherhood.gatherActiveStarsFromTree(_perkTree);
		local chaosPerks = ::Brotherhood.getRecordedChaosPerks(_perkTree);

		while (chaosAdded.len() < chaosCount && pool.len() != 0 && _perkTree.getPerks().len() < finalTarget)
		{
			local index = ::Brotherhood.pickStarWeightedCandidateIndex(pool, activeStars, true, state);
			local entry = pool.remove(index);
			if (!::Brotherhood.addActiveObsidianPerk(_perkTree, entry.ID, entry.Tier, "star_chaos"))
				continue;
			chaosAdded.push(entry.ID);
			chaosPerks.push(entry.ID);
			::Brotherhood.addStarsToActiveSet(activeStars, entry.ID);
		}

		::Brotherhood.storeRecordedChaosPerks(_perkTree, chaosPerks);
	}

	_perkTree.m.BH_FinalGeneratedPerkCount <- _perkTree.getPerks().len();
	_perkTree.m.BH_ChaosReconciled <- true;

	if (::Brotherhood.FleshcraftDebugLogging) ::logInfo(
		"[Brotherhood][StarWildChaos] " + actorName
		+ " finished; wild added=" + wildAdded.len().tostring()
		+ " [" + ::Brotherhood.formatIDsForLog(wildAdded) + "]"
		+ "; chaos added=" + chaosAdded.len().tostring()
		+ " [" + ::Brotherhood.formatIDsForLog(chaosAdded) + "]"
		+ "; final unique count=" + _perkTree.getPerks().len().tostring()
		+ "/" + finalTarget.tostring()
	);

	if (::Brotherhood.WildGenerationEnabled && _perkTree.getPerks().len() < wildTarget)
	{
		if (::Brotherhood.FleshcraftDebugLogging) ::logWarning(
			"[Brotherhood][StarWildChaos] " + actorName
			+ " could not reach wild target " + wildTarget.tostring()
			+ "; pool exhausted; final=" + _perkTree.getPerks().len().tostring()
		);
	}
};
