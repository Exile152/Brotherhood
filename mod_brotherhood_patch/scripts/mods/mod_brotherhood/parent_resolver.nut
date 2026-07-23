if (!("Brotherhood" in getroottable())) return;

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

::Brotherhood.parentScore <- function( _stats, _profile )
{
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
			local match = ::Brotherhood.parentScoreStat(_stats, spec);
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
		local match = ::Brotherhood.parentScoreStat(_stats, spec);
		if (!match.Eligible || match.Fitness == null)
		{
			rejections.push(match.Rejection == null ? spec.Name + " could not be scored" : match.Rejection);
			continue;
		}
		contributions.push({ Label=spec.Name, StatName=spec.Name, Match=match, Importance=spec.Importance, WeightedFitness=match.Fitness * spec.Importance, AlternativeGroup=null, Alternatives=[] });
	}

	if (rejections.len() != 0) return { Profile=_profile, Eligible=false, ParentFitness=null, DevelopmentValue=-1000000.0, TotalImportance=0.0, BaseFitness=null, RoutingBonus=0.0, RoutingNormalization=0.0, Contributions=contributions, Rejections=rejections };
	local totalImportance = 0.0;
	local weightedSum = 0.0;
	local counted = {};
	foreach (item in contributions)
	{
		totalImportance += item.Importance;
		weightedSum += item.WeightedFitness;
		counted[item.StatName] <- item;
	}
	if (totalImportance <= 0) return { Profile=_profile, Eligible=false, ParentFitness=null, DevelopmentValue=-1000000.0, TotalImportance=0.0, BaseFitness=null, RoutingBonus=0.0, RoutingNormalization=0.0, Contributions=contributions, Rejections=["profile has no countable positive importance"] };

	local baseFitness = weightedSum / totalImportance;
	local routingBonus = 0.0;
	local normalizationByStat = {};
	foreach (claim in _profile.RoutingClaims)
	{
		local actual = claim.Stat in _stats ? _stats[claim.Stat].tofloat() : null;
		local routingFitness = ::Brotherhood.parentRoutingFitness(actual, claim.ActivatesBelow);
		routingBonus += routingFitness * claim.Importance * 0.10;
		if (actual == null || actual >= claim.ActivatesBelow || !(claim.Stat in counted)) continue;
		local spec = ::Brotherhood.parentGetStatSpec(_profile, claim.Stat);
		if (spec == null) continue;
		local boundaryStats = {};
		boundaryStats[claim.Stat] <- claim.ActivatesBelow;
		local boundary = ::Brotherhood.parentScoreStat(boundaryStats, spec);
		local actualMatch = counted[claim.Stat].Match;
		if (boundary.Fitness == null || actualMatch.Fitness == null) continue;
		local lost = ::Math.maxf(0.0, boundary.Fitness - actualMatch.Fitness) * counted[claim.Stat].Importance / totalImportance;
		if (!(claim.Stat in normalizationByStat) || lost > normalizationByStat[claim.Stat]) normalizationByStat[claim.Stat] <- lost;
	}
	local routingNormalization = 0.0;
	foreach (value in normalizationByStat) routingNormalization += value;
	local finalFitness = ::Math.minf(4.0, baseFitness + routingNormalization + routingBonus);
	return { Profile=_profile, Eligible=true, ParentFitness=finalFitness, DevelopmentValue=finalFitness, TotalImportance=totalImportance, BaseFitness=baseFitness, RoutingBonus=routingBonus, RoutingNormalization=routingNormalization, Contributions=contributions, Rejections=[] };
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

::Brotherhood.parentApplyChoice <- function( _stats, _screen, _choice )
{
	local ret = ::Brotherhood.parentCloneStats(_stats);
	foreach (index in _choice)
	{
		local name = ::Brotherhood.ParentAttributes[index].Name;
		ret[name] <- (name in ret ? ret[name] : 0.0) + _screen.Rolls[name];
	}
	return ret;
}

::Brotherhood.parentChoiceKeyIsBetter <- function( _candidate, _best )
{
	if (_best == null) return true;
	for (local i = 0; i < _candidate.len(); ++i)
	{
		if (_candidate[i] > _best[i]) return true;
		if (_candidate[i] < _best[i]) return false;
	}
	return false;
}

