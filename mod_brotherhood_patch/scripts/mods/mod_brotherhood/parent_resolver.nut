if (!("Brotherhood" in getroottable())) return;

// Anchor-led shared-future parent selection. Behavioral mirror of the
// Fleshcrafting Economy Simulator parent_scoring.select_parents pipeline.
// Intentional RNG mismatch vs Python: Anchor weighted draws and fitness-cutoff
// ties use ::Brotherhood.ParentRNG (Park-Miller) over sorted candidate IDs,
// not blake2b. Parity fixtures inject Screens + ForcedAnchorID so selection
// outcomes do not depend on that draw.

::Brotherhood.ParentAttributes <- [
	{ Name="hitpoints_max", Index=0, Minimum=2, Maximum=4 },
	{ Name="resolve", Index=1, Minimum=2, Maximum=4 },
	{ Name="fatigue", Index=2, Minimum=2, Maximum=4 },
	{ Name="initiative", Index=3, Minimum=3, Maximum=5 },
	{ Name="melee_skill", Index=4, Minimum=1, Maximum=3 },
	{ Name="ranged_skill", Index=5, Minimum=2, Maximum=4 },
	{ Name="melee_defense", Index=6, Minimum=1, Maximum=3 },
	{ Name="ranged_defense", Index=7, Minimum=2, Maximum=4 }
];

::Brotherhood.ParentLevelChoices <- [];
for (local first = 0; first < 6; ++first)
	for (local second = first + 1; second < 7; ++second)
		for (local third = second + 1; third < 8; ++third)
			::Brotherhood.ParentLevelChoices.push([first, second, third]);

::Brotherhood.ParentSecondaryAttributePriority <- {
	melee_defense = 8,
	hitpoints_max = 7,
	resolve = 6,
	fatigue = 5,
	ranged_defense = 4,
	initiative = 3,
	melee_skill = 2,
	ranged_skill = 1
};

::Brotherhood.ParentTraitStatAffinities <- {
	Brave = "resolve",
	["trait.brave"] = "resolve",
	Dexterous = "melee_skill",
	["trait.dexterous"] = "melee_skill",
	Quick = "initiative",
	["trait.quick"] = "initiative",
	Strong = "fatigue",
	["trait.strong"] = "fatigue",
	Tough = "hitpoints_max",
	["trait.tough"] = "hitpoints_max"
};

::Brotherhood.ParentRecognitionEvidencePercentile <- 0.65;
::Brotherhood.ParentRecognitionQualifyingPercentile <- 0.75;
::Brotherhood.ParentRecognitionMinimum <- 0.12;
::Brotherhood.ParentReachabilityMinimum <- 0.75;
::Brotherhood.ParentRoutingScale <- 0.10;
::Brotherhood.ParentDefaultGroupOverlapMultipliers <- { [0]=1.0, [1]=1.0, [2]=0.25, [3]=0.05, [4]=0.0 };
::Brotherhood.ParentSaturationBeamWidth <- 64;

::Brotherhood.parentCloneStats <- function( _stats )
{
	local ret = {};
	foreach (name, value in _stats) ret[name] <- value;
	return ret;
}

::Brotherhood.parentJoin <- function( _items, _separator )
{
	local ret = "";
	foreach (item in _items)
	{
		if (ret != "") ret += _separator;
		ret += item.tostring();
	}
	return ret;
}

::Brotherhood.parentGetStatSpec <- function( _profile, _name )
{
	foreach (stat in _profile.Stats) if (stat.Name == _name) return stat;
	return null;
}

::Brotherhood.parentInterpolate <- function( _value, _leftX, _rightX, _leftY, _rightY )
{
	if (_leftX == _rightX) return ::Math.maxf(_leftY, _rightY);
	return _leftY + ((_value - _leftX) / (_rightX - _leftX).tofloat()) * (_rightY - _leftY);
}

::Brotherhood.parentIsAttribute <- function( _name )
{
	foreach (attribute in ::Brotherhood.ParentAttributes)
		if (attribute.Name == _name) return true;
	return false;
}

::Brotherhood.parentBodyHasTrait <- function( _body, _key )
{
	if ("TraitNames" in _body)
		foreach (name in _body.TraitNames) if (name == _key) return true;
	if ("TraitIDs" in _body)
		foreach (id in _body.TraitIDs) if (id == _key) return true;
	if ("Traits" in _body)
		foreach (trait in _body.Traits) if (trait == _key) return true;
	return false;
}

::Brotherhood.parentExpectedGain <- function( _body, _attributeName )
{
	local stars = _attributeName in _body.Stars ? _body.Stars[_attributeName] : 0;
	foreach (attribute in ::Brotherhood.ParentAttributes)
	{
		if (attribute.Name != _attributeName) continue;
		local minimum = attribute.Minimum + (stars == 3 ? 2 : stars);
		local maximum = attribute.Maximum + (stars == 3 ? 1 : 0);
		return (minimum + maximum).tofloat() * 0.5;
	}
	throw "unknown parent attribute " + _attributeName;
}

::Brotherhood.parentScoreStat <- function( _stats, _spec )
{
	if (!(_spec.Name in _stats)) return { StatName=_spec.Name, Actual=null, Fitness=null, Band="missing", Eligible=false, Rejection="missing required stat " + _spec.Name };
	local actual = _stats[_spec.Name].tofloat();
	if (_spec.IneligibleBelow != null && actual < _spec.IneligibleBelow)
		return { StatName=_spec.Name, Actual=actual, Fitness=null, Band="below eligibility floor", Eligible=false, Rejection=_spec.Name + " is below its eligibility floor" };
	foreach (field in ["Bad", "Acceptable", "Great", "Premium"])
		if (!(field in _spec) || _spec[field] == null) return { StatName=_spec.Name, Actual=actual, Fitness=null, Band="missing thresholds", Eligible=false, Rejection=_spec.Name + " is missing fitness thresholds" };

	local raw = [[_spec.Bad.tofloat(), 1.0, "bad"], [_spec.Acceptable.tofloat(), 2.0, "acceptable"], [_spec.Great.tofloat(), 3.0, "great"], [_spec.Premium.tofloat(), 4.0, "premium"]];
	local coordinate = _spec.Direction == "higher" ? actual : -actual;
	local points = [];
	foreach (point in raw) points.push([_spec.Direction == "higher" ? point[0] : -point[0], point[1], point[2]]);
	points.sort(@(_left, _right) _left[0] <=> _right[0]);
	if (coordinate >= points.top()[0]) return { StatName=_spec.Name, Actual=actual, Fitness=points.top()[1], Band=points.top()[2], Eligible=true, Rejection=null };
	if (coordinate < points[0][0]) return { StatName=_spec.Name, Actual=actual, Fitness=0.0, Band="below bad", Eligible=true, Rejection=null };
	for (local i = 0; i < points.len() - 1; ++i)
	{
		local left = points[i];
		local right = points[i + 1];
		if (left[0] <= coordinate && coordinate <= right[0])
		{
			local fitness = coordinate == left[0] ? left[1] : (coordinate == right[0] ? right[1] : ::Brotherhood.parentInterpolate(coordinate, left[0], right[0], left[1], right[1]));
			local band = coordinate == left[0] ? left[2] : (coordinate == right[0] ? right[2] : left[2] + " -> " + right[2]);
			return { StatName=_spec.Name, Actual=actual, Fitness=fitness, Band=band, Eligible=true, Rejection=null };
		}
	}
	throw "parent fitness interpolation did not cover " + _spec.Name;
}

::Brotherhood.parentRoutingFitness <- function( _actual, _threshold )
{
	if (_actual == null || _actual >= _threshold) return 0.0;
	return ::Math.minf(4.0, ::Math.maxf(0.0, _threshold - _actual));
}

::Brotherhood.parentIsRelationalClaim <- function( _claim )
{
	if ("IsRelational" in _claim && _claim.IsRelational) return true;
	local requires = ("RequiresQualified" in _claim) ? _claim.RequiresQualified : [];
	local excludes = ("ExcludesQualified" in _claim) ? _claim.ExcludesQualified : [];
	return requires.len() > 0 || excludes.len() > 0;
}

::Brotherhood.parentBisectRightMilli <- function( _samples, _value )
{
	local lo = 0;
	local hi = _samples.len();
	while (lo < hi)
	{
		local mid = (lo + hi) / 2;
		if (_samples[mid] <= _value) lo = mid + 1;
		else hi = mid;
	}
	return lo;
}

::Brotherhood.parentPotentialPercentile <- function( _body, _attribute )
{
	local potential = _body.Stats[_attribute].tofloat() + 10.0 * ::Brotherhood.parentExpectedGain(_body, _attribute);
	local calibration = ::Brotherhood.ParentRecognitionCalibration;
	local samples = calibration.Samples[_attribute];
	local scaled = potential * calibration.Scale;
	local percentile = ::Brotherhood.parentBisectRightMilli(samples, scaled).tofloat() / samples.len().tofloat();
	return { Potential=potential, Percentile=percentile };
}

::Brotherhood.parentQualificationPercentile <- function( _body, _statName, _profile )
{
	if (!(_statName in _body.Stats) || !::Brotherhood.parentIsAttribute(_statName)) return null;
	local result = ::Brotherhood.parentPotentialPercentile(_body, _statName);
	local percentile = result.Percentile;
	local spec = ::Brotherhood.parentGetStatSpec(_profile, _statName);
	if (spec != null && spec.Direction == "lower") percentile = 1.0 - percentile;
	return percentile;
}

::Brotherhood.parentRoutingClaimActive <- function( _body, _profile, _claim )
{
	if (::Brotherhood.parentIsRelationalClaim(_claim))
	{
		local requires = _claim.RequiresQualified;
		local excludes = _claim.ExcludesQualified;
		if (requires.len() == 0 || excludes.len() == 0) return false;
		foreach (name in requires)
		{
			local value = ::Brotherhood.parentQualificationPercentile(_body, name, _profile);
			if (value == null || value < ::Brotherhood.ParentRecognitionQualifyingPercentile) return false;
		}
		foreach (name in excludes)
		{
			local value = ::Brotherhood.parentQualificationPercentile(_body, name, _profile);
			if (value == null || value >= ::Brotherhood.ParentRecognitionQualifyingPercentile) return false;
		}
		return true;
	}
	if (_claim.ActivatesBelow == null || _claim.Stat == null) return false;
	if (!(_claim.Stat in _body.Stats)) return false;
	return _body.Stats[_claim.Stat].tofloat() < _claim.ActivatesBelow.tofloat();
}

::Brotherhood.parentRoutingClaimBonus <- function( _bodyOrStats, _claim, _profile = null )
{
	local isBody = typeof _bodyOrStats == "table" && ("Stats" in _bodyOrStats);
	if (::Brotherhood.parentIsRelationalClaim(_claim))
	{
		if (_profile == null || !isBody) return 0.0;
		return ::Brotherhood.parentRoutingClaimActive(_bodyOrStats, _profile, _claim) ? _claim.Importance * ::Brotherhood.ParentRoutingScale : 0.0;
	}
	local stats = isBody ? _bodyOrStats.Stats : _bodyOrStats;
	if (_claim.ActivatesBelow == null || _claim.Stat == null) return 0.0;
	local actual = _claim.Stat in stats ? stats[_claim.Stat].tofloat() : null;
	return ::Brotherhood.parentRoutingFitness(actual, _claim.ActivatesBelow.tofloat()) * _claim.Importance * ::Brotherhood.ParentRoutingScale;
}

