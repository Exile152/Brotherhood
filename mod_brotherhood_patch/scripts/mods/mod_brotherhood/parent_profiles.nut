if (!("Brotherhood" in getroottable())) return;

::Brotherhood.ParentProfiles <- [];
::Brotherhood.ParentProfileByID <- {};

::Brotherhood.validateParentProfileStat <- function( _stat )
{
	if (!("Name" in _stat) || typeof _stat.Name != "string" || _stat.Name == "") throw "stat name is required";
	if (!("Importance" in _stat) || (typeof _stat.Importance != "integer" && typeof _stat.Importance != "float")) throw _stat.Name + ".importance must be numeric";
	if (_stat.Importance < 0) throw _stat.Name + ".importance cannot be negative";
	if (!("Direction" in _stat) || (_stat.Direction != "higher" && _stat.Direction != "lower")) throw _stat.Name + ".direction must be higher or lower";
	if (_stat.Importance == 0) return;
	foreach (field in ["Bad", "Acceptable", "Great", "Premium"])
	{
		if (!(field in _stat) || _stat[field] == null) throw _stat.Name + " has positive importance but incomplete fitness thresholds";
	}
	local values = [_stat.Bad, _stat.Acceptable, _stat.Great, _stat.Premium];
	for (local i = 1; i < values.len(); ++i)
	{
		if (_stat.Direction == "higher" && values[i - 1] >= values[i]) throw _stat.Name + " thresholds must be strictly ascending";
		if (_stat.Direction == "lower" && values[i - 1] <= values[i]) throw _stat.Name + " thresholds must be strictly descending";
	}
}

::Brotherhood.validateParentRoutingClaim <- function( _claim, _stats )
{
	if (!("Name" in _claim) || typeof _claim.Name != "string" || _claim.Name == "") throw "routing claim name is required";
	if (!("Importance" in _claim) || _claim.Importance <= 0) throw "routing claim " + _claim.Name + " importance must be positive";
	local requires = ("RequiresQualified" in _claim && _claim.RequiresQualified != null) ? _claim.RequiresQualified : [];
	local excludes = ("ExcludesQualified" in _claim && _claim.ExcludesQualified != null) ? _claim.ExcludesQualified : [];
	local isRelational = (("IsRelational" in _claim) && _claim.IsRelational) || requires.len() > 0 || excludes.len() > 0;
	if (isRelational)
	{
		if (requires.len() == 0) throw "routing claim " + _claim.Name + " requires_qualified must name at least one stat";
		if (("Stat" in _claim) && _claim.Stat != null && _claim.Stat != "") throw "routing claim " + _claim.Name + " relational claims cannot also use stat";
		if (("ActivatesBelow" in _claim) && _claim.ActivatesBelow != null) throw "routing claim " + _claim.Name + " relational claims cannot also use activates_below";
		foreach (name in requires)
		{
			if (!(name in _stats)) throw "routing claim " + _claim.Name + " references unknown requires_qualified stat " + name;
			if (_stats[name].Importance <= 0) throw "routing claim " + _claim.Name + " requires_qualified stats must have positive importance";
		}
		foreach (name in excludes)
			if (!(name in _stats)) throw "routing claim " + _claim.Name + " references unknown excludes_qualified stat " + name;
		return;
	}
	if (!("Stat" in _claim) || !(_claim.Stat in _stats)) throw "routing claim " + _claim.Name + " references unknown stat";
	if (!("ActivatesBelow" in _claim) || (typeof _claim.ActivatesBelow != "integer" && typeof _claim.ActivatesBelow != "float")) throw "routing claim " + _claim.Name + " has invalid activation threshold";
	if (!("Preference" in _claim) || _claim.Preference != "lower") throw "routing claim " + _claim.Name + " currently supports only lower preference";
}

