if (!("Brotherhood" in getroottable())) return;

::Brotherhood.ParentGenerationStorageVersion <- 2;
::Brotherhood.ParentGenerationFlagPrefix <- "BH_ParentGeneration_";

::Brotherhood.parentFormatFitness <- function( _value )
{
	return _value == null ? "ineligible" : ::format("%.6f", _value);
}

::Brotherhood.captureParentBody <- function( _actor )
{
	local properties = _actor.getBaseProperties().getClone();
	local skills = _actor.getSkills();
	local wasUpdating = skills.m.IsUpdating;
	skills.m.IsUpdating = true;
	try
	{
		foreach (skill in skills.getSkillsByFunction(@(_skill) _skill.isType(::Const.SkillType.Trait) || _skill.isType(::Const.SkillType.PermanentInjury))) skill.onUpdate(properties);
	}
	catch (error)
	{
		skills.m.IsUpdating = wasUpdating;
		throw error;
	}
	skills.m.IsUpdating = wasUpdating;

	local original = _actor.m.CurrentProperties;
	_actor.m.CurrentProperties = properties;
	local stats = null;
	try
	{
		stats = {
			hitpoints_max=_actor.getHitpointsMax().tofloat(), resolve=properties.getBravery().tofloat(), fatigue=_actor.getFatigueMax().tofloat(), initiative=properties.getInitiative().tofloat(),
			melee_skill=properties.getMeleeSkill().tofloat(), ranged_skill=properties.getRangedSkill().tofloat(), melee_defense=properties.getMeleeDefense().tofloat(), ranged_defense=properties.getRangedDefense().tofloat()
		};
	}
	catch (error)
	{
		_actor.m.CurrentProperties = original;
		throw error;
	}
	_actor.m.CurrentProperties = original;

	local stars = {};
	local talents = _actor.getTalents();
	foreach (attribute in ::Brotherhood.ParentAttributes) stars[attribute.Name] <- talents.len() > attribute.Index ? talents[attribute.Index] : 0;
	local traitIDs = [];
	local traitNames = [];
	foreach (skill in skills.getSkillsByFunction(@(_skill) _skill.isType(::Const.SkillType.Trait) && !_skill.isType(::Const.SkillType.Background)))
	{
		traitIDs.push(skill.getID());
		traitNames.push(skill.getName());
	}
	traitIDs.sort();
	traitNames.sort();
	local background = _actor.getBackground();
	return {
		Stats=stats, Stars=stars, TraitIDs=traitIDs, TraitNames=traitNames,
		BackgroundID=background == null ? "unknown" : background.getID(), BackgroundName=background == null ? "Unknown" : background.getName(),
		Seed=::Brotherhood.ParentRNG.deriveRecruitSeed(_actor), RecruitUID=_actor.getUID(), RecruitName=_actor.getName()
	};
}

::Brotherhood.parentSerializeScores <- function( _rankings, _rejected )
{
	local entries = [];
	foreach (score in _rankings) entries.push(score.Profile.ID + "=" + ::Brotherhood.parentFormatFitness(score.ParentFitness));
	foreach (score in _rejected) entries.push(score.Profile.ID + "=ineligible");
	entries.sort();
	return ::Brotherhood.parentJoin(entries, "|");
}

::Brotherhood.parentDeserializeScores <- function( _raw )
{
	local ret = {};
	if (_raw == null || _raw == "") return ret;
	foreach (entry in ::split(_raw, "|"))
	{
		local separator = entry.find("=");
		if (separator == null) continue;
		local id = entry.slice(0, separator);
		local value = entry.slice(separator + 1);
		ret[id] <- value == "ineligible" ? null : value.tofloat();
	}
	return ret;
}

::Brotherhood.storeParentGenerationData <- function( _actor, _selection )
{
	local ids = _selection.Selected.map(@(_score) _score.Profile.ID);
	local rawIDs = ::Brotherhood.parentJoin(ids, "|");
	local rawScores = ::Brotherhood.parentSerializeScores(_selection.Rankings, _selection.Rejected);
	local flags = _actor.getFlags();
	local prefix = ::Brotherhood.ParentGenerationFlagPrefix;
	flags.set(prefix + "Version", ::Brotherhood.ParentGenerationStorageVersion);
	flags.set(prefix + "Seed", _selection.Body.Seed);
	flags.set(prefix + "ParentIDs", rawIDs);
	flags.set(prefix + "Scores", rawScores);
	flags.set(prefix + "ProfileFingerprint", ::Brotherhood.ParentProfileSource.Fingerprint);
	flags.set(prefix + "RollFingerprint", _selection.RollSheetFingerprint);
	_actor.m.BH_ParentGenerationData = {
		Version=::Brotherhood.ParentGenerationStorageVersion, Seed=_selection.Body.Seed, ParentIDs=ids,
		Scores=::Brotherhood.parentDeserializeScores(rawScores), ProfileFingerprint=::Brotherhood.ParentProfileSource.Fingerprint,
		RollFingerprint=_selection.RollSheetFingerprint, Selection=_selection
	};
	return _actor.m.BH_ParentGenerationData;
}