::Brotherhood.parentRoutingBonus <- function( _body, _profile )
{
	local total = 0.0;
	foreach (claim in _profile.RoutingClaims) total += ::Brotherhood.parentRoutingClaimBonus(_body, claim, _profile);
	return total;
}

::Brotherhood.parentRoutingNormalizationByStat <- function( _stats, _profile, _counted, _totalImportance )
{
	local values = {};
	if (_totalImportance <= 0) return values;
	foreach (claim in _profile.RoutingClaims)
	{
		if (::Brotherhood.parentIsRelationalClaim(claim)) continue;
		if (claim.ActivatesBelow == null || claim.Stat == null) continue;
		local actual = claim.Stat in _stats ? _stats[claim.Stat].tofloat() : null;
		if (actual == null || actual >= claim.ActivatesBelow.tofloat() || !(claim.Stat in _counted)) continue;
		local spec = ::Brotherhood.parentGetStatSpec(_profile, claim.Stat);
		if (spec == null) continue;
		local boundaryStats = {};
		boundaryStats[claim.Stat] <- claim.ActivatesBelow;
		local boundary = ::Brotherhood.parentScoreStat(boundaryStats, spec);
		local actualMatch = _counted[claim.Stat][0];
		local importance = _counted[claim.Stat][1];
		if (boundary.Fitness == null || actualMatch.Fitness == null) continue;
		local loss = ::Math.maxf(0.0, boundary.Fitness - actualMatch.Fitness) * importance / _totalImportance;
		if (!(claim.Stat in values) || loss > values[claim.Stat]) values[claim.Stat] <- loss;
	}
	return values;
}

::Brotherhood.parentRoutingBonusByStat <- function( _body, _profile )
{
	local values = {};
	foreach (claim in _profile.RoutingClaims)
	{
		local bonus = ::Brotherhood.parentRoutingClaimBonus(_body, claim, _profile);
		if (bonus <= 0) continue;
		if (!::Brotherhood.parentIsRelationalClaim(claim) && claim.Stat != null)
		{
			values[claim.Stat] <- (claim.Stat in values ? values[claim.Stat] : 0.0) + bonus;
			continue;
		}
		local realStats = [];
		foreach (name in claim.RequiresQualified)
		{
			local spec = ::Brotherhood.parentGetStatSpec(_profile, name);
			if (spec != null && spec.Importance > 0) realStats.push(name);
		}
		local total = 0.0;
		foreach (name in realStats) total += ::Brotherhood.parentGetStatSpec(_profile, name).Importance;
		foreach (name in realStats)
			values[name] <- (name in values ? values[name] : 0.0) + bonus * ::Brotherhood.parentGetStatSpec(_profile, name).Importance / total;
	}
	return values;
}

::Brotherhood.parentConjunctiveStatAptitude <- function( _profile, _value )
{
	local model = _profile.ConjunctiveFitness;
	if (model == null) return 0.0;
	return ::Math.minf(4.0, ::Math.maxf(0.0, 1.0 + (_value.tofloat() - model.AptitudeOneAt) / model.AptitudeStep));
}

::Brotherhood.parentConjunctiveSideValues <- function( _profile, _valuesByStat )
{
	local model = _profile.ConjunctiveFitness;
	if (model == null) return [];
	local values = [];
	foreach (side in model.Sides)
	{
		local weighted = [];
		local total = 0.0;
		foreach (member in side.Members)
		{
			if (!(member in _valuesByStat)) continue;
			local spec = ::Brotherhood.parentGetStatSpec(_profile, member);
			if (spec == null || spec.Importance <= 0) continue;
			weighted.push([_valuesByStat[member].tofloat(), spec.Importance]);
			total += spec.Importance;
		}
		local sideValue = 0.0;
		if (total > 0)
			foreach (pair in weighted) sideValue += pair[0] * pair[1] / total;
		values.push({ Name=side.Name, Value=sideValue });
	}
	return values;
}

::Brotherhood.parentConjunctiveSideScores <- function( _profile, _valuesByStat )
{
	local ret = [];
	foreach (side in ::Brotherhood.parentConjunctiveSideValues(_profile, _valuesByStat))
		ret.push({ Name=side.Name, Value=::Brotherhood.parentConjunctiveStatAptitude(_profile, side.Value) });
	return ret;
}

::Brotherhood.parentConjunctiveCombinedFitness <- function( _profile, _sideScores )
{
	local model = _profile.ConjunctiveFitness;
	if (model == null || _sideScores.len() == 0) return 0.0;
	local values = [];
	foreach (side in _sideScores) values.push(side.Value);
	local weaker = values[0];
	local stronger = values[0];
	foreach (value in values)
	{
		if (value < weaker) weaker = value;
		if (value > stronger) stronger = value;
	}
	return weaker * model.WeakerWeight + stronger * model.StrongerWeight;
}

::Brotherhood.parentConjunctiveProjectedStats <- function( _body, _profile, _screens = null )
{
	local model = _profile.ConjunctiveFitness;
	if (model == null) return {};
	local members = {};
	foreach (side in model.Sides) foreach (member in side.Members) members[member] <- true;
	local increases = {};
	if (_screens == null && (!("Seed" in _body) || _body.Seed == null))
	{
		foreach (name, _ignored in members)
			increases[name] <- 10.0 * ::Brotherhood.parentExpectedGain(_body, name);
	}
	else
	{
		local screens = _screens == null ? ::Brotherhood.parentGenerateRollSheets(_body.Seed, _body.Stars) : _screens;
		foreach (name, _ignored in members)
		{
			local total = 0.0;
			foreach (screen in screens) total += screen.Rolls[name];
			increases[name] <- total;
		}
	}
	local projected = {};
	foreach (name, _ignored in members)
		projected[name] <- _body.Stats[name].tofloat() + increases[name];
	return projected;
}

::Brotherhood.parentEmptyScoreExtras <- function()
{
	return { AptitudeScores=[], AptitudeMinimum=null, AptitudePasses=[], AptitudeSourceValues=[], RankingFitness=null, SaturationAdjustments=[] };
}

::Brotherhood.parentScore <- function( _statsOrBody, _profile, _enforceConjunctive = true )
{
	local isBody = typeof _statsOrBody == "table" && ("Stats" in _statsOrBody);
	local stats = isBody ? _statsOrBody.Stats : _statsOrBody;
	local bodyForRouting = isBody ? _statsOrBody : { Stats=stats, Stars={}, TraitNames=[], TraitIDs=[], Seed=null };
	local grouped = {};
	foreach (group in _profile.Alternatives) foreach (member in group.Members) grouped[member] <- true;
	local contributions = [];
	local rejections = [];

	foreach (group in _profile.Alternatives)
	{
		local eligible = [];
		local matches = [];
		foreach (member in group.Members)
		{
			local spec = ::Brotherhood.parentGetStatSpec(_profile, member);
			if (spec == null || spec.Importance <= 0) continue;
			local match = ::Brotherhood.parentScoreStat(stats, spec);
			matches.push(match);
			if (match.Eligible && match.Fitness != null) eligible.push([match, spec]);
		}
		if (matches.len() == 0) continue;
		if (eligible.len() == 0)
		{
			rejections.push("alternative group " + group.Name + " rejected");
			continue;
		}
		local winner = eligible[0];
		foreach (candidate in eligible)
			if (candidate[0].Fitness > winner[0].Fitness || (candidate[0].Fitness == winner[0].Fitness && candidate[0].StatName > winner[0].StatName)) winner = candidate;
		contributions.push({ Label=group.Name, StatName=winner[0].StatName, Match=winner[0], Importance=winner[1].Importance, WeightedFitness=winner[0].Fitness * winner[1].Importance, AlternativeGroup=group.Name, Alternatives=matches });
	}

	foreach (spec in _profile.Stats)
	{
		if (spec.Importance <= 0 || spec.Name in grouped) continue;
		local match = ::Brotherhood.parentScoreStat(stats, spec);
		if (!match.Eligible || match.Fitness == null)
		{
			rejections.push(match.Rejection == null ? spec.Name + " could not be scored" : match.Rejection);
			continue;
		}
		contributions.push({ Label=spec.Name, StatName=spec.Name, Match=match, Importance=spec.Importance, WeightedFitness=match.Fitness * spec.Importance, AlternativeGroup=null, Alternatives=[] });
	}

	local extras = ::Brotherhood.parentEmptyScoreExtras();
	if (rejections.len() != 0)
		return { Profile=_profile, Eligible=false, ParentFitness=null, DevelopmentValue=-1000000.0, TotalImportance=0.0, BaseFitness=null, RoutingBonus=0.0, RoutingNormalization=0.0, Contributions=contributions, Rejections=rejections, RankingFitness=null, SaturationAdjustments=[], AptitudeScores=extras.AptitudeScores, AptitudeMinimum=extras.AptitudeMinimum, AptitudePasses=extras.AptitudePasses, AptitudeSourceValues=extras.AptitudeSourceValues };

	local totalImportance = 0.0;
	local weightedSum = 0.0;
	local counted = {};
	foreach (item in contributions)
	{
		totalImportance += item.Importance;
		weightedSum += item.WeightedFitness;
		counted[item.StatName] <- [item.Match, item.Importance];
	}
	if (totalImportance <= 0)
		return { Profile=_profile, Eligible=false, ParentFitness=null, DevelopmentValue=-1000000.0, TotalImportance=0.0, BaseFitness=null, RoutingBonus=0.0, RoutingNormalization=0.0, Contributions=contributions, Rejections=["profile has no countable positive importance"], RankingFitness=null, SaturationAdjustments=[], AptitudeScores=[], AptitudeMinimum=null, AptitudePasses=[], AptitudeSourceValues=[] };

	local baseFitness = weightedSum / totalImportance;
	local aptitudeSourceValues = ::Brotherhood.parentConjunctiveSideValues(_profile, stats);
	local aptitudeScores = ::Brotherhood.parentConjunctiveSideScores(_profile, stats);
	local aptitudeMinimum = null;
	local aptitudePasses = [];
	if (_profile.ConjunctiveFitness != null)
	{
		aptitudeMinimum = ::Brotherhood.parentConjunctiveStatAptitude(_profile, _profile.ConjunctiveFitness.DeadSideBelow);
		foreach (side in aptitudeSourceValues)
			aptitudePasses.push({ Name=side.Name, Passed=side.Value >= _profile.ConjunctiveFitness.DeadSideBelow });
		baseFitness = ::Brotherhood.parentConjunctiveCombinedFitness(_profile, aptitudeScores);
		if (_enforceConjunctive)
		{
			local allPassed = true;
			local failed = [];
			foreach (item in aptitudePasses)
			{
				if (!item.Passed)
				{
					allPassed = false;
					failed.push(item.Name);
				}
			}
			if (!allPassed)
				return { Profile=_profile, Eligible=false, ParentFitness=null, DevelopmentValue=-1000000.0, TotalImportance=totalImportance, BaseFitness=null, RoutingBonus=0.0, RoutingNormalization=0.0, Contributions=contributions, Rejections=["conjunctive aptitude below " + aptitudeMinimum + ": " + ::Brotherhood.parentJoin(failed, ", ")], RankingFitness=null, SaturationAdjustments=[], AptitudeScores=aptitudeScores, AptitudeMinimum=aptitudeMinimum, AptitudePasses=aptitudePasses, AptitudeSourceValues=aptitudeSourceValues };
		}
	}

	local normalizationByStat = ::Brotherhood.parentRoutingNormalizationByStat(stats, _profile, counted, totalImportance);
	local routingNormalization = 0.0;
	foreach (value in normalizationByStat) routingNormalization += value;
	local routingBonus = ::Brotherhood.parentRoutingBonus(bodyForRouting, _profile);
	local finalFitness = ::Math.minf(4.0, baseFitness + routingNormalization + routingBonus);
	return {
		Profile=_profile, Eligible=true, ParentFitness=finalFitness, DevelopmentValue=finalFitness, TotalImportance=totalImportance,
		BaseFitness=baseFitness, RoutingBonus=routingBonus, RoutingNormalization=routingNormalization, Contributions=contributions, Rejections=[],
		RankingFitness=null, SaturationAdjustments=[], AptitudeScores=aptitudeScores, AptitudeMinimum=aptitudeMinimum, AptitudePasses=aptitudePasses, AptitudeSourceValues=aptitudeSourceValues
	};
}