::Brotherhood.validateParentConjunctiveFitness <- function( _model, _stats, _routingClaims )
{
	if (_model == null) return;
	foreach (field in ["MinimumProjectedSide", "DeadSideBelow", "AptitudeOneAt", "AptitudeStep", "MinimumAnchorEvidence", "WeakerWeight", "StrongerWeight"])
		if (!(field in _model) || (typeof _model[field] != "integer" && typeof _model[field] != "float")) throw "conjunctive_fitness." + field + " must be numeric";
	if (!("Sides" in _model) || typeof _model.Sides != "array" || _model.Sides.len() != 2) throw "conjunctive_fitness requires exactly two aptitude sides";
	foreach (side in _model.Sides)
	{
		if (!("Name" in side) || typeof side.Name != "string" || side.Name == "") throw "conjunctive_fitness side name is required";
		if (!("Members" in side) || typeof side.Members != "array" || side.Members.len() == 0) throw "every conjunctive_fitness side must contain at least one stat";
		foreach (member in side.Members)
			if (!(member in _stats)) throw "conjunctive_fitness references unknown stat " + member;
	}
	if (_model.MinimumProjectedSide <= 0 || _model.DeadSideBelow <= 0 || _model.AptitudeOneAt <= 0 || _model.AptitudeStep <= 0) throw "conjunctive_fitness thresholds must be positive";
	if (_model.MinimumAnchorEvidence < 0 || _model.MinimumAnchorEvidence > 1) throw "conjunctive_fitness.minimum_anchor_evidence must be between 0 and 1";
	if (_model.DeadSideBelow >= _model.MinimumProjectedSide) throw "conjunctive_fitness.dead_side_below must be below minimum_projected_side";
	if (::Math.abs((_model.WeakerWeight + _model.StrongerWeight) - 1.0) > 0.0001) throw "conjunctive_fitness weaker and stronger weights must sum to 1";
	if (_routingClaims != null && _routingClaims.len() != 0) throw "conjunctive_fitness cannot currently be combined with routing_claims";
}

::Brotherhood.validateParentProfile <- function( _profile )
{
	if (!("SchemaVersion" in _profile) || _profile.SchemaVersion != 1) throw "unsupported schema version";
	if (!("ID" in _profile) || typeof _profile.ID != "string" || _profile.ID == "") throw "profile id is required";
	if (!("Name" in _profile) || typeof _profile.Name != "string" || _profile.Name == "") throw "profile display name is required";
	if (!("Source" in _profile) || _profile.Source != "0M " + _profile.Name + ".md") throw "authored parent requires its matching 0M profile";
	if (!("BuildSource" in _profile) || _profile.BuildSource != "0B " + _profile.Name + ".canvas") throw "authored parent requires its matching 0B build canvas";
	if (!("Stats" in _profile) || typeof _profile.Stats != "array" || _profile.Stats.len() == 0) throw "profile must contain projected stats";
	if (!("Tempo" in _profile) || typeof _profile.Tempo != "bool") throw "profile Tempo flag must be boolean";
	local stats = {};
	foreach (stat in _profile.Stats)
	{
		::Brotherhood.validateParentProfileStat(stat);
		if (stat.Name in stats) throw "duplicate stat " + stat.Name;
		stats[stat.Name] <- stat;
	}
	local grouped = {};
	foreach (group in _profile.Alternatives)
	{
		if (!("Name" in group) || typeof group.Name != "string" || group.Name == "" || !("Members" in group) || typeof group.Members != "array" || group.Members.len() < 2) throw "invalid alternative group";
		foreach (member in group.Members)
		{
			if (!(member in stats)) throw "alternative group " + group.Name + " references unknown stat " + member;
			if (member in grouped) throw "stat " + member + " appears in more than one alternative group";
			grouped[member] <- true;
		}
	}
	foreach (claim in _profile.RoutingClaims) ::Brotherhood.validateParentRoutingClaim(claim, stats);
	::Brotherhood.validateParentConjunctiveFitness(("ConjunctiveFitness" in _profile) ? _profile.ConjunctiveFitness : null, stats, _profile.RoutingClaims);
	return _profile;
}

::Brotherhood.loadParentProfiles <- function()
{
	::Brotherhood.ParentProfiles.clear();
	::Brotherhood.ParentProfileByID.clear();
	foreach (profile in ::Brotherhood.ParentProfileSource.Profiles)
	{
		local status = "ReviewStatus" in profile ? profile.ReviewStatus.tolower() : "reviewed";
		if (status == "draft" || status == "template" || status == "inactive")
		{
			if (::Brotherhood.ParentGenerationDebugLogging) ::logInfo("[Brotherhood][PARENT][PROFILE] Skipped " + profile.Source + " because review_status is " + status + ".");
			continue;
		}
		try
		{
			::Brotherhood.validateParentProfile(profile);
			if (profile.ID in ::Brotherhood.ParentProfileByID) throw "duplicate profile id " + profile.ID;
			::Brotherhood.ParentProfiles.push(profile);
			::Brotherhood.ParentProfileByID[profile.ID] <- profile;
		}
		catch (error)
		{
			::logWarning("[Brotherhood][PARENT][PROFILE] Skipped " + ("Source" in profile ? profile.Source : "unknown source") + " / " + ("ID" in profile ? profile.ID : "unknown id") + ": " + error);
		}
	}
	::Brotherhood.ParentProfiles.sort(@(_left, _right) _left.ID <=> _right.ID);
	return ::Brotherhood.ParentProfiles;
}

::Brotherhood.getParentProfileName <- function( _id )
{
	return _id in ::Brotherhood.ParentProfileByID ? ::Brotherhood.ParentProfileByID[_id].Name : _id;
}
