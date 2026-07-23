if (!("Brotherhood" in getroottable())) return;

::Brotherhood.initializeReforgedScenarioPresentation <- function()
{
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