::Brotherhood.parentRankingFitness <- function( _score )
{
	if ("RankingFitness" in _score && _score.RankingFitness != null) return _score.RankingFitness;
	return _score.ParentFitness == null ? 0.0 : _score.ParentFitness.tofloat();
}

::Brotherhood.parentGenerateRollSheets <- function( _seed, _stars )
{
	local state = ::Brotherhood.ParentRNG.create(::Brotherhood.ParentRNG.deriveSeed(_seed, "brotherhood-parent-career-v1"));
	local screens = [];
	for (local level = 2; level <= 11; ++level)
	{
		local rolls = {};
		local ordered = [];
		foreach (attribute in ::Brotherhood.ParentAttributes)
		{
			local stars = attribute.Name in _stars ? _stars[attribute.Name] : 0;
			if (stars < 0 || stars > 3) throw "invalid talent stars for " + attribute.Name;
			local minimum = attribute.Minimum + (stars == 3 ? 2 : stars);
			local maximum = attribute.Maximum + (stars == 3 ? 1 : 0);
			local value = ::Brotherhood.ParentRNG.nextInt(state, minimum, maximum);
			rolls[attribute.Name] <- value;
			ordered.push(value);
		}
		screens.push({ Level=level, Rolls=rolls, Ordered=ordered });
	}
	return screens;
}

::Brotherhood.parentRollSheetFingerprint <- function( _screens )
{
	local parts = [];
	foreach (screen in _screens)
	{
		local values = [];
		foreach (value in screen.Ordered) values.push(value.tostring());
		parts.push(screen.Level + ":" + ::Brotherhood.parentJoin(values, ","));
	}
	return ::Brotherhood.parentJoin(parts, "|");
}

::Brotherhood.parentGapToThreshold <- function( _value, _spec, _threshold )
{
	local target = null;
	if (_threshold == "great") target = _spec.Great;
	else if (_threshold == "premium") target = _spec.Premium;
	else if (_threshold == "acceptable") target = _spec.Acceptable;
	else if (_threshold == "bad") target = _spec.Bad;
	if (target == null) return 0.0;
	if (_spec.Direction == "lower") return ::Math.maxf(0.0, _value.tofloat() - target.tofloat());
	return ::Math.maxf(0.0, target.tofloat() - _value.tofloat());
}

::Brotherhood.parentChosenDevelopmentSpecs <- function( _body, _profile, _preferredAlternatives = null )
{
	local grouped = {};
	foreach (group in _profile.Alternatives) foreach (member in group.Members) grouped[member] <- true;
	local chosen = [];
	foreach (group in _profile.Alternatives)
	{
		local preferred = null;
		if (_preferredAlternatives != null && group.Name in _preferredAlternatives) preferred = _preferredAlternatives[group.Name];
		local candidates = [];
		foreach (name in group.Members)
		{
			local spec = ::Brotherhood.parentGetStatSpec(_profile, name);
			if (spec == null || spec.Importance <= 0 || !(name in _body.Stats) || !::Brotherhood.parentIsAttribute(name)) continue;
			local gap = ::Brotherhood.parentGapToThreshold(_body.Stats[name], spec, "great");
			local gain = ::Brotherhood.parentExpectedGain(_body, name);
			candidates.push([gap / gain, name, spec]);
		}
		if (candidates.len() == 0) continue;
		local selected = null;
		if (preferred != null)
			foreach (item in candidates) if (item[1] == preferred) { selected = item; break; }
		if (selected == null)
		{
			selected = candidates[0];
			foreach (item in candidates)
				if (item[0] < selected[0] || (item[0] == selected[0] && item[1] < selected[1])) selected = item;
		}
		chosen.push({ Name=selected[1], Spec=selected[2], Group=group.Name });
	}
	foreach (spec in _profile.Stats)
	{
		if (spec.Importance <= 0 || spec.Name in grouped) continue;
		if (!(spec.Name in _body.Stats) || !::Brotherhood.parentIsAttribute(spec.Name)) continue;
		chosen.push({ Name=spec.Name, Spec=spec, Group=null });
	}
	return chosen;
}

::Brotherhood.parentRecognitionContribution <- function( _body, _name, _spec, _group = null )
{
	local potentialInfo = ::Brotherhood.parentPotentialPercentile(_body, _name);
	local percentile = potentialInfo.Percentile;
	if (_spec.Direction == "lower") percentile = 1.0 - percentile;
	local evidence = ::Math.maxf(0.0, (percentile - ::Brotherhood.ParentRecognitionEvidencePercentile) / (1.0 - ::Brotherhood.ParentRecognitionEvidencePercentile));
	return {
		Label=_group == null ? _name : _group,
		StatName=_name,
		Actual=_body.Stats[_name].tofloat(),
		Stars=_name in _body.Stars ? _body.Stars[_name] : 0,
		Potential=potentialInfo.Potential,
		Percentile=percentile,
		Importance=_spec.Importance,
		Evidence=evidence,
		AlternativeGroup=_group
	};
}

::Brotherhood.calculateInnateRecognition <- function( _body, _profile, _screens = null )
{
	local grouped = {};
	foreach (group in _profile.Alternatives) foreach (member in group.Members) grouped[member] <- true;
	local contributions = [];
	foreach (group in _profile.Alternatives)
	{
		local options = [];
		foreach (name in group.Members)
		{
			local spec = ::Brotherhood.parentGetStatSpec(_profile, name);
			if (spec == null || spec.Importance <= 0 || !(name in _body.Stats) || !::Brotherhood.parentIsAttribute(name)) continue;
			options.push(::Brotherhood.parentRecognitionContribution(_body, name, spec, group.Name));
		}
		if (options.len() == 0) continue;
		local best = options[0];
		foreach (item in options)
			if (item.Percentile > best.Percentile || (item.Percentile == best.Percentile && (item.Evidence > best.Evidence || (item.Evidence == best.Evidence && item.StatName > best.StatName)))) best = item;
		contributions.push(best);
	}
	foreach (spec in _profile.Stats)
	{
		if (spec.Importance <= 0 || spec.Name in grouped) continue;
		if (!(spec.Name in _body.Stats) || !::Brotherhood.parentIsAttribute(spec.Name)) continue;
		contributions.push(::Brotherhood.parentRecognitionContribution(_body, spec.Name, spec, null));
	}

	local totalImportance = 0.0;
	local numerical = 0.0;
	foreach (item in contributions)
	{
		totalImportance += item.Importance;
		numerical += item.Evidence * item.Importance;
	}
	if (totalImportance > 0) numerical = numerical / totalImportance;

	local traitEvidence = [];
	foreach (trait, statName in ::Brotherhood.ParentTraitStatAffinities)
	{
		if (!::Brotherhood.parentBodyHasTrait(_body, trait)) continue;
		foreach (item in contributions)
			if (item.StatName == statName)
			{
				traitEvidence.push(trait + " supports " + statName);
				break;
			}
	}
	local claimEvidence = [];
	foreach (claim in _profile.RoutingClaims)
	{
		if (::Brotherhood.parentIsRelationalClaim(claim)) continue;
		if (claim.ActivatesBelow == null || claim.Stat == null) continue;
		if (!(claim.Stat in _body.Stats)) continue;
		if (_body.Stats[claim.Stat].tofloat() < claim.ActivatesBelow.tofloat())
			claimEvidence.push(claim.Name + ": " + claim.Stat + " below " + claim.ActivatesBelow);
	}

	local aptitudeScores = [];
	local aptitudeMinimum = null;
	local aptitudePasses = [];
	local aptitudeSourceValues = [];

	if (_profile.ConjunctiveFitness != null)
	{
		local projectedStats = ::Brotherhood.parentConjunctiveProjectedStats(_body, _profile, _screens);
		aptitudeSourceValues = ::Brotherhood.parentConjunctiveSideValues(_profile, projectedStats);
		aptitudeScores = ::Brotherhood.parentConjunctiveSideScores(_profile, projectedStats);
		aptitudeMinimum = _profile.ConjunctiveFitness.MinimumProjectedSide;
		local qualifiedProjection = aptitudeSourceValues.len() > 0;
		foreach (side in aptitudeSourceValues)
		{
			local passed = side.Value >= aptitudeMinimum;
			aptitudePasses.push({ Name=side.Name, Passed=passed });
			if (!passed) qualifiedProjection = false;
		}
		local evidenceByStat = {};
		foreach (item in contributions) evidenceByStat[item.StatName] <- item.Evidence;
		local evidenceSides = ::Brotherhood.parentConjunctiveSideValues(_profile, evidenceByStat);
		local boundedBonus = ::Math.minf(0.10, 0.025 * traitEvidence.len() + 0.05 * claimEvidence.len());
		local value = ::Math.minf(1.0, ::Brotherhood.parentConjunctiveCombinedFitness(_profile, evidenceSides) + boundedBonus);
		local reason = "";
		if (qualifiedProjection)
		{
			local parts = [];
			foreach (side in aptitudeSourceValues) parts.push(side.Name + " " + ::format("%.1f", side.Value));
			reason = "original Hybrid projection passes: " + ::Brotherhood.parentJoin(parts, ", ");
		}
		else
		{
			local failed = [];
			foreach (side in aptitudeSourceValues)
				if (side.Value < aptitudeMinimum) failed.push(side.Name + " " + ::format("%.1f", side.Value));
			reason = "original Hybrid projection below " + ::format("%.1f", aptitudeMinimum) + ": " + ::Brotherhood.parentJoin(failed, ", ");
		}
		return {
			Profile=_profile, Value=value, Qualified=qualifiedProjection, Contributions=contributions,
			TraitEvidence=traitEvidence, ClaimEvidence=claimEvidence, Reason=reason,
			AptitudeScores=aptitudeScores, AptitudeMinimum=aptitudeMinimum, AptitudePasses=aptitudePasses, AptitudeSourceValues=aptitudeSourceValues
		};
	}

	local boundedBonus = ::Math.minf(0.10, 0.025 * traitEvidence.len() + 0.05 * claimEvidence.len());
	local value = ::Math.minf(1.0, numerical + boundedBonus);
	local strongestPercentile = 0.0;
	foreach (item in contributions) if (item.Percentile > strongestPercentile) strongestPercentile = item.Percentile;
	local distinctive = [];
	foreach (item in contributions)
		if (item.Percentile >= ::Brotherhood.ParentRecognitionQualifyingPercentile) distinctive.push(item);
	local compositeHasIdentity = false;
	foreach (item in distinctive) if (item.AlternativeGroup == null) { compositeHasIdentity = true; break; }
	if (!compositeHasIdentity && distinctive.len() >= 2) compositeHasIdentity = true;
	local qualified = value >= ::Brotherhood.ParentRecognitionMinimum && strongestPercentile >= ::Brotherhood.ParentRecognitionQualifyingPercentile && compositeHasIdentity;
	local reason = "";
	if (qualified) reason = "meaningful evidence " + ::format("%.3f", value) + "; strongest percentile " + ::format("%.1f", strongestPercentile * 100.0) + "%";
	else if (strongestPercentile < ::Brotherhood.ParentRecognitionQualifyingPercentile) reason = "no defining stat reached the " + ::format("%.0f", ::Brotherhood.ParentRecognitionQualifyingPercentile * 100.0) + "% evidence tier";
	else if (!compositeHasIdentity) reason = "a composite attack alternative alone is compatibility, not parent identity";
	else reason = "weighted evidence " + ::format("%.3f", value) + " below " + ::format("%.3f", ::Brotherhood.ParentRecognitionMinimum);
	return {
		Profile=_profile, Value=value, Qualified=qualified, Contributions=contributions,
		TraitEvidence=traitEvidence, ClaimEvidence=claimEvidence, Reason=reason,
		AptitudeScores=aptitudeScores, AptitudeMinimum=aptitudeMinimum, AptitudePasses=aptitudePasses, AptitudeSourceValues=aptitudeSourceValues
	};
}