::Brotherhood.restoreParentGenerationData <- function( _actor )
{
	local flags = _actor.getFlags();
	local prefix = ::Brotherhood.ParentGenerationFlagPrefix;
	if (!flags.has(prefix + "Version") || !flags.has(prefix + "ParentIDs")) return null;
	local ids = [];
	local rawIDs = flags.get(prefix + "ParentIDs");
	if (rawIDs != null && rawIDs != "") ids = ::split(rawIDs, "|");
	_actor.m.BH_ParentGenerationData = {
		Version=flags.get(prefix + "Version"), Seed=flags.has(prefix + "Seed") ? flags.get(prefix + "Seed") : null, ParentIDs=ids,
		Scores=::Brotherhood.parentDeserializeScores(flags.has(prefix + "Scores") ? flags.get(prefix + "Scores") : ""),
		ProfileFingerprint=flags.has(prefix + "ProfileFingerprint") ? flags.get(prefix + "ProfileFingerprint") : null,
		RollFingerprint=flags.has(prefix + "RollFingerprint") ? flags.get(prefix + "RollFingerprint") : null, Selection=null
	};
	return _actor.m.BH_ParentGenerationData;
}

::Brotherhood.getParentGenerationData <- function( _actor )
{
	if (_actor == null) return null;
	if ("BH_ParentGenerationData" in _actor.m && _actor.m.BH_ParentGenerationData != null) return _actor.m.BH_ParentGenerationData;
	return ::Brotherhood.restoreParentGenerationData(_actor);
}

::Brotherhood.logParentGenerationReport <- function( _selection )
{
	local body = _selection.Body;
	local stats = [];
	foreach (attribute in ::Brotherhood.ParentAttributes) stats.push(attribute.Name + "=" + body.Stats[attribute.Name] + "*" + body.Stars[attribute.Name]);
	local scores = [];
	foreach (score in _selection.Rankings) scores.push(score.Profile.ID + "=" + ::Brotherhood.parentFormatFitness(score.ParentFitness));
	foreach (score in _selection.Rejected) scores.push(score.Profile.ID + "=ineligible");
	local selected = _selection.Selected.map(@(_score) _score.Profile.ID);
	::logInfo("[Brotherhood][PARENT] Recruit=" + body.RecruitName + " (UID " + body.RecruitUID + "); background=" + body.BackgroundName + " [" + body.BackgroundID + "]; traits=[" + ::Brotherhood.parentJoin(body.TraitIDs, ",") + "]; raw_stats/stars={" + ::Brotherhood.parentJoin(stats, ", ") + "}; final_scores={" + ::Brotherhood.parentJoin(scores, ", ") + "}; selected=[" + ::Brotherhood.parentJoin(selected, ",") + "]; seed=" + body.Seed);
	if (!::Brotherhood.ParentGenerationDetailedDebugLogging) return;

	local ties = {};
	foreach (score in _selection.Rankings)
	{
		local key = ::format("%.12f", score.ParentFitness);
		if (!(key in ties)) ties[key] <- [];
		ties[key].push(score.Profile.ID);
	}
	foreach (fitness, ids in ties) if (ids.len() > 1) ::logInfo("[Brotherhood][PARENT][TIE] fitness=" + fitness + "; exact_tie=[" + ::Brotherhood.parentJoin(ids, ",") + "]");

	foreach (development in _selection.Developments)
	{
		local score = development.FinalScore;
		local projected = [];
		local allocation = [];
		foreach (attribute in ::Brotherhood.ParentAttributes)
		{
			projected.push(attribute.Name + "=" + development.FinalStats[attribute.Name]);
			allocation.push(attribute.Name + ":+" + development.Increases[attribute.Name] + "/" + development.Counts[attribute.Name] + "x");
		}
		local components = [];
		foreach (item in score.Contributions) components.push(item.Label + "=" + item.StatName + "(" + item.Match.Actual + "," + item.Match.Band + ",fit=" + ::Brotherhood.parentFormatFitness(item.Match.Fitness) + ",importance=" + item.Importance + ",weighted=" + ::Brotherhood.parentFormatFitness(item.WeightedFitness) + ")");
		local routing = [];
		foreach (claim in development.Profile.RoutingClaims)
		{
			local actual = claim.Stat in development.FinalStats ? development.FinalStats[claim.Stat] : null;
			routing.push(claim.Name + ":" + claim.Stat + "=" + actual + "<" + claim.ActivatesBelow + ",fit=" + ::Brotherhood.parentRoutingFitness(actual, claim.ActivatesBelow) + ",importance=" + claim.Importance);
		}
		local choices = [];
		foreach (decision in development.Decisions) choices.push("L" + decision.Level + ":" + ::Brotherhood.parentJoin(decision.Attributes, "+"));
		::logInfo("[Brotherhood][PARENT][DETAIL] parent=" + development.Profile.ID + "; start=" + ::Brotherhood.parentFormatFitness(development.StartingScore.ParentFitness) + "; final=" + ::Brotherhood.parentFormatFitness(score.ParentFitness) + "; base=" + ::Brotherhood.parentFormatFitness(score.BaseFitness) + "; routing_normalization=" + ::Brotherhood.parentFormatFitness(score.RoutingNormalization) + "; routing_bonus=" + ::Brotherhood.parentFormatFitness(score.RoutingBonus) + "; projected={" + ::Brotherhood.parentJoin(projected, ",") + "}; allocation={" + ::Brotherhood.parentJoin(allocation, ",") + "}; components=[" + ::Brotherhood.parentJoin(components, ";") + "]; routing=[" + ::Brotherhood.parentJoin(routing, ";") + "]; choices=[" + ::Brotherhood.parentJoin(choices, ",") + "]");
	}
	foreach (screen in _selection.Screens)
	{
		local rolls = [];
		foreach (attribute in ::Brotherhood.ParentAttributes) rolls.push(attribute.Name + "=+" + screen.Rolls[attribute.Name]);
		::logInfo("[Brotherhood][PARENT][ROLLS] L" + screen.Level + " {" + ::Brotherhood.parentJoin(rolls, ",") + "}");
	}
}

