// Generic Fleshcrafting half construction. Template and perk-specific data
// belongs in fleshcraft_data.nut; this file must remain content-agnostic.
::Brotherhood.FleshcraftConstants <- {
	ZERO = 0,
	ONE = 1,
	NEGATIVE_ONE = -1,
	LEAN = 0.60,
	HALF_SIZE = 5,
	SPINE_MIN = 1,
	SPINE_MAX = 2,
	DOUBLE_SPINE_CHANCE = 0.50,
	MIN_SEAT_CANDIDATES = 2,
	RANDOM_SCALE = 1000000,
	PERCENT_SCALE = 100.0,
	PARENT_COUNT = 4,
	PATCH_UP_COUNT = 2,
	PATCH_UP_POOL_SIZE = 4,
	FAMILIES = ["soldier", "barbarian", "noble", "cunning", "scholar"]
};

::Brotherhood.fleshcraftLogInfo <- function( _message )
{
	local fleshcraft = "FleshcraftDebugLogging" in ::Brotherhood && ::Brotherhood.FleshcraftDebugLogging;
	local detailedParent = "ParentGenerationDetailedDebugLogging" in ::Brotherhood && ::Brotherhood.ParentGenerationDetailedDebugLogging;
	if (!fleshcraft && !detailedParent) return;
	::logInfo(_message);
}

::Brotherhood.FleshcraftRule <- {
	BodyRead = "BODY-READ",
	Family = "FAMILY",
	FairDraw = "FAIR DRAW"
};

::Brotherhood.fleshcraftFail <- function( _templateID, _message )
{
	throw "Brotherhood Fleshcraft template '" + _templateID + "': " + _message;
}

::Brotherhood.fleshcraftHasValue <- function( _values, _value )
{
	return _values.find(_value) != null;
}

::Brotherhood.fleshcraftCloneArray <- function( _values )
{
	local ret = [];
	foreach (value in _values) ret.push(value);
	return ret;
}

::Brotherhood.fleshcraftRemoveValue <- function( _values, _value )
{
	local index = _values.find(_value);
	if (index != null) _values.remove(index);
}

::Brotherhood.fleshcraftFormatIDs <- function( _values )
{
	if (_values.len() == ::Brotherhood.FleshcraftConstants.ZERO) return "none";
	local ret = "";
	foreach (index, value in _values)
	{
		if (index != ::Brotherhood.FleshcraftConstants.ZERO) ret += ", ";
		ret += value;
	}
	return ret;
}

::Brotherhood.fleshcraftRandomUnit <- function( _random = null )
{
	local c = ::Brotherhood.FleshcraftConstants;
	if (_random != null)
	{
		local ret = _random();
		if (ret < c.ZERO || ret >= c.ONE) throw "Brotherhood Fleshcraft injected random value must be in [0, 1)";
		return ret;
	}
	return ::Math.rand(c.ZERO, c.RANDOM_SCALE - c.ONE).tofloat() / c.RANDOM_SCALE.tofloat();
}

::Brotherhood.fleshcraftGetPerkMeta <- function( _perkID )
{
	return _perkID in ::Brotherhood.FleshcraftPerkMeta ? ::Brotherhood.FleshcraftPerkMeta[_perkID] : null;
}

::Brotherhood.fleshcraftValidateFamily <- function( _templateID, _perkID, _field, _family )
{
	if (_family == null) return;
	if (!::Brotherhood.fleshcraftHasValue(::Brotherhood.FleshcraftConstants.FAMILIES, _family))
	{
		::Brotherhood.fleshcraftFail(_templateID, "perk " + _perkID + " has invalid " + _field + " family '" + _family + "'");
	}
}

::Brotherhood.fleshcraftValidatePerkMeta <- function( _templateID, _perkID )
{
	local meta = ::Brotherhood.fleshcraftGetPerkMeta(_perkID);
	if (meta == null) ::Brotherhood.fleshcraftFail(_templateID, "missing global perk_meta for " + _perkID);
	foreach (field in ["family_plus", "family_minus", "fit_predicate"])
	{
		if (!(field in meta)) ::Brotherhood.fleshcraftFail(_templateID, "perk_meta for " + _perkID + " is missing " + field);
	}
	::Brotherhood.fleshcraftValidateFamily(_templateID, _perkID, "family_plus", meta.family_plus);
	::Brotherhood.fleshcraftValidateFamily(_templateID, _perkID, "family_minus", meta.family_minus);
	if (meta.fit_predicate != null && typeof meta.fit_predicate != "function")
	{
		::Brotherhood.fleshcraftFail(_templateID, "fit_predicate for " + _perkID + " is not a function or null");
	}
}