::Brotherhood.estimateReachability <- function( _body, _profile, _recognition = null, _screens = null )
{
	local recognition = _recognition == null ? ::Brotherhood.calculateInnateRecognition(_body, _profile, _screens) : _recognition;
	local preferred = {};
	foreach (item in recognition.Contributions) if (item.AlternativeGroup != null) preferred[item.Label] <- item.StatName;
	local criteria = ::Brotherhood.parentChosenDevelopmentSpecs(_body, _profile, preferred);
	local raw = [];
	foreach (item in criteria)
	{
		local gap = ::Brotherhood.parentGapToThreshold(_body.Stats[item.Name], item.Spec, "great");
		local needed = 0;
		if (gap > 0)
		{
			if (item.Spec.Direction == "lower") needed = 11;
			else needed = ::Math.ceil(gap / ::Brotherhood.parentExpectedGain(_body, item.Name)).tointeger();
		}
		raw.push({ Label=item.Group == null ? item.Name : item.Group, Name=item.Name, Needed=needed, Gap=gap, Importance=item.Spec.Importance, Gain=::Brotherhood.parentExpectedGain(_body, item.Name) });
	}
	local allocations = {};
	foreach (item in raw) allocations[item.Name] <- 0;
	local remaining = 30;
	while (remaining > 0)
	{
		local options = [];
		foreach (item in raw)
		{
			local cap = ::Math.min(10, item.Needed);
			if (allocations[item.Name] >= cap) continue;
			local score = item.Importance / ::Math.max(1, item.Needed).tofloat();
			options.push([score, item.Importance, -item.Needed, item.Name]);
		}
		if (options.len() == 0) break;
		local best = options[0];
		foreach (option in options)
			if (option[0] > best[0] || (option[0] == best[0] && (option[1] > best[1] || (option[1] == best[1] && (option[2] > best[2] || (option[2] == best[2] && option[3] > best[3])))))) best = option;
		allocations[best[3]] += 1;
		remaining -= 1;
	}
	local rows = [];
	local weightedSatisfaction = 0.0;
	local totalImportance = 0.0;
	local minimumSatisfaction = 1.0;
	local allocatedTotal = 0;
	foreach (item in raw)
	{
		local allocated = allocations[item.Name];
		allocatedTotal += allocated;
		local satisfaction = item.Needed == 0 ? 1.0 : ::Math.minf(1.0, allocated.tofloat() / item.Needed.tofloat());
		weightedSatisfaction += satisfaction * item.Importance;
		totalImportance += item.Importance;
		if (satisfaction < minimumSatisfaction) minimumSatisfaction = satisfaction;
		rows.push({ Label=item.Label, StatName=item.Name, Needed=item.Needed, Allocated=allocated, RemainingGap=::Math.maxf(0.0, item.Gap - allocated * item.Gain), Importance=item.Importance });
	}
	local value = totalImportance > 0 ? weightedSatisfaction / totalImportance : 0.0;
	local required = 0;
	local impossibleStat = false;
	foreach (item in raw)
	{
		required += item.Needed;
		if (item.Needed > 10) impossibleStat = true;
	}
	local qualified = value >= ::Brotherhood.ParentReachabilityMinimum && minimumSatisfaction >= 0.50;
	local conjunctiveUnreachable = [];
	if (_profile.ConjunctiveFitness != null)
	{
		local projectedValues = ::Brotherhood.parentConjunctiveProjectedStats(_body, _profile, _screens);
		local projectedSides = ::Brotherhood.parentConjunctiveSideValues(_profile, projectedValues);
		foreach (side in projectedSides)
			if (side.Value < _profile.ConjunctiveFitness.MinimumProjectedSide) conjunctiveUnreachable.push(side.Name);
		if (conjunctiveUnreachable.len() != 0) qualified = false;
	}
	local reason = "";
	if (conjunctiveUnreachable.len() != 0)
		reason = "conjunctive minimum side remains unreachable on the seeded ten-level screens: " + ::Brotherhood.parentJoin(conjunctiveUnreachable, ", ");
	else if (minimumSatisfaction < 0.50)
		reason = "a defining great requirement is only " + ::format("%.1f", minimumSatisfaction * 100.0) + "% reachable within its ten-pick cap";
	else if (value < ::Brotherhood.ParentReachabilityMinimum)
		reason = "only " + ::format("%.1f", value * 100.0) + "% of importance-weighted great requirements fit the thirty-pick budget";
	else
		reason = ::format("%.1f", value * 100.0) + "% of great requirements reachable within " + allocatedTotal + " allocated picks" + (impossibleStat ? "; some individual great gaps remain beyond ten picks" : "");
	return { Profile=_profile, Value=value, Qualified=qualified, Required=required, Allocated=allocatedTotal, Rows=rows, Reason=reason };
}

::Brotherhood.estimateDevelopmentCost <- function( _body, _profile, _screens = null )
{
	local starting = ::Brotherhood.parentScore(_body, _profile, false);
	local recognition = ::Brotherhood.calculateInnateRecognition(_body, _profile, _screens);
	local preferred = {};
	foreach (item in recognition.Contributions) if (item.AlternativeGroup != null) preferred[item.Label] <- item.StatName;
	local criteria = ::Brotherhood.parentChosenDevelopmentSpecs(_body, _profile, preferred);
	local criterionCosts = [];
	local weightedCost = 0.0;
	local totalImportance = 0.0;
	foreach (item in criteria)
	{
		local gap = ::Brotherhood.parentGapToThreshold(_body.Stats[item.Name], item.Spec, "great");
		local picks = 0.0;
		if (item.Spec.Direction == "lower" && gap > 0) picks = 10.0 + gap;
		else picks = gap / ::Brotherhood.parentExpectedGain(_body, item.Name);
		weightedCost += picks * item.Spec.Importance;
		totalImportance += item.Spec.Importance;
		criterionCosts.push({ Label=item.Group == null ? item.Name : item.Group, Gap=gap, Picks=picks });
	}
	local cost = totalImportance > 0 ? weightedCost / totalImportance : 1000000.0;
	local activeClaims = [];
	foreach (claim in _profile.RoutingClaims)
		if (::Brotherhood.parentRoutingClaimActive(_body, _profile, claim)) activeClaims.push(claim.Name);
	local startFit = 0.0;
	if (_profile.ConjunctiveFitness != null)
	{
		local projected = ::Brotherhood.parentConjunctiveProjectedStats(_body, _profile, _screens);
		local projectedBody = { Stats=projected, Stars=_body.Stars, TraitNames=("TraitNames" in _body) ? _body.TraitNames : [], TraitIDs=("TraitIDs" in _body) ? _body.TraitIDs : [], Seed=_body.Seed };
		local projectedScore = ::Brotherhood.parentScore(projectedBody, _profile, false);
		startFit = projectedScore.ParentFitness == null ? 0.0 : projectedScore.ParentFitness.tofloat();
	}
	else startFit = starting.ParentFitness == null ? 0.0 : starting.ParentFitness.tofloat();
	local traitAffinity = 0.0;
	foreach (trait, statName in ::Brotherhood.ParentTraitStatAffinities)
	{
		if (!::Brotherhood.parentBodyHasTrait(_body, trait)) continue;
		local spec = ::Brotherhood.parentGetStatSpec(_profile, statName);
		if (spec != null) traitAffinity += spec.Importance;
	}
	local reachability = ::Brotherhood.estimateReachability(_body, _profile, recognition, _screens);
	local anchorRecognitionQualified = recognition.Qualified;
	if (_profile.ConjunctiveFitness != null)
	{
		local evidenceByStat = {};
		foreach (item in recognition.Contributions) evidenceByStat[item.StatName] <- item.Evidence;
		local anchorEvidence = ::Brotherhood.parentConjunctiveSideValues(_profile, evidenceByStat);
		foreach (side in anchorEvidence)
			if (side.Value < _profile.ConjunctiveFitness.MinimumAnchorEvidence) { anchorRecognitionQualified = false; break; }
	}
	local jointlyQualified = starting.Eligible && anchorRecognitionQualified && reachability.Qualified;
	local candidacyReason = "";
	if (jointlyQualified) candidacyReason = "recognition and reachability qualified";
	else
	{
		local parts = [];
		if (!starting.Eligible) parts.push("ineligible under authored hard rules");
		if (!anchorRecognitionQualified)
			parts.push(recognition.Qualified ? "Anchor evidence rejected despite latent identity" : "recognition rejected: " + recognition.Reason);
		if (!reachability.Qualified) parts.push("reachability rejected: " + reachability.Reason);
		candidacyReason = ::Brotherhood.parentJoin(parts, "; ");
	}
	return {
		Profile=_profile, NormalizedCost=cost, StartingScore=starting, CriterionCosts=criterionCosts, ActiveClaims=activeClaims,
		AnchorWeight=1.0 + startFit / 8.0 + ::Math.minf(0.25, traitAffinity * 0.025),
		Recognition=recognition, Reachability=reachability, JointlyQualified=jointlyQualified, CandidacyReason=candidacyReason,
		AnchorRecognitionQualified=anchorRecognitionQualified
	};
}