::Brotherhood.parentDevelop <- function( _body, _profile, _screens )
{
	local current = ::Brotherhood.parentCloneStats(_body.Stats);
	local decisions = [];
	local increases = {};
	local counts = {};
	foreach (attribute in ::Brotherhood.ParentAttributes) { increases[attribute.Name] <- 0; counts[attribute.Name] <- 0; }
	local startingScore = ::Brotherhood.parentScore(current, _profile);
	foreach (screen in _screens)
	{
		local currentValue = ::Brotherhood.parentScore(current, _profile).DevelopmentValue;
		local marginals = [];
		for (local i = 0; i < ::Brotherhood.ParentAttributes.len(); ++i)
			marginals.push(::Brotherhood.parentScore(::Brotherhood.parentApplyChoice(current, screen, [i]), _profile).DevelopmentValue - currentValue);
		local bestChoice = null;
		local bestKey = null;
		local bestScore = null;
		foreach (choice in ::Brotherhood.ParentLevelChoices)
		{
			local candidateScore = ::Brotherhood.parentScore(::Brotherhood.parentApplyChoice(current, screen, choice), _profile);
			local marginalSum = 0.0;
			local importanceSum = 0.0;
			local rollSum = 0.0;
			foreach (index in choice)
			{
				local name = ::Brotherhood.ParentAttributes[index].Name;
				local spec = ::Brotherhood.parentGetStatSpec(_profile, name);
				marginalSum += marginals[index];
				importanceSum += spec == null ? 0.0 : spec.Importance;
				rollSum += screen.Rolls[name];
			}
			local key = [candidateScore.DevelopmentValue, marginalSum, importanceSum, rollSum];
			if (::Brotherhood.parentChoiceKeyIsBetter(key, bestKey)) { bestChoice=choice; bestKey=key; bestScore=candidateScore; }
		}
		if (bestChoice == null || bestChoice.len() != 3) throw "parent development failed to choose three distinct level-up attributes";
		local names = [];
		foreach (index in bestChoice)
		{
			local name = ::Brotherhood.ParentAttributes[index].Name;
			local value = screen.Rolls[name];
			current[name] <- current[name] + value;
			increases[name] += value;
			counts[name] += 1;
			names.push(name);
		}
		decisions.push({ Level=screen.Level, Attributes=names, ResultingFitness=bestScore.ParentFitness });
	}
	return { Profile=_profile, StartingScore=startingScore, FinalScore=::Brotherhood.parentScore(current, _profile), FinalStats=current, Increases=increases, Counts=counts, Decisions=decisions };
}

::Brotherhood.parentRankComparator <- function( _left, _right )
{
	if (_left.ParentFitness > _right.ParentFitness) return -1;
	if (_left.ParentFitness < _right.ParentFitness) return 1;
	return _left.Profile.ID <=> _right.Profile.ID;
}

::Brotherhood.resolveParentSelection <- function( _rankings, _body, _count )
{
	if (_count != 1 && _count != 4) throw "parent selection count must be 1 or 4";
	if (_rankings.len() == 0) return [];
	local ranked = clone _rankings;
	ranked.sort(::Brotherhood.parentRankComparator);
	local selectedCount = ::Math.min(_count, ranked.len());
	local cutoff = ranked[selectedCount - 1].ParentFitness;
	local above = [];
	local tied = [];
	foreach (score in ranked)
	{
		if (score.ParentFitness > cutoff) above.push(score);
		else if (score.ParentFitness == cutoff) tied.push(score);
	}
	local remaining = selectedCount - above.len();
	if (remaining >= tied.len()) { above.extend(tied); return above; }
	local tiedIDs = tied.map(@(_item) _item.Profile.ID);
	tiedIDs.sort();
	local context = "v=1|seed=" + _body.Seed + "|uid=" + (("RecruitUID" in _body) ? _body.RecruitUID : 0) + "|count=" + _count + "|cutoff=" + ::format("%.12f", cutoff) + "|remaining=" + remaining + "|tied=" + ::Brotherhood.parentJoin(tiedIDs, ",");
	local byID = {};
	foreach (score in tied) byID[score.Profile.ID] <- score;
	// Canonicalize only to make the input independent of file/load order, then
	// perform a seeded uniform shuffle. Lexical ID order never awards a seat.
	local state = ::Brotherhood.ParentRNG.createTieState(context);
	for (local i = tiedIDs.len() - 1; i > 0; --i)
	{
		local j = ::Brotherhood.ParentRNG.nextInt(state, 0, i);
		local swap = tiedIDs[i]; tiedIDs[i] = tiedIDs[j]; tiedIDs[j] = swap;
	}
	for (local i = 0; i < remaining; ++i) above.push(byID[tiedIDs[i]]);
	return above;
}

::Brotherhood.generateParentSelection <- function( _body, _profiles, _count = 4, _screens = null )
{
	local screens = _screens == null ? ::Brotherhood.parentGenerateRollSheets(_body.Seed, _body.Stars) : _screens;
	local before = ::Brotherhood.parentRollSheetFingerprint(screens);
	local developments = [];
	local rankings = [];
	local rejected = [];
	local errors = [];
	foreach (profile in _profiles)
	{
		try
		{
			local development = ::Brotherhood.parentDevelop(_body, profile, screens);
			developments.push(development);
			if (development.FinalScore.Eligible) rankings.push(development.FinalScore); else rejected.push(development.FinalScore);
		}
		catch (error)
		{
			errors.push({ Profile=profile, Error=error.tostring() });
			::logWarning("[Brotherhood][PARENT][SCORE] Skipped " + profile.Source + " / " + profile.ID + ": " + error);
		}
	}
	if (before != ::Brotherhood.parentRollSheetFingerprint(screens)) throw "parent candidate mutated the shared level-up roll sheets";
	rankings.sort(::Brotherhood.parentRankComparator);
	return { Body=_body, Screens=screens, RollSheetFingerprint=before, Developments=developments, Rankings=rankings, Rejected=rejected, Errors=errors, Selected=::Brotherhood.resolveParentSelection(rankings, _body, _count) };
}