::Brotherhood.validateFleshcraftTemplate <- function( _template )
{
	if (typeof _template != "table") throw "Brotherhood Fleshcraft template must be a table";
	local fallbackID = "unknown";
	local templateID = "id" in _template ? _template.id : fallbackID;
	foreach (field in ["id", "spine_pool", "flesh_pool", "seats", "parent_fit_hooks"])
	{
		if (!(field in _template)) ::Brotherhood.fleshcraftFail(templateID, "missing required field " + field);
	}
	if (typeof _template.id != "string" || _template.id.len() == ::Brotherhood.FleshcraftConstants.ZERO)
	{
		::Brotherhood.fleshcraftFail(templateID, "id must be a non-empty string");
	}
	if (typeof _template.spine_pool != "array" || typeof _template.flesh_pool != "array" || typeof _template.seats != "array")
	{
		::Brotherhood.fleshcraftFail(templateID, "spine_pool, flesh_pool, and seats must be arrays");
	}
	if (typeof _template.parent_fit_hooks != "table")
	{
		::Brotherhood.fleshcraftFail(templateID, "parent_fit_hooks must be a table");
	}

	local poolMembership = {};
	foreach (poolName, pool in { spine = _template.spine_pool, flesh = _template.flesh_pool })
	{
		foreach (perkID in pool)
		{
			if (typeof perkID != "string") ::Brotherhood.fleshcraftFail(templateID, poolName + " pool contains a non-string perk id");
			if (perkID in poolMembership) ::Brotherhood.fleshcraftFail(templateID, "perk " + perkID + " appears more than once or in both pools");
			if (::Brotherhood.FleshcraftPatchUpPerks.find(perkID) != null)
			{
				::Brotherhood.fleshcraftFail(templateID, "Patch Up perk is forbidden inside parent data: " + perkID);
			}
			poolMembership[perkID] <- poolName;
			::Brotherhood.fleshcraftValidatePerkMeta(templateID, perkID);
		}
	}

	local seatIDs = {};
	local seatedCandidates = {};
	foreach (seat in _template.seats)
	{
		if (typeof seat != "table" || !("id" in seat) || !("candidates" in seat))
		{
			::Brotherhood.fleshcraftFail(templateID, "every seat requires id and candidates");
		}
		if (typeof seat.id != "string" || seat.id.len() == ::Brotherhood.FleshcraftConstants.ZERO)
		{
			::Brotherhood.fleshcraftFail(templateID, "seat id must be a non-empty string");
		}
		if (seat.id in seatIDs) ::Brotherhood.fleshcraftFail(templateID, "duplicate seat id " + seat.id);
		seatIDs[seat.id] <- true;
		if (typeof seat.candidates != "array" || seat.candidates.len() < ::Brotherhood.FleshcraftConstants.MIN_SEAT_CANDIDATES)
		{
			::Brotherhood.fleshcraftFail(templateID, "seat " + seat.id + " requires at least two candidates");
		}

		local seatPool = null;
		foreach (perkID in seat.candidates)
		{
			if (!(perkID in poolMembership)) ::Brotherhood.fleshcraftFail(templateID, "seat " + seat.id + " references perk outside both pools: " + perkID);
			if (perkID in seatedCandidates) ::Brotherhood.fleshcraftFail(templateID, "perk " + perkID + " appears in more than one seat");
			seatedCandidates[perkID] <- seat.id;
			if (seatPool == null) seatPool = poolMembership[perkID];
			else if (seatPool != poolMembership[perkID]) ::Brotherhood.fleshcraftFail(templateID, "seat " + seat.id + " mixes spine and flesh candidates");
		}
	}
	return true;
}