::Brotherhood.parentDevelopAnchor <- function( _startingBody, _profile, _screens )
{
	local current = ::Brotherhood.parentCloneStats(_startingBody.Stats);
	local startingScore = ::Brotherhood.parentScore(_startingBody, _profile);
	local recognition = ::Brotherhood.calculateInnateRecognition(_startingBody, _profile, _screens);
	local preferred = {};
	foreach (item in recognition.Contributions) if (item.AlternativeGroup != null) preferred[item.Label] <- item.StatName;
	local specs = ::Brotherhood.parentChosenDevelopmentSpecs(_startingBody, _profile, preferred);
	local specByAttribute = {};
	foreach (item in specs) specByAttribute[item.Name] <- item.Spec;
	local increases = {};
	local counts = {};
	foreach (attribute in ::Brotherhood.ParentAttributes) { increases[attribute.Name] <- 0; counts[attribute.Name] <- 0; }
	local decisions = [];
	foreach (screen in _screens)
	{
		local ranked = [];
		foreach (attribute in ::Brotherhood.ParentAttributes)
		{
			local name = attribute.Name;
			local greatValue = 0.0;
			local premiumValue = 0.0;
			local importance = 0.0;
			if (name in specByAttribute && specByAttribute[name].Direction == "higher")
			{
				local spec = specByAttribute[name];
				importance = spec.Importance;
				local greatGap = ::Brotherhood.parentGapToThreshold(current[name], spec, "great");
				local premiumGap = ::Brotherhood.parentGapToThreshold(current[name], spec, "premium");
				local gain = ::Brotherhood.parentExpectedGain(_startingBody, name);
				greatValue = ::Math.minf(greatGap, screen.Rolls[name].tofloat()) * importance / gain;
				if (greatGap <= 0)
					premiumValue = ::Math.minf(premiumGap, screen.Rolls[name].tofloat()) * importance / gain;
			}
			local priority = ::Brotherhood.ParentSecondaryAttributePriority[name];
			ranked.push({ Key=[greatValue, premiumValue, importance, priority, screen.Rolls[name].tofloat()], Name=name });
		}
		ranked.sort(function( _left, _right )
		{
			for (local i = 0; i < _left.Key.len(); ++i)
			{
				if (_left.Key[i] > _right.Key[i]) return -1;
				if (_left.Key[i] < _right.Key[i]) return 1;
			}
			return 0;
		});
		local choices = [ranked[0].Name, ranked[1].Name, ranked[2].Name];
		if (choices[0] == choices[1] || choices[0] == choices[2] || choices[1] == choices[2])
			throw "each normal level-up must select exactly three distinct attributes";
		foreach (name in choices)
		{
			current[name] = current[name].tofloat() + screen.Rolls[name];
			increases[name] += screen.Rolls[name];
			counts[name] += 1;
		}
		local interimBody = { Stats=current, Stars=_startingBody.Stars, TraitNames=("TraitNames" in _startingBody) ? _startingBody.TraitNames : [], TraitIDs=("TraitIDs" in _startingBody) ? _startingBody.TraitIDs : [], Seed=_startingBody.Seed };
		local interim = ::Brotherhood.parentScore(interimBody, _profile);
		decisions.push({ Level=screen.Level, Attributes=choices, ResultingFitness=interim.ParentFitness });
	}
	local finalBody = { Stats=current, Stars=_startingBody.Stars, TraitNames=("TraitNames" in _startingBody) ? _startingBody.TraitNames : [], TraitIDs=("TraitIDs" in _startingBody) ? _startingBody.TraitIDs : [], Seed=_startingBody.Seed };
	return {
		Profile=_profile, StartingScore=startingScore, FinalScore=::Brotherhood.parentScore(finalBody, _profile),
		FinalStats=current, Increases=increases, Counts=counts, Decisions=decisions
	};
}

::Brotherhood.evaluateSecondaryIdentity <- function( _recognition, _sharedBody, _development )
{
	local evidence = [];
	if (_recognition.Profile.ConjunctiveFitness != null)
	{
		if (!_recognition.Qualified) return { Qualified=false, Evidence=["original-body recognition rejected: " + _recognition.Reason] };
		local sideValues = ::Brotherhood.parentConjunctiveSideValues(_recognition.Profile, _sharedBody.Stats);
		local dead = [];
		foreach (side in sideValues)
			if (side.Value < _recognition.Profile.ConjunctiveFitness.DeadSideBelow)
				dead.push("shared-future " + side.Name + " " + ::format("%.1f", side.Value) + " below dead-side threshold " + ::format("%.1f", _recognition.Profile.ConjunctiveFitness.DeadSideBelow));
		if (dead.len() != 0) return { Qualified=false, Evidence=dead };
		local sharedScore = ::Brotherhood.parentScore(_sharedBody, _recognition.Profile);
		if (!sharedScore.Eligible) return { Qualified=false, Evidence=sharedScore.Rejections };
		evidence.push(_recognition.Reason);
		local parts = [];
		for (local i = 0; i < sharedScore.AptitudeSourceValues.len(); ++i)
		{
			local raw = sharedScore.AptitudeSourceValues[i];
			local aptitude = sharedScore.AptitudeScores[i];
			parts.push(raw.Name + " " + ::format("%.1f", raw.Value) + " (aptitude " + ::format("%.3f", aptitude.Value) + ")");
		}
		evidence.push("conjunctive shared future: " + ::Brotherhood.parentJoin(parts, ", "));
		return { Qualified=true, Evidence=evidence };
	}
	if (_recognition.Qualified) evidence.push("level-1 innate recognition " + ::format("%.3f", _recognition.Value));
	local satisfied = [];
	foreach (item in _recognition.Contributions)
	{
		local spec = ::Brotherhood.parentGetStatSpec(_recognition.Profile, item.StatName);
		if (::Brotherhood.parentGapToThreshold(_sharedBody.Stats[item.StatName], spec, "great") <= 0) satisfied.push(item.Label);
	}
	local uniqueSatisfied = {};
	foreach (label in satisfied) uniqueSatisfied[label] <- true;
	local satisfiedCount = 0;
	foreach (_label, _ignored in uniqueSatisfied) satisfiedCount += 1;
	local needed = _recognition.Contributions.len() >= 2 ? 2 : 1;
	if (satisfiedCount >= needed)
	{
		local labels = [];
		foreach (label, _ignored in uniqueSatisfied) labels.push(label);
		labels.sort(@(a, b) a <=> b);
		evidence.push("shared future satisfies defining conjunction: " + ::Brotherhood.parentJoin(labels, ", "));
	}
	local developed = {};
	foreach (name, count in _development.Counts) if (count > 0) developed[name] <- true;
	local wake = {};
	foreach (item in _recognition.Contributions)
		if ((item.StatName in developed) && item.Percentile >= ::Brotherhood.ParentRecognitionEvidencePercentile) wake[item.Label] <- true;
	local wakeLabels = [];
	foreach (label, _ignored in wake) wakeLabels.push(label);
	wakeLabels.sort(@(a, b) a <=> b);
	if (wakeLabels.len() != 0 && _recognition.Value >= 0.05)
		evidence.push("Anchor development wake: " + ::Brotherhood.parentJoin(wakeLabels, ", "));
	return { Qualified=evidence.len() != 0, Evidence=evidence };
}

::Brotherhood.evaluateTempoRecognition <- function( _profile, _normalResults, _credibleNormalIDs )
{
	local matches = [];
	foreach (item in _normalResults)
		if (item.Eligible && item.ParentFitness != null) matches.push(item.ParentFitness.tofloat());
	local greatMatches = 0;
	local premiumMatches = 0;
	foreach (value in matches)
	{
		if (value >= 4.0) premiumMatches += 1;
		else if (value >= 3.0) greatMatches += 1;
	}
	local bestByStat = {};
	foreach (result in _normalResults)
	{
		foreach (contribution in result.Contributions)
		{
			local match = contribution.Match;
			if (contribution.Importance <= 0 || match.Fitness == null || !::Brotherhood.parentIsAttribute(match.StatName)) continue;
			if (!(match.StatName in bestByStat) || match.Fitness > bestByStat[match.StatName]) bestByStat[match.StatName] <- match.Fitness;
		}
	}
	local badAxes = [];
	foreach (name, fitness in bestByStat) if (fitness < 2.0) badAxes.push(name);
	badAxes.sort(@(a, b) a <=> b);
	local credibleCount = 0;
	foreach (_id, _ignored in _credibleNormalIDs) credibleCount += 1;
	if (credibleCount >= 4)
		return { Profile=_profile, Tier="Excluded", Eligible=false, CredibleNormalClaims=credibleCount, GreatNormalMatches=greatMatches, PremiumNormalMatches=premiumMatches, BadCombatAxes=badAxes, Reason="four normal parents already made credible claims" };
	if (premiumMatches > 0)
		return { Profile=_profile, Tier="Excluded", Eligible=false, CredibleNormalClaims=credibleCount, GreatNormalMatches=greatMatches, PremiumNormalMatches=premiumMatches, BadCombatAxes=badAxes, Reason="a normal parent has a Premium specialist match" };
	local tier = "";
	local reason = "";
	if (greatMatches == 0 && badAxes.len() >= 2)
	{
		tier = "Premium";
		reason = "no Great or Premium normal match; " + badAxes.len() + " important combat axes are below Acceptable";
	}
	else if (greatMatches <= 1)
	{
		tier = "Great";
		reason = "no Premium normal match; " + greatMatches + " Great normal match; remaining matches are Acceptable or Bad";
	}
	else
	{
		local anyOrdinary = false;
		foreach (value in matches) if (value > 0.0) { anyOrdinary = true; break; }
		if (!anyOrdinary)
			return { Profile=_profile, Tier="Excluded", Eligible=false, CredibleNormalClaims=credibleCount, GreatNormalMatches=greatMatches, PremiumNormalMatches=premiumMatches, BadCombatAxes=badAxes, Reason="no ordinary parent future exists for Tempo to complete" };
		tier = "Acceptable";
		reason = "the body has some ordinary future, but fewer than four credible normal claims";
	}
	return { Profile=_profile, Tier=tier, Eligible=true, CredibleNormalClaims=credibleCount, GreatNormalMatches=greatMatches, PremiumNormalMatches=premiumMatches, BadCombatAxes=badAxes, Reason=reason };
}

::Brotherhood.parentMaximumProfileImportance <- function( _profiles )
{
	local maximum = 1.0;
	foreach (profile in _profiles)
		foreach (spec in profile.Stats)
			if (spec.Importance > maximum) maximum = spec.Importance;
	return maximum;
}

::Brotherhood.parentSaturationAddedByParent <- function( _result, _maximumImportance, _strength = 1.0 )
{
	local additions = {};
	if (_maximumImportance <= 0 || _strength <= 0) return additions;
	foreach (contribution in _result.Contributions)
	{
		if (contribution.Importance <= 0 || contribution.WeightedFitness <= 0) continue;
		local value = _strength * contribution.Importance / _maximumImportance;
		if (!(contribution.StatName in additions) || value > additions[contribution.StatName]) additions[contribution.StatName] <- value;
	}
	return additions;
}

::Brotherhood.parentAddSaturation <- function( _saturation, _result, _maximumImportance, _strength )
{
	local additions = ::Brotherhood.parentSaturationAddedByParent(_result, _maximumImportance, _strength);
	foreach (statName, value in additions)
		_saturation[statName] <- (statName in _saturation ? _saturation[statName] : 0.0) + value;
	return additions;
}