::Brotherhood.ensureParentGeneration <- function( _actor )
{
	if (!::Brotherhood.FleshcraftGenerationEnabled) return null;
	local existing = ::Brotherhood.getParentGenerationData(_actor);
	if (existing != null) return existing;
	try
	{
		local body = ::Brotherhood.captureParentBody(_actor);
		local selection = ::Brotherhood.generateParentSelection(body, ::Brotherhood.ParentProfiles, 4);
		if (selection.Selected.len() != 4)
		{
			::logWarning("[Brotherhood][PARENT] Only " + selection.Selected.len() + " valid parents were available for " + body.RecruitName + "; no default was substituted and Reforged generation will be used.");
			return null;
		}
		local data = ::Brotherhood.storeParentGenerationData(_actor, selection);
		local readBack = ::Brotherhood.restoreParentGenerationData(_actor);
		if (readBack == null || ::Brotherhood.parentJoin(readBack.ParentIDs, "|") != ::Brotherhood.parentJoin(data.ParentIDs, "|")) throw "stored parent data failed immediate read-back verification";
		_actor.m.BH_ParentGenerationData.Selection = selection;
		if (::Brotherhood.ParentGenerationDebugLogging) ::Brotherhood.logParentGenerationReport(selection);
		return _actor.m.BH_ParentGenerationData;
	}
	catch (error)
	{
		::logWarning("[Brotherhood][PARENT] Generation failed safely for " + _actor.getName() + " (UID " + _actor.getUID() + "): " + error + ". Reforged generation will be used.");
		return null;
	}
}

::Brotherhood.initializeParentGeneration <- function()
{
	::Brotherhood.loadParentProfiles();
	if (::Brotherhood.TestingMode && ::Brotherhood.ParentGenerationRunParityFixture) ::Brotherhood.runParentParityFixture();
	::Brotherhood.HooksMod.hook("scripts/entity/tactical/player", function(q) {
		q.m.BH_ParentGenerationData <- null;
		q.onDeserialize = @(__original) { function onDeserialize( _in )
		{
			__original(_in);
			local data = ::Brotherhood.restoreParentGenerationData(this);
			if (data != null && ::Brotherhood.ParentGenerationDebugLogging) ::logInfo("[Brotherhood][PARENT][LOAD] " + this.getName() + " restored [" + ::Brotherhood.parentJoin(data.ParentIDs, ",") + "] with seed " + data.Seed + ".");
		}}.onDeserialize;
		q.getBHParentGenerationData <- { function getBHParentGenerationData() { return ::Brotherhood.getParentGenerationData(this); } }.getBHParentGenerationData;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/backgrounds/character_background", function(q) {
		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret = __original();
			if (!::Brotherhood.ParentGenerationDebugShowOnCharacter || this.getContainer() == null) return ret;
			local data = ::Brotherhood.getParentGenerationData(this.getContainer().getActor());
			if (data == null || data.ParentIDs.len() == 0) return ret;
			local names = data.ParentIDs.map(@(_id) ::Brotherhood.getParentProfileName(_id));
			ret.push({ id=19001, type="description", icon="ui/icons/special.png", text="[DEBUG] Brotherhood parents: " + ::Brotherhood.parentJoin(names, ", ") + ". Seed: " + data.Seed + "." });
			return ret;
		}}.getTooltip;
	});
}