::Brotherhood.validateFleshcraftData <- function()
{
	if (typeof ::Brotherhood.FleshcraftTemplates != "table") throw "Brotherhood FleshcraftTemplates must be a table";
	if (typeof ::Brotherhood.FleshcraftPerkMeta != "table") throw "Brotherhood FleshcraftPerkMeta must be a table";
	if (typeof ::Brotherhood.FleshcraftBackgroundMeta != "table") throw "Brotherhood FleshcraftBackgroundMeta must be a table";
	foreach (registryID, template in ::Brotherhood.FleshcraftTemplates)
	{
		::Brotherhood.validateFleshcraftTemplate(template);
		if (registryID != template.id) ::Brotherhood.fleshcraftFail(template.id, "registry key does not match template id");
	}
	if (typeof ::Brotherhood.FleshcraftParentRegistry != "array") throw "Brotherhood FleshcraftParentRegistry must be an array";
	if (::Brotherhood.FleshcraftParentRegistry.len() < ::Brotherhood.FleshcraftConstants.PARENT_COUNT)
	{
		throw "Brotherhood Fleshcraft parent registry contains fewer than four parents";
	}
	local parentIDs = {};
	foreach (parent in ::Brotherhood.FleshcraftParentRegistry)
	{
		if (typeof parent != "table" || !("ID" in parent) || !("Name" in parent))
		{
			throw "Brotherhood Fleshcraft parent registry entries require ID and Name";
		}
		if (!(parent.ID in ::Brotherhood.FleshcraftTemplates)) throw "Brotherhood Fleshcraft parent registry references missing template: " + parent.ID;
		if (parent.ID in parentIDs) throw "Brotherhood Fleshcraft parent registry contains duplicate ID: " + parent.ID;
		parentIDs[parent.ID] <- true;
	}
	if (typeof ::Brotherhood.FleshcraftPatchUpPerks != "array" || ::Brotherhood.FleshcraftPatchUpPerks.len() != ::Brotherhood.FleshcraftConstants.PATCH_UP_POOL_SIZE)
	{
		throw "Brotherhood Patch Up registry must contain exactly four perks";
	}
	local patchIDs = {};
	foreach (perkID in ::Brotherhood.FleshcraftPatchUpPerks)
	{
		if (perkID in patchIDs) throw "Brotherhood Patch Up registry contains duplicate ID: " + perkID;
		patchIDs[perkID] <- true;
		if (!(perkID in ::Brotherhood.FleshcraftPerkTiers)) throw "Brotherhood Patch Up perk has no authored tier: " + perkID;
	}
	foreach (backgroundID, meta in ::Brotherhood.FleshcraftBackgroundMeta)
	{
		if (typeof meta != "table" || !("family" in meta)) throw "Brotherhood Fleshcraft background_meta entry requires family: " + backgroundID;
		if (meta.family != null && !::Brotherhood.fleshcraftHasValue(::Brotherhood.FleshcraftConstants.FAMILIES, meta.family))
		{
			throw "Brotherhood Fleshcraft background_meta entry has invalid family: " + backgroundID;
		}
	}
	return true;
}

::Brotherhood.fleshcraftGetRecruitFamily <- function( _bro )
{
	if (_bro == null || !("getBackground" in _bro)) return null;
	local background = _bro.getBackground();
	if (background == null || !("getID" in background)) return null;
	local backgroundID = background.getID();
	if (!(backgroundID in ::Brotherhood.FleshcraftBackgroundMeta)) return null;
	local meta = ::Brotherhood.FleshcraftBackgroundMeta[backgroundID];
	if (meta == null || !("family" in meta)) return null;
	return meta.family;
}

::Brotherhood.fleshcraftUniqueMaximumIndex <- function( _scores )
{
	local bestIndex = null;
	local bestScore = null;
	local tied = false;
	foreach (index, score in _scores)
	{
		if (bestScore == null || score > bestScore)
		{
			bestScore = score;
			bestIndex = index;
			tied = false;
		}
		else if (score == bestScore)
		{
			tied = true;
		}
	}
	return tied ? null : bestIndex;
}

::Brotherhood.fleshcraftUniformOdds <- function( _count )
{
	local ret = [];
	local chance = ::Brotherhood.FleshcraftConstants.ONE.tofloat() / _count.tofloat();
	while (ret.len() < _count) ret.push(chance);
	return ret;
}

::Brotherhood.fleshcraftLeanOdds <- function( _count, _favoredIndex )
{
	local c = ::Brotherhood.FleshcraftConstants;
	local otherChance = (c.ONE.tofloat() - c.LEAN) / (_count - c.ONE).tofloat();
	local ret = [];
	while (ret.len() < _count)
	{
		ret.push(ret.len() == _favoredIndex ? c.LEAN : otherChance);
	}
	return ret;
}