::Brotherhood.adjustScoreForSaturation <- function( _body, _result, _saturation )
{
	if (!_result.Eligible || _result.ParentFitness == null || _result.TotalImportance <= 0) return _result;
	local rawByStat = {};
	local labels = {};
	foreach (contribution in _result.Contributions)
	{
		rawByStat[contribution.StatName] <- (contribution.StatName in rawByStat ? rawByStat[contribution.StatName] : 0.0) + contribution.WeightedFitness / _result.TotalImportance;
		labels[contribution.StatName] <- contribution.Label;
	}
	local counted = {};
	foreach (item in _result.Contributions) counted[item.StatName] <- [item.Match, item.Importance];
	foreach (statName, value in ::Brotherhood.parentRoutingNormalizationByStat(_body.Stats, _result.Profile, counted, _result.TotalImportance))
		rawByStat[statName] <- (statName in rawByStat ? rawByStat[statName] : 0.0) + value;
	foreach (statName, value in ::Brotherhood.parentRoutingBonusByStat(_body, _result.Profile))
		rawByStat[statName] <- (statName in rawByStat ? rawByStat[statName] : 0.0) + value;
	local adjustments = [];
	local names = [];
	foreach (statName, _ignored in rawByStat) names.push(statName);
	names.sort(@(a, b) a <=> b);
	foreach (statName in names)
	{
		local raw = rawByStat[statName];
		local sat = statName in _saturation ? _saturation[statName] : 0.0;
		adjustments.push({ Label=statName in labels ? labels[statName] : statName, RealStat=statName, RawContribution=raw, Saturation=sat, AdjustedContribution=raw / (1.0 + sat), SaturationAdded=0.0 });
	}
	local adjusted = 0.0;
	if (_result.Profile.ConjunctiveFitness != null)
	{
		local adjustedStatValues = {};
		foreach (contribution in _result.Contributions)
		{
			local sat = contribution.StatName in _saturation ? _saturation[contribution.StatName] : 0.0;
			adjustedStatValues[contribution.StatName] <- ::Brotherhood.parentConjunctiveStatAptitude(_result.Profile, _body.Stats[contribution.StatName].tofloat()) / (1.0 + sat);
		}
		adjusted = ::Brotherhood.parentConjunctiveCombinedFitness(_result.Profile, ::Brotherhood.parentConjunctiveSideValues(_result.Profile, adjustedStatValues));
	}
	else
	{
		foreach (item in adjustments) adjusted += item.AdjustedContribution;
		adjusted = ::Math.minf(4.0, adjusted);
	}
	return {
		Profile=_result.Profile, Eligible=_result.Eligible, ParentFitness=_result.ParentFitness, DevelopmentValue=_result.DevelopmentValue,
		TotalImportance=_result.TotalImportance, BaseFitness=_result.BaseFitness, RoutingBonus=_result.RoutingBonus, RoutingNormalization=_result.RoutingNormalization,
		Contributions=_result.Contributions, Rejections=_result.Rejections, RankingFitness=adjusted, SaturationAdjustments=adjustments,
		AptitudeScores=_result.AptitudeScores, AptitudeMinimum=_result.AptitudeMinimum, AptitudePasses=_result.AptitudePasses, AptitudeSourceValues=_result.AptitudeSourceValues
	};
}

::Brotherhood.parentRankComparator <- function( _left, _right )
{
	local leftFit = ::Brotherhood.parentRankingFitness(_left);
	local rightFit = ::Brotherhood.parentRankingFitness(_right);
	if (leftFit > rightFit) return -1;
	if (leftFit < rightFit) return 1;
	return _left.Profile.ID <=> _right.Profile.ID;
}

::Brotherhood.resolveParentSelection <- function( _rankings, _body, _count, _runSeed = null, _bodyIndex = null )
{
	if (_count < 1 || _count > 4) throw "parent selection count must be 1, 2, 3, or 4";
	if (_rankings.len() == 0) return [];
	local ranked = clone _rankings;
	ranked.sort(::Brotherhood.parentRankComparator);
	local selectedCount = ::Math.min(_count, ranked.len());
	local cutoff = ::Brotherhood.parentRankingFitness(ranked[selectedCount - 1]);
	local above = [];
	local tied = [];
	foreach (score in ranked)
	{
		local fitness = ::Brotherhood.parentRankingFitness(score);
		if (fitness > cutoff) above.push(score);
		else if (fitness == cutoff) tied.push(score);
	}
	local remaining = selectedCount - above.len();
	if (remaining >= tied.len()) { above.extend(tied); return above; }
	local tiedIDs = tied.map(@(_item) _item.Profile.ID);
	tiedIDs.sort(@(a, b) a <=> b);
	local seed = _runSeed != null ? _runSeed : _body.Seed;
	local context = "v=1|seed=" + seed + "|uid=" + (("RecruitUID" in _body) ? _body.RecruitUID : 0) + "|bodyIndex=" + (_bodyIndex == null ? "null" : _bodyIndex) + "|count=" + _count + "|cutoff=" + ::format("%.12f", cutoff) + "|remaining=" + remaining + "|tied=" + ::Brotherhood.parentJoin(tiedIDs, ",");
	local byID = {};
	foreach (score in tied) byID[score.Profile.ID] <- score;
	// Intentional mismatch vs Python blake2b: Park-Miller shuffle over sorted IDs.
	local state = ::Brotherhood.ParentRNG.createTieState(context);
	for (local i = tiedIDs.len() - 1; i > 0; --i)
	{
		local j = ::Brotherhood.ParentRNG.nextInt(state, 0, i);
		local swap = tiedIDs[i]; tiedIDs[i] = tiedIDs[j]; tiedIDs[j] = swap;
	}
	for (local i = 0; i < remaining; ++i) above.push(byID[tiedIDs[i]]);
	return above;
}

::Brotherhood.chooseAnchor <- function( _candidates, _body, _runSeed = null, _bodyIndex = null, _forcedAnchorID = null )
{
	if (_forcedAnchorID != null)
	{
		foreach (item in _candidates) if (item.Profile.ID == _forcedAnchorID) return item;
	}
	local eligible = [];
	foreach (item in _candidates) if (item.JointlyQualified) eligible.push(item);
	if (eligible.len() == 0)
	{
		local plausible = [];
		foreach (item in _candidates) if (item.StartingScore.Eligible) plausible.push(item);
		if (plausible.len() == 0) return null;
		local bestKey = null;
		foreach (item in plausible)
		{
			local key = [item.AnchorRecognitionQualified ? 1 : 0, item.Recognition.Value, item.Reachability.Value];
			if (bestKey == null || key[0] > bestKey[0] || (key[0] == bestKey[0] && (key[1] > bestKey[1] || (key[1] == bestKey[1] && key[2] > bestKey[2])))) bestKey = key;
		}
		local tied = [];
		foreach (item in plausible)
		{
			local key = [item.AnchorRecognitionQualified ? 1 : 0, item.Recognition.Value, item.Reachability.Value];
			if (key[0] == bestKey[0] && key[1] == bestKey[1] && key[2] == bestKey[2]) tied.push(item);
		}
		tied.sort(@(_left, _right) _left.Profile.ID <=> _right.Profile.ID);
		return tied[0];
	}
	local maximum = 0.0;
	foreach (item in eligible) if (item.Recognition.Value > maximum) maximum = item.Recognition.Value;
	local close = [];
	foreach (item in eligible) if (item.Recognition.Value >= maximum - 0.10) close.push(item);
	close.sort(@(_left, _right) _left.Profile.ID <=> _right.Profile.ID);
	local weighted = [];
	local total = 0.0;
	foreach (item in close)
	{
		local weight = ::Math.maxf(0.01, item.Recognition.Value) * item.AnchorWeight;
		total += weight;
		weighted.push({ Boundary=total, Item=item });
	}
	local seed = _runSeed != null ? _runSeed : _body.Seed;
	local ids = close.map(@(_item) _item.Profile.ID);
	local context = "brotherhood-anchor-v1|seed=" + seed + "|bodyIndex=" + (_bodyIndex == null ? "null" : _bodyIndex) + "|ids=" + ::Brotherhood.parentJoin(ids, ",");
	// Intentional mismatch vs Python blake2b digest draw.
	local state = ::Brotherhood.ParentRNG.create(::Brotherhood.ParentRNG.stableStringHash(context));
	local draw = ::Brotherhood.ParentRNG.nextUnit(state) * total;
	foreach (entry in weighted) if (draw < entry.Boundary) return entry.Item;
	return weighted.top().Item;
}

::Brotherhood.parentSequentialSecondarySelection <- function( _body, _anchor, _qualifiedPool, _unqualifiedPool, _seatedEnabled, _seatedStrength, _maximumImportance, _runSeed, _bodyIndex )
{
	local saturation = {};
	local traces = [];
	local contestTraces = [];
	local selected = [];
	if (_seatedEnabled)
	{
		local anchorAdjusted = ::Brotherhood.adjustScoreForSaturation(_body, _anchor, saturation);
		local before = {};
		local additions = ::Brotherhood.parentAddSaturation(saturation, _anchor, _maximumImportance, _seatedStrength);
		traces.push({ Seat=1, WinnerID=anchorAdjusted.Profile.ID, RawFitness=_anchor.ParentFitness, AdjustedFitness=::Brotherhood.parentRankingFitness(anchorAdjusted), ChangedWinner=false, SaturationBefore=before, Adjustments=anchorAdjusted.SaturationAdjustments });
	}
	local qualifiedSeats = ::Math.min(3, _qualifiedPool.len());
	local stages = [
		[_qualifiedPool, qualifiedSeats],
		[_unqualifiedPool, ::Math.min(_unqualifiedPool.len(), ::Math.max(0, 3 - qualifiedSeats))]
	];
	foreach (stage in stages)
	{
		local remaining = clone stage[0];
		for (local seat = 0; seat < stage[1]; ++seat)
		{
			local before = ::Brotherhood.parentCloneStats(saturation);
			local adjusted = [];
			foreach (item in remaining)
				adjusted.push(_seatedEnabled ? ::Brotherhood.adjustScoreForSaturation(_body, item, saturation) : item);
			local tieIndex = _bodyIndex == null ? null : _bodyIndex * 10 + selected.len() + 1;
			local winner = ::Brotherhood.resolveParentSelection(adjusted, _body, 1, _runSeed, tieIndex)[0];
			local contestCandidates = [];
			foreach (item in adjusted)
			{
				local raw = null;
				foreach (candidate in remaining) if (candidate.Profile.ID == item.Profile.ID) { raw = candidate; break; }
				contestCandidates.push({ ParentID=item.Profile.ID, RawFitness=raw.ParentFitness, AdjustedFitness=::Brotherhood.parentRankingFitness(item) });
			}
			contestTraces.push({ SeatIndex=selected.len(), Candidates=contestCandidates, WinnerID=winner.Profile.ID });
			local rawWinner = ::Brotherhood.resolveParentSelection(remaining, _body, 1, _runSeed, tieIndex)[0];
			local additions = {};
			if (_seatedEnabled) additions = ::Brotherhood.parentAddSaturation(saturation, winner, _maximumImportance, _seatedStrength);
			traces.push({
				Seat=selected.len() + 2, WinnerID=winner.Profile.ID, RawFitness=winner.ParentFitness,
				AdjustedFitness=::Brotherhood.parentRankingFitness(winner), ChangedWinner=winner.Profile.ID != rawWinner.Profile.ID,
				SaturationBefore=before, Adjustments=winner.SaturationAdjustments
			});
			selected.push(winner);
			local nextRemaining = [];
			foreach (item in remaining) if (item.Profile.ID != winner.Profile.ID) nextRemaining.push(item);
			remaining = nextRemaining;
		}
	}
	return { Selected=selected, Traces=traces, Saturation=saturation, ContestTraces=contestTraces };
}

