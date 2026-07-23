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

::Brotherhood.validateParentProfile <- function( _profile )
{
	if (!("SchemaVersion" in _profile) || _profile.SchemaVersion != 1) throw "unsupported schema version";
	if (!("ID" in _profile) || typeof _profile.ID != "string" || _profile.ID == "") throw "profile id is required";
	if (!("Name" in _profile) || typeof _profile.Name != "string" || _profile.Name == "") throw "profile display name is required";
	if (!("Source" in _profile) || _profile.Source != "0M " + _profile.Name + ".md") throw "authored parent requires its matching 0M profile";
	if (!("BuildSource" in _profile) || _profile.BuildSource != "0B " + _profile.Name + ".canvas") throw "authored parent requires its matching 0B build canvas";
	if (!("Stats" in _profile) || typeof _profile.Stats != "array" || _profile.Stats.len() == 0) throw "profile must contain projected stats";
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
	foreach (claim in _profile.RoutingClaims)
	{
		if (!("Name" in claim) || typeof claim.Name != "string" || claim.Name == "") throw "routing claim name is required";
		if (!("Stat" in claim) || !(claim.Stat in stats)) throw "routing claim " + claim.Name + " references unknown stat";
		if (!("ActivatesBelow" in claim) || (typeof claim.ActivatesBelow != "integer" && typeof claim.ActivatesBelow != "float")) throw "routing claim " + claim.Name + " has invalid activation threshold";
		if (!("Preference" in claim) || claim.Preference != "lower") throw "routing claim " + claim.Name + " currently supports only lower preference";
		if (!("Importance" in claim) || claim.Importance <= 0) throw "routing claim " + claim.Name + " importance must be positive";
	}
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