::Brotherhood.fleshcraftPickByOdds <- function( _candidates, _odds, _random = null )
{
	local roll = ::Brotherhood.fleshcraftRandomUnit(_random);
	local running = ::Brotherhood.FleshcraftConstants.ZERO.tofloat();
	foreach (index, chance in _odds)
	{
		running += chance;
		if (roll < running) return _candidates[index];
	}
	return _candidates[_candidates.len() - ::Brotherhood.FleshcraftConstants.ONE];
}

::Brotherhood.fleshcraftFormatOdds <- function( _candidates, _odds )
{
	local ret = [];
	foreach (index, candidate in _candidates)
	{
		ret.push(candidate + "=" + (_odds[index] * ::Brotherhood.FleshcraftConstants.PERCENT_SCALE).tostring() + "%");
	}
	return ::Brotherhood.fleshcraftFormatIDs(ret);
}

::Brotherhood.resolveFleshcraftSeat <- function( _templateID, _seat, _bro, _isSpine, _random = null )
{
	local candidates = ::Brotherhood.fleshcraftCloneArray(_seat.candidates);
	local rule = ::Brotherhood.FleshcraftRule.FairDraw;
	local odds = null;
	local favoredIndex = null;

	if (!_isSpine)
	{
		local hasPredicate = false;
		foreach (perkID in candidates)
		{
			if (::Brotherhood.fleshcraftGetPerkMeta(perkID).fit_predicate != null) hasPredicate = true;
		}

		if (hasPredicate)
		{
			local scores = [];
			foreach (perkID in candidates)
			{
				local predicate = ::Brotherhood.fleshcraftGetPerkMeta(perkID).fit_predicate;
				if (predicate == null) ::Brotherhood.fleshcraftFail(_templateID, "seat " + _seat.id + " mixes body predicates with an unauthored null baseline for " + perkID);
				scores.push(predicate(_bro));
			}
			favoredIndex = ::Brotherhood.fleshcraftUniqueMaximumIndex(scores);
			if (favoredIndex != null) rule = ::Brotherhood.FleshcraftRule.BodyRead;
		}
		else
		{
			local family = ::Brotherhood.fleshcraftGetRecruitFamily(_bro);
			if (family != null)
			{
				local scores = [];
				foreach (perkID in candidates)
				{
					local meta = ::Brotherhood.fleshcraftGetPerkMeta(perkID);
					local score = ::Brotherhood.FleshcraftConstants.ZERO;
					if (meta.family_plus == family) score = ::Brotherhood.FleshcraftConstants.ONE;
					else if (meta.family_minus == family) score = ::Brotherhood.FleshcraftConstants.NEGATIVE_ONE;
					scores.push(score);
				}
				favoredIndex = ::Brotherhood.fleshcraftUniqueMaximumIndex(scores);
				if (favoredIndex != null) rule = ::Brotherhood.FleshcraftRule.Family;
			}
		}
	}

	odds = favoredIndex == null
		? ::Brotherhood.fleshcraftUniformOdds(candidates.len())
		: ::Brotherhood.fleshcraftLeanOdds(candidates.len(), favoredIndex);
	local winner = ::Brotherhood.fleshcraftPickByOdds(candidates, odds, _random);
	::Brotherhood.fleshcraftLogInfo(
		"[Brotherhood][FLESHCRAFT][SEAT] template=" + _templateID
		+ "; seat=" + _seat.id
		+ "; candidates=[" + ::Brotherhood.fleshcraftFormatIDs(candidates) + "]"
		+ "; rule=" + rule
		+ "; odds=[" + ::Brotherhood.fleshcraftFormatOdds(candidates, odds) + "]"
		+ "; winner=" + winner
	);
	return { SeatID = _seat.id, Candidates = candidates, Rule = rule, Odds = odds, Winner = winner, IsSpine = _isSpine };
}

::Brotherhood.fleshcraftSampleDistinct <- function( _pool, _count, _random = null )
{
	local c = ::Brotherhood.FleshcraftConstants;
	local remaining = ::Brotherhood.fleshcraftCloneArray(_pool);
	local ret = [];
	while (ret.len() < _count)
	{
		local index = ::Math.floor(::Brotherhood.fleshcraftRandomUnit(_random) * remaining.len()).tointeger();
		if (index >= remaining.len()) index = remaining.len() - c.ONE;
		ret.push(remaining.remove(index));
	}
	return ret;
}