::Brotherhood.parentBeamGroupCandidates <- function( _body, _anchor, _qualifiedPool, _unqualifiedPool, _seatedStrength, _maximumImportance, _beamWidth )
{
	local initialSaturation = {};
	::Brotherhood.parentAddSaturation(initialSaturation, _anchor, _maximumImportance, _seatedStrength);
	local states = [{ Path=[], Saturation=initialSaturation, Total=::Brotherhood.parentRankingFitness(_anchor) }];
	local qualifiedSeats = ::Math.min(3, _qualifiedPool.len());
	local stages = [
		[_qualifiedPool, qualifiedSeats],
		[_unqualifiedPool, ::Math.min(_unqualifiedPool.len(), ::Math.max(0, 3 - qualifiedSeats))]
	];
	local exhausted = false;
	foreach (stage in stages)
	{
		for (local seat = 0; seat < stage[1]; ++seat)
		{
			local expanded = [];
			foreach (state in states)
			{
				local used = {};
				foreach (item in state.Path) used[item.Profile.ID] <- true;
				foreach (candidate in stage[0])
				{
					if (candidate.Profile.ID in used) continue;
					local adjusted = ::Brotherhood.adjustScoreForSaturation(_body, candidate, state.Saturation);
					local nextSaturation = ::Brotherhood.parentCloneStats(state.Saturation);
					::Brotherhood.parentAddSaturation(nextSaturation, adjusted, _maximumImportance, _seatedStrength);
					local nextPath = clone state.Path;
					nextPath.push(adjusted);
					expanded.push({ Path=nextPath, Saturation=nextSaturation, Total=state.Total + ::Brotherhood.parentRankingFitness(adjusted) });
				}
			}
			expanded.sort(function( _left, _right )
			{
				if (_left.Total > _right.Total) return -1;
				if (_left.Total < _right.Total) return 1;
				local leftIDs = _left.Path.map(@(_item) _item.Profile.ID);
				local rightIDs = _right.Path.map(@(_item) _item.Profile.ID);
				local leftKey = ::Brotherhood.parentJoin(leftIDs, ",");
				local rightKey = ::Brotherhood.parentJoin(rightIDs, ",");
				return leftKey <=> rightKey;
			});
			if (_beamWidth > 0 && expanded.len() > _beamWidth)
			{
				exhausted = true;
				expanded = expanded.slice(0, _beamWidth);
			}
			states = expanded;
		}
	}
	local candidates = {};
	foreach (state in states)
	{
		local ids = [_anchor.Profile.ID];
		foreach (item in state.Path) ids.push(item.Profile.ID);
		ids.sort(@(a, b) a <=> b);
		local key = ::Brotherhood.parentJoin(ids, "|");
		if (!(key in candidates) || state.Total > candidates[key].Total)
			candidates[key] <- { Path=state.Path, Total=state.Total, Group=ids };
	}
	return { Candidates=candidates, Exhausted=exhausted };
}

