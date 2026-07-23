::Brotherhood.getWheelProfileByID <- function( _id )
{
	foreach (profile in ::Brotherhood.WheelProfiles)
	{
		if (profile.ID == _id) return profile;
	}
	return null;
}

::Brotherhood.getWheelSignalKey <- function( _kind, _key )
{
	return _kind + ":" + _key.tostring();
}

::Brotherhood.getWheelProjectedTotal <- function( _snapshot )
{
	local ret = 0.0;
	foreach (attribute, value in _snapshot.Projected) ret += value;
	return ret;
}

::Brotherhood.getWheelTotalStars <- function( _snapshot )
{
	local ret = 0;
	foreach (stars in _snapshot.Talents) ret += stars;
	return ret;
}

::Brotherhood.getWheelStatValue <- function( _snapshot, _key )
{
	if (typeof _key != "string") return _snapshot.Projected[_key];
	if (_key == "BestAttack") return ::Math.maxf(_snapshot.Projected[::Const.Attributes.MeleeSkill], _snapshot.Projected[::Const.Attributes.RangedSkill]);
	if (_key == "TotalStars") return ::Brotherhood.getWheelTotalStars(_snapshot);
	if (_key == "LowTotalStars") return 9 - ::Brotherhood.getWheelTotalStars(_snapshot);
	if (_key == "LowProjectedTotal") return 720.0 - ::Brotherhood.getWheelProjectedTotal(_snapshot);
	return 0.0;
}

::Brotherhood.captureWheelSnapshot <- function( _perkTree )
{
	local actor = _perkTree.getActor();
	if (::MSU.isNull(actor)) throw "Brotherhood Wheel of Fortune requires an actor";

	local traitIDs = [];
	foreach (skill in actor.getSkills().getSkillsByFunction(@( _skill ) _skill.isType(::Const.SkillType.Trait)))
	{
		traitIDs.push(skill.getID().tolower());
	}

	local background = actor.getBackground();
	return {
		Projected = _perkTree.getProjectedAttributesAvg(),
		Talents = clone actor.getTalents(),
		BackgroundID = background == null ? "" : background.getID().tolower(),
		TraitIDs = traitIDs
	};
}

::Brotherhood.wheelContainsFragment <- function( _values, _fragment )
{
	local needle = _fragment.tolower();
	foreach (value in _values)
	{
		if (value.find(needle) != null) return true;
	}
	return false;
}

::Brotherhood.getWheelSignalFactor <- function( _factors, _key )
{
	return _key in _factors ? _factors[_key] : 1.0;
}

::Brotherhood.addWheelContribution <- function( _result, _factors, _signalKey, _weight, _label )
{
	local adjusted = _weight * ::Brotherhood.getWheelSignalFactor(_factors, _signalKey);
	_result.Score += adjusted;
	_result.Reasons.push(_label + " " + (adjusted >= 0 ? "+" : "") + adjusted.tostring());
	if (_weight >= 1.5 && _result.StrongSignals.find(_signalKey) == null) _result.StrongSignals.push(_signalKey);
}

::Brotherhood.scoreWheelProfile <- function( _profile, _snapshot, _factors = null )
{
	if (_factors == null) _factors = {};
	local ret = { Eligible = true, Score = _profile.BaseWeight, Reasons = [], StrongSignals = [] };

	foreach (requirement in _profile.Requirements)
	{
		local value = ::Brotherhood.getWheelStatValue(_snapshot, requirement.Key);
		if (value >= requirement.Minimum) continue;
		ret.Eligible = false;
		ret.Score = 0.0;
		ret.Reasons.push("requirement failed: " + requirement.Key.tostring() + " " + value.tostring() + "/" + requirement.Minimum.tostring());
		return ret;
	}

	foreach (exclusion in _profile.Exclusions)
	{
		if (exclusion.Kind == "Trait" && ::Brotherhood.wheelContainsFragment(_snapshot.TraitIDs, exclusion.Match))
		{
			ret.Eligible = false;
			ret.Score = 0.0;
			ret.Reasons.push("excluded trait: " + exclusion.Match);
			return ret;
		}
	}

	foreach (stat in _profile.Stats)
	{
		local value = ::Brotherhood.getWheelStatValue(_snapshot, stat.Key);
		foreach (threshold in stat.Thresholds)
		{
			if (value < threshold[0]) continue;
			local key = ::Brotherhood.getWheelSignalKey("stat", stat.Key);
			::Brotherhood.addWheelContribution(ret, _factors, key, threshold[1], stat.Role + " " + stat.Key.tostring() + "=" + value.tostring());
			break;
		}

		if (stat.TalentWeight > 0.0 && typeof stat.Key != "string")
		{
			local stars = _snapshot.Talents[stat.Key];
			if (stars > 0)
			{
				local talentKey = ::Brotherhood.getWheelSignalKey("talent", stat.Key);
				::Brotherhood.addWheelContribution(ret, _factors, talentKey, stat.TalentWeight * stars, stat.Role + " stars=" + stars.tostring());
			}
		}
	}

	local backgroundBest = null;
	foreach (signal in _profile.Backgrounds)
	{
		if (_snapshot.BackgroundID.find(signal[0].tolower()) == null) continue;
		if (backgroundBest == null || signal[1] > backgroundBest[1]) backgroundBest = signal;
	}
	if (backgroundBest != null)
	{
		::Brotherhood.addWheelContribution(ret, _factors, ::Brotherhood.getWheelSignalKey("background", backgroundBest[0]), backgroundBest[1], "background " + backgroundBest[0]);
	}

	foreach (signal in _profile.Traits)
	{
		if (!::Brotherhood.wheelContainsFragment(_snapshot.TraitIDs, signal[0])) continue;
		::Brotherhood.addWheelContribution(ret, _factors, ::Brotherhood.getWheelSignalKey("trait", signal[0]), signal[1], "trait " + signal[0]);
	}
	foreach (signal in _profile.NegativeTraits)
	{
		if (!::Brotherhood.wheelContainsFragment(_snapshot.TraitIDs, signal[0])) continue;
		::Brotherhood.addWheelContribution(ret, _factors, ::Brotherhood.getWheelSignalKey("negative_trait", signal[0]), signal[1], "negative trait " + signal[0]);
	}

	ret.Score = ::Math.maxf(0.05, ret.Score);
	return ret;
}