::Brotherhood.fleshcraftWarnSpineMetadata <- function( _template )
{
	foreach (perkID in _template.spine_pool)
	{
		local meta = ::Brotherhood.fleshcraftGetPerkMeta(perkID);
		if (meta.family_plus == null && meta.family_minus == null && meta.fit_predicate == null) continue;
		if (::Brotherhood.FleshcraftDebugLogging) ::logWarning("[Brotherhood][FLESHCRAFT][SPINE META IGNORED] template=" + _template.id + "; perk=" + perkID + "; spine selection is family-blind and body-blind");
	}
}

::Brotherhood.constructFleshcraftHalf <- function( _template, _bro, _random = null )
{
	local c = ::Brotherhood.FleshcraftConstants;
	::Brotherhood.validateFleshcraftTemplate(_template);
	::Brotherhood.fleshcraftWarnSpineMetadata(_template);

	local realizedSpines = ::Brotherhood.fleshcraftCloneArray(_template.spine_pool);
	local realizedFlesh = ::Brotherhood.fleshcraftCloneArray(_template.flesh_pool);
	local decisions = [];
	foreach (seat in _template.seats)
	{
		local isSpine = ::Brotherhood.fleshcraftHasValue(_template.spine_pool, seat.candidates[c.ZERO]);
		local decision = ::Brotherhood.resolveFleshcraftSeat(_template.id, seat, _bro, isSpine, _random);
		decisions.push(decision);
		foreach (candidate in seat.candidates)
		{
			if (candidate == decision.Winner) continue;
			if (isSpine) ::Brotherhood.fleshcraftRemoveValue(realizedSpines, candidate);
			else ::Brotherhood.fleshcraftRemoveValue(realizedFlesh, candidate);
		}
	}

	local requiredSpines = c.SPINE_MAX;
	local requiredFlesh = c.HALF_SIZE - c.SPINE_MIN;
	if (realizedSpines.len() < requiredSpines)
	{
		::Brotherhood.fleshcraftFail(_template.id, "cannot satisfy both legal half shapes; spines required=" + requiredSpines + ", available=" + realizedSpines.len());
	}
	if (realizedFlesh.len() < requiredFlesh)
	{
		::Brotherhood.fleshcraftFail(_template.id, "cannot satisfy both legal half shapes; flesh required=" + requiredFlesh + ", available=" + realizedFlesh.len());
	}

	local spineCount = ::Brotherhood.fleshcraftRandomUnit(_random) < c.DOUBLE_SPINE_CHANCE ? c.SPINE_MAX : c.SPINE_MIN;
	local fleshCount = c.HALF_SIZE - spineCount;
	local seatedSpines = ::Brotherhood.fleshcraftSampleDistinct(realizedSpines, spineCount, _random);
	local seatedFlesh = ::Brotherhood.fleshcraftSampleDistinct(realizedFlesh, fleshCount, _random);
	local half = ::Brotherhood.fleshcraftCloneArray(seatedSpines);
	foreach (perkID in seatedFlesh) half.push(perkID);

	::Brotherhood.fleshcraftLogInfo("[Brotherhood][FLESHCRAFT][POOLS] template=" + _template.id + "; spines=[" + ::Brotherhood.fleshcraftFormatIDs(realizedSpines) + "]; flesh=[" + ::Brotherhood.fleshcraftFormatIDs(realizedFlesh) + "]");
	::Brotherhood.fleshcraftLogInfo("[Brotherhood][FLESHCRAFT][SHAPE] template=" + _template.id + "; spines=" + spineCount + "; flesh=" + fleshCount);
	::Brotherhood.fleshcraftLogInfo("[Brotherhood][FLESHCRAFT][HALF] template=" + _template.id + "; seated_spines=[" + ::Brotherhood.fleshcraftFormatIDs(seatedSpines) + "]; seated_flesh=[" + ::Brotherhood.fleshcraftFormatIDs(seatedFlesh) + "]; final=[" + ::Brotherhood.fleshcraftFormatIDs(half) + "]");

	return {
		TemplateID = _template.id,
		SeatDecisions = decisions,
		RealizedSpines = realizedSpines,
		RealizedFlesh = realizedFlesh,
		SpineCount = spineCount,
		FleshCount = fleshCount,
		SeatedSpines = seatedSpines,
		SeatedFlesh = seatedFlesh,
		Half = half
	};
}

::Brotherhood.constructFleshcraftHalfByID <- function( _templateID, _bro, _random = null )
{
	if (!(_templateID in ::Brotherhood.FleshcraftTemplates)) ::Brotherhood.fleshcraftFail(_templateID, "template is not registered");
	return ::Brotherhood.constructFleshcraftHalf(::Brotherhood.FleshcraftTemplates[_templateID], _bro, _random);
}