::Brotherhood.generateParentSelection <- function( _body, _profiles, _count = 4, _screens = null, _options = null )
{
	if (_count != 1 && _count != 4) throw "parent selection count must be 1 or 4";
	local options = _options == null ? {} : _options;
	local runSeed = ("RunSeed" in options) ? options.RunSeed : _body.Seed;
	local bodyIndex = ("BodyIndex" in options) ? options.BodyIndex : null;
	local forcedAnchorID = ("ForcedAnchorID" in options) ? options.ForcedAnchorID : null;
	local previousGroup = ("PreviousGroup" in options) ? options.PreviousGroup : null;
	local seatedEnabled = !("SeatedEnabled" in options) || options.SeatedEnabled != false;
	local groupEnabled = !("DisableGroupSaturation" in options) || options.DisableGroupSaturation != true;
	local seatedStrength = 1.0;
	local screens = _screens == null ? ::Brotherhood.parentGenerateRollSheets(_body.Seed, _body.Stars) : _screens;
	local before = ::Brotherhood.parentRollSheetFingerprint(screens);
	local errors = [];
	local tempoProfiles = [];
	local normalProfiles = [];
	foreach (profile in _profiles)
	{
		if (("Tempo" in profile) && profile.Tempo) tempoProfiles.push(profile);
		else normalProfiles.push(profile);
	}

	local costs = [];
	foreach (profile in normalProfiles)
	{
		try { costs.push(::Brotherhood.estimateDevelopmentCost(_body, profile, screens)); }
		catch (error)
		{
			errors.push({ Profile=profile, Error=error.tostring() });
			::logWarning("[Brotherhood][PARENT][SCORE] Skipped " + profile.Source + " / " + profile.ID + ": " + error);
		}
	}
	costs.sort(function( _left, _right )
	{
		if (_left.JointlyQualified != _right.JointlyQualified) return _left.JointlyQualified ? -1 : 1;
		if (_left.Recognition.Value != _right.Recognition.Value) return _left.Recognition.Value > _right.Recognition.Value ? -1 : 1;
		if (_left.Reachability.Value != _right.Reachability.Value) return _left.Reachability.Value > _right.Reachability.Value ? -1 : 1;
		return _left.Profile.ID <=> _right.Profile.ID;
	});

	local recognitionFingerprint = ("ParentRecognitionCalibration" in ::Brotherhood) ? ::Brotherhood.ParentRecognitionCalibration.Fingerprint : null;
	local emptyGroupTrace = { PreviousGroup=[], BaselineGroup=[], SelectedGroup=[], OverlapBefore=0, OverlapAfter=0, Multiplier=1.0, ChangedGroup=false, ExactRepeatPrevented=false, ExactRepeatRelaxed=false, RawFitnessSacrificed=0.0, CandidatesEvaluated=0, SearchExhausted=false, CandidateParentIDs=[] };

	local anchorCost = ::Brotherhood.chooseAnchor(costs, _body, runSeed, bodyIndex, forcedAnchorID);
	if (anchorCost == null)
	{
		local rejected = [];
		foreach (item in costs) rejected.push(item.StartingScore);
		if (before != ::Brotherhood.parentRollSheetFingerprint(screens)) throw "parent candidate mutated the shared level-up roll sheets";
		return {
			Body=_body, Screens=screens, RollSheetFingerprint=before, Developments=[], Rankings=[], Rejected=rejected, Errors=errors, Selected=[],
			Anchor=null, SharedFuture=null, ProposalCosts=costs, AnchorCandidates=costs, SecondaryDiagnostics=[], TempoRecognition=null,
			SaturationTrace=[], Fallback="No eligible parent fallback.", AnchorFallback=true, RecognitionFingerprint=recognitionFingerprint,
			DevelopmentSimulations=0, Explanation="No parent was eligible at level 1.", GroupSaturation=emptyGroupTrace, BaselineSelected=[], SecondaryContestTrace=[]
		};
	}

	local development = ::Brotherhood.parentDevelopAnchor(_body, anchorCost.Profile, screens);
	local sharedBody = { Stats=development.FinalStats, Stars=_body.Stars, TraitNames=("TraitNames" in _body) ? _body.TraitNames : [], TraitIDs=("TraitIDs" in _body) ? _body.TraitIDs : [], Seed=_body.Seed, RecruitUID=("RecruitUID" in _body) ? _body.RecruitUID : 0 };
	local results = [];
	foreach (profile in normalProfiles) results.push(::Brotherhood.parentScore(sharedBody, profile));
	local rankings = [];
	local rejected = [];
	foreach (item in results)
	{
		if (item.Eligible) rankings.push(item);
		else rejected.push(item);
	}
	rankings.sort(::Brotherhood.parentRankComparator);
	rejected.sort(@(_left, _right) _left.Profile.ID <=> _right.Profile.ID);

	local anchorScore = null;
	foreach (item in results) if (item.Profile.ID == anchorCost.Profile.ID) { anchorScore = item; break; }
	local anchorFallback = !anchorCost.JointlyQualified;
	local secondaryDiagnostics = [];
	local tempoRecognition = null;
	local saturationTrace = [];
	local saturationTotals = {};
	local baselineSelected = [];
	local groupTrace = emptyGroupTrace;
	local secondaryContestTrace = [];
	local selected = [];

	if (_count == 1) selected = [anchorScore];
	else
	{
		local secondaryPool = [];
		foreach (item in rankings) if (item.Profile.ID != anchorScore.Profile.ID) secondaryPool.push(item);
		local costsByID = {};
		foreach (item in costs) costsByID[item.Profile.ID] <- item;
		local identityByID = {};
		local qualifiedPool = [];
		local unqualifiedPool = [];
		foreach (item in secondaryPool)
		{
			local recognition = costsByID[item.Profile.ID].Recognition;
			local identity = ::Brotherhood.evaluateSecondaryIdentity(recognition, sharedBody, development);
			identityByID[item.Profile.ID] <- identity;
			if (identity.Qualified) qualifiedPool.push(item);
			else if (item.Profile.ConjunctiveFitness == null) unqualifiedPool.push(item);
		}
		local maximumImportance = ::Brotherhood.parentMaximumProfileImportance(normalProfiles);
		local qualifiedCount = ::Math.min(3, qualifiedPool.len());
		local primary = [];
		local fallbackSecondary = [];
		local secondary = [];
		if (seatedEnabled)
		{
			local seq = ::Brotherhood.parentSequentialSecondarySelection(sharedBody, anchorScore, qualifiedPool, unqualifiedPool, true, seatedStrength, maximumImportance, runSeed, bodyIndex);
			secondary = seq.Selected;
			saturationTrace = seq.Traces;
			saturationTotals = seq.Saturation;
			secondaryContestTrace = seq.ContestTraces;
			primary = secondary.slice(0, qualifiedCount);
			fallbackSecondary = secondary.slice(qualifiedCount);
		}
		else
		{
			primary = qualifiedCount > 0 ? ::Brotherhood.resolveParentSelection(qualifiedPool, _body, qualifiedCount, runSeed, bodyIndex) : [];
			local remainingQualified = clone qualifiedPool;
			for (local seatIndex = 0; seatIndex < primary.len(); ++seatIndex)
			{
				local winner = primary[seatIndex];
				local candidates = [];
				foreach (item in remainingQualified)
					candidates.push({ ParentID=item.Profile.ID, RawFitness=item.ParentFitness, AdjustedFitness=::Brotherhood.parentRankingFitness(item) });
				secondaryContestTrace.push({ SeatIndex=seatIndex, Candidates=candidates, WinnerID=winner.Profile.ID });
				local next = [];
				foreach (item in remainingQualified) if (item.Profile.ID != winner.Profile.ID) next.push(item);
				remainingQualified = next;
			}
			local remaining = 3 - primary.len();
			fallbackSecondary = (remaining > 0 && unqualifiedPool.len() > 0) ? ::Brotherhood.resolveParentSelection(unqualifiedPool, _body, remaining, runSeed, bodyIndex) : [];
			secondary = clone primary;
			secondary.extend(fallbackSecondary);
		}
		selected = [anchorScore];
		selected.extend(primary);
		selected.extend(fallbackSecondary);
		local primaryIDs = {};
		foreach (item in primary) primaryIDs[item.Profile.ID] <- true;
		local fallbackIDs = {};
		foreach (item in fallbackSecondary) fallbackIDs[item.Profile.ID] <- true;
		foreach (item in secondaryPool)
		{
			local identity = identityByID[item.Profile.ID];
			local isSelected = (item.Profile.ID in primaryIDs) || (item.Profile.ID in fallbackIDs);
			local isFallback = item.Profile.ID in fallbackIDs;
			local reason = "";
			if (item.Profile.ID in primaryIDs) reason = "selected by shared-future fitness among identity-qualified parents";
			else if (isFallback) reason = "selected only to fill an otherwise empty seat";
			else if (identity.Qualified) reason = "identity qualified but ranked below the seat cutoff";
			else reason = "generic compatibility without identity evidence";
			secondaryDiagnostics.push({
				Profile=item.Profile, IdentityQualified=identity.Qualified, IdentityEvidence=identity.Evidence,
				SharedFitness=item.ParentFitness, Selected=isSelected, Fallback=isFallback, Reason=reason
			});
		}
		local credibleIDs = {};
		foreach (item in secondaryDiagnostics) if (item.IdentityQualified) credibleIDs[item.Profile.ID] <- true;
		credibleIDs[anchorScore.Profile.ID] <- true;
		local tempoScore = null;
		if (tempoProfiles.len() != 0)
		{
			tempoProfiles.sort(@(_left, _right) _left.ID <=> _right.ID);
			local tempoProfile = tempoProfiles[0];
			tempoRecognition = ::Brotherhood.evaluateTempoRecognition(tempoProfile, results, credibleIDs);
			if (tempoRecognition.Eligible)
			{
				local tierFitness = tempoRecognition.Tier == "Acceptable" ? 2.0 : (tempoRecognition.Tier == "Great" ? 3.0 : 4.0);
				tempoScore = {
					Profile=tempoProfile, Eligible=true, ParentFitness=tierFitness, DevelopmentValue=tierFitness, TotalImportance=0.0,
					BaseFitness=tierFitness, RoutingBonus=0.0, RoutingNormalization=0.0, Contributions=[], Rejections=[],
					RankingFitness=null, SaturationAdjustments=[], AptitudeScores=[], AptitudeMinimum=null, AptitudePasses=[], AptitudeSourceValues=[]
				};
				local noncredibleSelected = [];
				foreach (item in selected)
					if (!(item.Profile.ID in credibleIDs) && item.Profile.ID != anchorScore.Profile.ID) noncredibleSelected.push(item);
				if (selected.len() < _count) selected.push(tempoScore);
				else if (noncredibleSelected.len() != 0)
				{
					local replaced = noncredibleSelected[0];
					foreach (item in noncredibleSelected)
						if (item.ParentFitness < replaced.ParentFitness || (item.ParentFitness == replaced.ParentFitness && item.Profile.ID < replaced.Profile.ID)) replaced = item;
					local nextSelected = [];
					foreach (item in selected) nextSelected.push(item.Profile.ID == replaced.Profile.ID ? tempoScore : item);
					selected = nextSelected;
					foreach (item in secondaryDiagnostics)
						if (item.Profile.ID == replaced.Profile.ID)
						{
							item.Selected = false;
							item.Fallback = false;
							item.Reason = "replaced by post-auction Tempo fallback";
						}
				}
			}
		}
		baselineSelected = clone selected;

		if (groupEnabled && previousGroup != null && previousGroup.len() != 0 && selected.len() == _count)
		{
			local searchStrength = seatedEnabled ? seatedStrength : 0.0;
			local beam = ::Brotherhood.parentBeamGroupCandidates(sharedBody, anchorScore, qualifiedPool, unqualifiedPool, searchStrength, maximumImportance, ::Brotherhood.ParentSaturationBeamWidth);
			local completed = {};
			foreach (_key, entry in beam.Candidates)
			{
				local candidateSelected = [anchorScore];
				candidateSelected.extend(entry.Path);
				local total = entry.Total;
				if (tempoScore != null)
				{
					local noncredible = [];
					foreach (item in candidateSelected)
						if (!(item.Profile.ID in credibleIDs) && item.Profile.ID != anchorScore.Profile.ID) noncredible.push(item);
					if (candidateSelected.len() < _count)
					{
						candidateSelected.push(tempoScore);
						total += ::Brotherhood.parentRankingFitness(tempoScore);
					}
					else if (noncredible.len() != 0)
					{
						local replacedScore = noncredible[0];
						foreach (item in noncredible)
						{
							local left = ::Brotherhood.parentRankingFitness(item);
							local right = ::Brotherhood.parentRankingFitness(replacedScore);
							if (left < right || (left == right && item.Profile.ID < replacedScore.Profile.ID)) replacedScore = item;
						}
						local rebuilt = [];
						foreach (item in candidateSelected) rebuilt.push(item.Profile.ID == replacedScore.Profile.ID ? tempoScore : item);
						candidateSelected = rebuilt;
						total += ::Brotherhood.parentRankingFitness(tempoScore) - ::Brotherhood.parentRankingFitness(replacedScore);
					}
				}
				if (candidateSelected.len() != _count) continue;
				local group = candidateSelected.map(@(_item) _item.Profile.ID);
				group.sort(@(a, b) a <=> b);
				local groupKey = ::Brotherhood.parentJoin(group, "|");
				if (!(groupKey in completed) || total > completed[groupKey].Total)
					completed[groupKey] <- { Selected=candidateSelected, Total=total, Group=group };
			}
			local baselineGroup = baselineSelected.map(@(_item) _item.Profile.ID);
			baselineGroup.sort(@(a, b) a <=> b);
			local baselineTotal = 0.0;
			foreach (item in baselineSelected) baselineTotal += ::Brotherhood.parentRankingFitness(item);
			local baselineKey = ::Brotherhood.parentJoin(baselineGroup, "|");
			completed[baselineKey] <- { Selected=baselineSelected, Total=baselineTotal, Group=baselineGroup };
			local previous = clone previousGroup;
			previous.sort(@(a, b) a <=> b);
			local previousSet = {};
			foreach (id in previous) previousSet[id] <- true;
			local overlapBefore = 0;
			foreach (id in baselineGroup) if (id in previousSet) overlapBefore += 1;
			local rankedGroups = [];
			foreach (_key, entry in completed)
			{
				local overlap = 0;
				foreach (id in entry.Group) if (id in previousSet) overlap += 1;
				local multiplier = overlap in ::Brotherhood.ParentDefaultGroupOverlapMultipliers ? ::Brotherhood.ParentDefaultGroupOverlapMultipliers[overlap] : 1.0;
				rankedGroups.push({ Score=entry.Total * multiplier, Total=entry.Total, Group=entry.Group, Selected=entry.Selected, Overlap=overlap, Multiplier=multiplier });
			}
			if (overlapBefore == 4)
			{
				local hasLower = false;
				foreach (item in rankedGroups) if (item.Overlap < 4) { hasLower = true; break; }
				if (hasLower)
				{
					local filtered = [];
					foreach (item in rankedGroups) if (item.Overlap < 4) filtered.push(item);
					rankedGroups = filtered;
				}
			}
			rankedGroups.sort(function( _left, _right )
			{
				if (_left.Score != _right.Score) return _left.Score > _right.Score ? -1 : 1;
				if (_left.Total != _right.Total) return _left.Total > _right.Total ? -1 : 1;
				local leftBaseline = ::Brotherhood.parentJoin(_left.Group, "|") != baselineKey;
				local rightBaseline = ::Brotherhood.parentJoin(_right.Group, "|") != baselineKey;
				if (leftBaseline != rightBaseline) return leftBaseline ? 1 : -1;
				return ::Brotherhood.parentJoin(_left.Group, "|") <=> ::Brotherhood.parentJoin(_right.Group, "|");
			});
			local chosen = rankedGroups[0];
			local changed = ::Brotherhood.parentJoin(chosen.Group, "|") != baselineKey;
			selected = chosen.Selected;
			local candidateParentIDs = {};
			foreach (_key, entry in completed) foreach (id in entry.Group) candidateParentIDs[id] <- true;
			local candidateList = [];
			foreach (id, _ignored in candidateParentIDs) candidateList.push(id);
			candidateList.sort(@(a, b) a <=> b);
			groupTrace = {
				PreviousGroup=previous, BaselineGroup=baselineGroup, SelectedGroup=chosen.Group,
				OverlapBefore=overlapBefore, OverlapAfter=chosen.Overlap, Multiplier=chosen.Multiplier, ChangedGroup=changed,
				ExactRepeatPrevented=overlapBefore == 4 && chosen.Overlap < 4,
				ExactRepeatRelaxed=overlapBefore == 4 && chosen.Overlap == 4 && !beam.Exhausted && completed.len() == 1,
				RawFitnessSacrificed=::Math.maxf(0.0, baselineTotal - chosen.Total), CandidatesEvaluated=completed.len(),
				SearchExhausted=beam.Exhausted, CandidateParentIDs=candidateList
			};
			local selectedIDsAfterGroup = {};
			foreach (item in selected) selectedIDsAfterGroup[item.Profile.ID] <- true;
			foreach (item in secondaryDiagnostics)
			{
				local nowSelected = item.Profile.ID in selectedIDsAfterGroup;
				item.Selected = nowSelected;
				item.Fallback = nowSelected && !item.IdentityQualified;
				if (nowSelected) item.Reason = "selected by completed-group saturation";
			}
		}
	}

	local fallbackSecondaryCount = 0;
	foreach (item in secondaryDiagnostics) if (item.Fallback) fallbackSecondaryCount += 1;
	local fallbackParts = [];
	if (anchorFallback) fallbackParts.push("Anchor fallback: no parent passed both gates; chose " + anchorCost.Profile.Name + " lexicographically by recognition then reachability");
	if (fallbackSecondaryCount > 0) fallbackParts.push(fallbackSecondaryCount + " secondary seat(s) lacked identity-qualified candidates");
	if (tempoRecognition != null && tempoRecognition.Eligible) fallbackParts.push("Tempo entered after the normal auction at " + tempoRecognition.Tier + " recognition");
	if (selected.len() < _count) fallbackParts.push("only " + selected.len() + " eligible unique parents existed for " + _count + " seats");
	local fallback = fallbackParts.len() == 0 ? null : ::Brotherhood.parentJoin(fallbackParts, "; ");
	local explanation = anchorScore.Profile.Name + " proposed the shared future with innate recognition " + ::format("%.3f", anchorCost.Recognition.Value) + " and reachability " + ::format("%.3f", anchorCost.Reachability.Value) + ". Recognition proposed; reachability permitted; seeded weighted resolution chose.";
	if (before != ::Brotherhood.parentRollSheetFingerprint(screens)) throw "parent candidate mutated the shared level-up roll sheets";
	return {
		Body=_body, Screens=screens, RollSheetFingerprint=before, Developments=[development], Rankings=rankings, Rejected=rejected, Errors=errors, Selected=selected,
		Anchor=anchorScore, SharedFuture=development.FinalStats, ProposalCosts=costs, AnchorCandidates=costs, SecondaryDiagnostics=secondaryDiagnostics,
		TempoRecognition=tempoRecognition, SaturationTrace=saturationTrace, SaturationTotals=saturationTotals, Fallback=fallback, AnchorFallback=anchorFallback,
		RecognitionFingerprint=recognitionFingerprint, DevelopmentSimulations=1, Explanation=explanation, GroupSaturation=groupTrace,
		BaselineSelected=baselineSelected, SecondaryContestTrace=secondaryContestTrace
	};
}