::Brotherhood.selectWeightedWheelCandidate <- function( _candidates )
{
	local total = 0;
	foreach (candidate in _candidates) total += ::Math.max(1, ::Math.round(candidate.Result.Score * 1000.0));
	local roll = ::Math.rand(1, total);
	local running = 0;
	foreach (index, candidate in _candidates)
	{
		running += ::Math.max(1, ::Math.round(candidate.Result.Score * 1000.0));
		if (roll <= running) return index;
	}
	return _candidates.len() - 1;
}

::Brotherhood.consumeWheelStrongSignals <- function( _factors, _signals )
{
	foreach (signalKey in _signals)
	{
		local current = ::Brotherhood.getWheelSignalFactor(_factors, signalKey);
		_factors[signalKey] <- ::Math.maxf(0.15, current * 0.45);
	}
}

::Brotherhood.selectWheelArchetypes <- function( _perkTree )
{
	local pool = ::Brotherhood.TemporaryArchetypeTestPool.filter(@(_, _definition) ::Brotherhood.isArchetypeEnabled(_definition.ID));
	local target = ::Math.min(::Brotherhood.GeneratedArchetypeCount, pool.len());
	if (target == 0) return [];

	local snapshot = ::Brotherhood.captureWheelSnapshot(_perkTree);
	local factors = {};
	local selected = [];
	local rounds = [];
	local slotLabels = ["Sun", "Moon A", "Moon B", "Moon C", "Moon D"];

	for (local slot = 0; slot < target; ++slot)
	{
		local candidates = [];
		foreach (definition in pool)
		{
			local profile = ::Brotherhood.getWheelProfileByID(definition.ID);
			if (profile == null) throw "Brotherhood enabled archetype is missing a Wheel profile: " + definition.ID;
			local result = ::Brotherhood.scoreWheelProfile(profile, snapshot, factors);
			if (!result.Eligible) continue;
			candidates.push({ Definition = definition, Profile = profile, Result = result });
		}

		if (candidates.len() == 0)
		{
			throw "Brotherhood Wheel of Fortune could not find an eligible unique archetype for slot " + (slot + 1).tostring();
		}

		local picked = candidates.remove(::Brotherhood.selectWeightedWheelCandidate(candidates));
		selected.push(picked.Definition);
		pool.remove(pool.find(picked.Definition));
		::Brotherhood.consumeWheelStrongSignals(factors, picked.Result.StrongSignals);
		local slotLabel = slot < slotLabels.len() ? slotLabels[slot] : "Slot " + (slot + 1).tostring();
		rounds.push({ Slot = slot + 1, Label = slotLabel, ID = picked.Definition.ID, Name = picked.Definition.Name, Score = picked.Result.Score, Reasons = picked.Result.Reasons, ConsumedSignals = picked.Result.StrongSignals });
		::logInfo("[Brotherhood][WheelOfFortune] " + slotLabel + " selected " + picked.Definition.Name + " (weight " + picked.Result.Score.tostring() + "); reasons: [" + ::Brotherhood.formatIDsForLog(picked.Result.Reasons) + "]; partially consumed: [" + ::Brotherhood.formatIDsForLog(picked.Result.StrongSignals) + "]");
	}

	_perkTree.m.BH_WheelSnapshot <- snapshot;
	_perkTree.m.BH_WheelRemainingSignalFactors <- factors;
	_perkTree.m.BH_WheelSelectionRounds <- rounds;
	return selected;
}

::Brotherhood.validateWheelProfiles <- function()
{
	local seen = {};
	foreach (profile in ::Brotherhood.WheelProfiles)
	{
		if (profile.ID in seen) throw "Brotherhood Wheel profile list contains duplicate ID: " + profile.ID;
		seen[profile.ID] <- true;
	}
	foreach (definition in ::Brotherhood.TemporaryArchetypeTestPool)
	{
		if (::Brotherhood.getWheelProfileByID(definition.ID) == null) throw "Brotherhood generation pool entry is missing a Wheel profile: " + definition.ID;
	}
}

// Compatibility entry point retained for the existing generator. The debug
// path remains deterministic; ordinary generation always uses weighted Wheel
// selection and requires the PerkTree so projected level-11 stats are usable.
::Brotherhood.selectTemporaryArchetypes <- function( _perkTree )
{
	if (::Brotherhood.TestingMode && ::Brotherhood.DebugForceCurrentObsidianArchetypes)
	{
		local forced = [];
		foreach (archetypeID in ::Brotherhood.getCurrentObsidianDebugSpawn().ArchetypeIDs)
		{
			if (!::Brotherhood.isArchetypeEnabled(archetypeID)) continue;
			foreach (definition in ::Brotherhood.TemporaryArchetypeTestPool)
			{
				if (definition.ID != archetypeID) continue;
				forced.push(definition);
				break;
			}
			if (forced.len() >= ::Brotherhood.GeneratedArchetypeCount) break;
		}
		return forced;
	}
	return ::Brotherhood.selectWheelArchetypes(_perkTree);
}
