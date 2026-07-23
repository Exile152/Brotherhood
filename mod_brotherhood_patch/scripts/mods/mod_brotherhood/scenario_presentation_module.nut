if (!("Brotherhood" in getroottable())) return;

// Reforged injects guaranteed origin perks through scenario onBuildPerkTree hooks.
// Fleshcraft owns player perk trees, so those injections are stale noise.
::Brotherhood.StaleOriginScenarioDescriptionLines <- [
	"\n[color=#bcad8c]Militia:[/color] All recruits have access to the Militia perk group.",
	"\n[color=#bcad8c]Pathfinders:[/color] All recruits have access to the Pathfinder perk.",
	"\n[color=#bcad8c]Adrenaline:[/color] All recruits have access to the Adrenaline perk.",
	"\n[color=#bcad8c]Brave Hunters:[/color] All recruits have access to the Fortified Mind perk."
];

::Brotherhood.StaleOriginScenarioScriptPaths <- [
	"scripts/scenarios/world/militia_scenario",
	"scripts/scenarios/world/rangers_scenario",
	"scripts/scenarios/world/raiders_scenario",
	"scripts/scenarios/world/beast_hunters_scenario"
];

::Brotherhood.stripStaleOriginScenarioDescription <- function( _scenario )
{
	if (_scenario == null || !("m" in _scenario) || !("Description" in _scenario.m)) return;

	foreach (line in ::Brotherhood.StaleOriginScenarioDescriptionLines)
	{
		local index = _scenario.m.Description.find(line);
		if (index != null)
		{
			_scenario.m.Description = _scenario.m.Description.slice(0, index) + _scenario.m.Description.slice(index + line.len());
		}
	}
}

::Brotherhood.hookStaleOriginScenario <- function( _scriptPath )
{
	::Brotherhood.HooksMod.hook(_scriptPath, function(q) {
		q.create = @(__original) { function create()
		{
			__original();
			if (::Brotherhood.FleshcraftGenerationEnabled) ::Brotherhood.stripStaleOriginScenarioDescription(this);
		}}.create;

		q.onBuildPerkTree = @(__original) { function onBuildPerkTree( _perkTree )
		{
			if (::Brotherhood.FleshcraftGenerationEnabled && ::Brotherhood.isFleshcraftPerkTree(_perkTree)) return;
			return __original(_perkTree);
		}}.onBuildPerkTree;
	});
}

::Brotherhood.initializeStaleOriginPerkSuppression <- function()
{
	foreach (scriptPath in ::Brotherhood.StaleOriginScenarioScriptPaths)
	{
		::Brotherhood.hookStaleOriginScenario(scriptPath);
	}
}

::Brotherhood.initializeReforgedScenarioPresentation <- function()
{
	::Brotherhood.initializeStaleOriginPerkSuppression();
	::Brotherhood.HooksMod.hook("scripts/scenarios/world/rf_random_solo", function(q) {
		q.create = @(__original) { function create()
		{
			__original();
			this.m.Name = "Random Solo";
		}}.create;
		q.getName = @() { function getName() { return "Random Solo"; }}.getName;
	});

	::Brotherhood.HooksMod.hook("scripts/scenarios/world/rf_random_trio", function(q) {
		q.create = @(__original) { function create()
		{
			__original();
			this.m.Name = "Random Trio";
		}}.create;
		q.getName = @() { function getName() { return "Random Trio"; }}.getName;
	});

	::Brotherhood.HooksMod.hook("scripts/scenarios/world/rf_old_swordmaster_scenario", function(q) {
		q.isValid = @() { function isValid() { return false; }}.isValid;
	});
}