::Brotherhood.selectFleshcraftParents <- function( _bro )
{
	local data = ::Brotherhood.ensureParentGeneration(_bro);
	if (data == null || data.ParentIDs.len() != ::Brotherhood.FleshcraftConstants.PARENT_COUNT) return null;
	local selected = [];
	foreach (id in data.ParentIDs)
	{
		if (!(id in ::Brotherhood.FleshcraftTemplates)) throw "selected parent has no Fleshcraft template: " + id;
		selected.push({ ID=id, Name=::Brotherhood.getParentProfileName(id) });
	}
	return selected;
}

::Brotherhood.constructFleshcraftParents <- function( _bro, _random = null )
{
	local selected = ::Brotherhood.selectFleshcraftParents(_bro);
	if (selected == null) return null;
	local data = ::Brotherhood.getParentGenerationData(_bro);
	local state = null;
	local random = _random;
	if (random == null)
	{
		state = ::Brotherhood.ParentRNG.create(::Brotherhood.ParentRNG.deriveSeed(data.Seed, "brotherhood-fleshcraft-seats-v1"));
		random = function() { return ::Brotherhood.ParentRNG.nextUnit(state); }
	}
	local realized = [];
	foreach (parent in selected)
	{
		local result = ::Brotherhood.constructFleshcraftHalfByID(parent.ID, _bro, random);
		result.Parent <- parent;
		realized.push(result);
	}
	::Brotherhood.applyArmamentLayerToParents(realized, random);
	return realized;
}

::Brotherhood.getFleshcraftDuplicateCollapses <- function( _realizedParents )
{
	local owners = {};
	foreach (parent in _realizedParents)
	{
		foreach (perkID in parent.Half)
		{
			if (!(perkID in owners)) owners[perkID] <- [];
			owners[perkID].push(parent.TemplateID);
		}
	}
	local ret = [];
	foreach (perkID, parentIDs in owners)
	{
		if (parentIDs.len() > ::Brotherhood.FleshcraftConstants.ONE) ret.push({ PerkID = perkID, ParentIDs = parentIDs, CollapsedCount = parentIDs.len() - ::Brotherhood.FleshcraftConstants.ONE });
	}
	return ret;
}

::Brotherhood.getFleshcraftDuoEligibility <- function( _realizedParents )
{
	local ret = [];
	for (local left = ::Brotherhood.FleshcraftConstants.ZERO; left < _realizedParents.len(); ++left)
	{
		for (local right = left + ::Brotherhood.FleshcraftConstants.ONE; right < _realizedParents.len(); ++right)
		{
			local overlaps = [];
			foreach (perkID in _realizedParents[left].Half)
			{
				if (_realizedParents[right].Half.find(perkID) != null) overlaps.push(perkID);
			}
			ret.push({
				LeftParentID = _realizedParents[left].TemplateID,
				RightParentID = _realizedParents[right].TemplateID,
				Overlaps = overlaps,
				Eligible = overlaps.len() == ::Brotherhood.FleshcraftConstants.ZERO
			});
		}
	}
	return ret;
}

::Brotherhood.selectFleshcraftPatchUp <- function( _existingPerkIDs = null, _random = null )
{
	local c = ::Brotherhood.FleshcraftConstants;
	local existing = _existingPerkIDs == null ? [] : _existingPerkIDs;
	local selected = [];
	foreach (perkID in ::Brotherhood.FleshcraftPatchUpPerks)
	{
		if (existing.find(perkID) != null && selected.find(perkID) == null) selected.push(perkID);
	}
	if (selected.len() > ::Brotherhood.FleshcraftConstants.PATCH_UP_COUNT)
	{
		throw "Brotherhood Fleshcraft tree already contains more than two distinct Patch Up perks";
	}
	local candidates = [];
	foreach (perkID in ::Brotherhood.FleshcraftPatchUpPerks)
	{
		if (selected.find(perkID) == null) candidates.push(perkID);
	}
	while (selected.len() < ::Brotherhood.FleshcraftConstants.PATCH_UP_COUNT)
	{
		local index = ::Math.floor(::Brotherhood.fleshcraftRandomUnit(_random) * candidates.len()).tointeger();
		if (index >= candidates.len()) index = candidates.len() - c.ONE;
		selected.push(candidates.remove(index));
	}
	return { Candidates = clone ::Brotherhood.FleshcraftPatchUpPerks, Selected = selected };
}
