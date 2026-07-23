if (!("Brotherhood" in getroottable())) return;

// Fixed Python reference fixture. The roll sheets below were produced by the
// standalone simulator for seed 177013 and are injected so this test compares
// scoring/development rather than the private runtime PRNG implementation.
::Brotherhood.ParentParityFixture <- {
	Body = {
		Seed=177013, RecruitUID=177013, RecruitName="Parity Fixture", BackgroundID="background.farmhand", BackgroundName="Farmhand", TraitIDs=["trait.strong"], TraitNames=["Strong"],
		Stats={ hitpoints_max=58.0, resolve=42.0, fatigue=98.0, initiative=108.0, melee_skill=57.0, ranged_skill=44.0, melee_defense=4.0, ranged_defense=3.0 },
		Stars={ hitpoints_max=1, resolve=0, fatigue=2, initiative=1, melee_skill=3, ranged_skill=0, melee_defense=2, ranged_defense=0 }
	},
	Screens = [
		{ Level=2, Rolls={hitpoints_max=3,resolve=3,fatigue=4,initiative=5,melee_skill=4,ranged_skill=4,melee_defense=3,ranged_defense=4}, Ordered=[3,3,4,5,4,4,3,4] },
		{ Level=3, Rolls={hitpoints_max=3,resolve=4,fatigue=4,initiative=5,melee_skill=3,ranged_skill=4,melee_defense=3,ranged_defense=3}, Ordered=[3,4,4,5,3,4,3,3] },
		{ Level=4, Rolls={hitpoints_max=3,resolve=4,fatigue=4,initiative=4,melee_skill=4,ranged_skill=4,melee_defense=3,ranged_defense=3}, Ordered=[3,4,4,4,4,4,3,3] },
		{ Level=5, Rolls={hitpoints_max=4,resolve=2,fatigue=4,initiative=5,melee_skill=4,ranged_skill=2,melee_defense=3,ranged_defense=3}, Ordered=[4,2,4,5,4,2,3,3] },
		{ Level=6, Rolls={hitpoints_max=3,resolve=2,fatigue=4,initiative=4,melee_skill=4,ranged_skill=4,melee_defense=3,ranged_defense=4}, Ordered=[3,2,4,4,4,4,3,4] },
		{ Level=7, Rolls={hitpoints_max=4,resolve=3,fatigue=4,initiative=4,melee_skill=3,ranged_skill=2,melee_defense=3,ranged_defense=4}, Ordered=[4,3,4,4,3,2,3,4] },
		{ Level=8, Rolls={hitpoints_max=4,resolve=2,fatigue=4,initiative=4,melee_skill=4,ranged_skill=4,melee_defense=3,ranged_defense=2}, Ordered=[4,2,4,4,4,4,3,2] },
		{ Level=9, Rolls={hitpoints_max=3,resolve=2,fatigue=4,initiative=5,melee_skill=3,ranged_skill=2,melee_defense=3,ranged_defense=3}, Ordered=[3,2,4,5,3,2,3,3] },
		{ Level=10, Rolls={hitpoints_max=4,resolve=3,fatigue=4,initiative=5,melee_skill=3,ranged_skill=3,melee_defense=3,ranged_defense=3}, Ordered=[4,3,4,5,3,3,3,3] },
		{ Level=11, Rolls={hitpoints_max=4,resolve=2,fatigue=4,initiative=4,melee_skill=4,ranged_skill=2,melee_defense=3,ranged_defense=2}, Ordered=[4,2,4,4,4,2,3,2] }
	],
	ExpectedOrder = ["qatal_duelist", "duelist", "support_frontliner", "injury_specialist", "hybrid", "archer", "pure_thrower"],
	ExpectedSelected = ["qatal_duelist", "duelist", "support_frontliner", "injury_specialist"],
	ExpectedFitness = [3.7666666667, 3.7333333333, 3.68, 3.5, 2.7285714286, 2.7166666667, 2.7166666667]
};

::Brotherhood.runParentParityFixture <- function()
{
	local fixture = ::Brotherhood.ParentParityFixture;
	local legacyProfiles = [];
	foreach (profile in ::Brotherhood.ParentProfiles)
	{
		if (fixture.ExpectedOrder.find(profile.ID) != null) legacyProfiles.push(profile);
	}
	if (legacyProfiles.len() != fixture.ExpectedOrder.len()) throw "parent parity fixture is missing one or more legacy parent profiles";
	local result = ::Brotherhood.generateParentSelection(fixture.Body, legacyProfiles, 4, fixture.Screens);
	if (result.Rankings.len() != fixture.ExpectedOrder.len()) throw "parent parity fixture returned the wrong ranking count";
	foreach (index, expectedID in fixture.ExpectedOrder)
	{
		local actual = result.Rankings[index];
		if (actual.Profile.ID != expectedID) throw "parent parity ordering mismatch at " + index + ": expected " + expectedID + ", got " + actual.Profile.ID;
		if (::Math.abs(actual.ParentFitness - fixture.ExpectedFitness[index]) > 0.00001) throw "parent parity fitness mismatch for " + expectedID + ": expected " + fixture.ExpectedFitness[index] + ", got " + actual.ParentFitness;
	}
	if (result.Selected.len() != fixture.ExpectedSelected.len()) throw "parent parity fixture returned the wrong selected count";
	foreach (index, expectedID in fixture.ExpectedSelected)
		if (result.Selected[index].Profile.ID != expectedID) throw "parent parity selected mismatch at " + index + ": expected " + expectedID + ", got " + result.Selected[index].Profile.ID;
	::logInfo("[Brotherhood][PARENT][PARITY] PASS order=[" + ::Brotherhood.parentJoin(fixture.ExpectedOrder, ",") + "] selected=[" + ::Brotherhood.parentJoin(fixture.ExpectedSelected, ",") + "]");
	return true;
}
