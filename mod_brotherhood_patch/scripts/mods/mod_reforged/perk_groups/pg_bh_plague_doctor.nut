this.pg_bh_plague_doctor <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		// This script is instantiated in Reforged's After5 queue, before Dynamic
		// Perks performs its global VeryLate metadata pass. Ensure every referenced
		// definition is ready at the exact point the group consumes it.
		foreach (id in [
			"perk.bags_and_belts", "perk.bh_crippling_strikes",
			"perk.bh_ghost_pain", "perk.bh_medicine_mastery",
			"perk.bh_magna_medicina", "perk.bh_scholastic_anatomy"
		])
		{
			local perk = ::Const.Perks.findById(id);
			if (perk == null) throw "Brotherhood Plague Doctor perk was not registered before its group: " + id;
			if (!("PerkGroupIDs" in perk)) perk.PerkGroupIDs <- [];
		}

		this.m.ID = "pg.bh_plague_doctor";
		this.m.Name = "Plague Doctor";
		this.m.Description = "A learned battlefield physician who spreads suffering and reverses wounds.";
		this.m.Icon = "ui/perk_groups/rf_student.png";
		this.m.Tree = [["perk.bags_and_belts", "perk.bh_crippling_strikes"], [], ["perk.bh_ghost_pain"], ["perk.bh_medicine_mastery"], ["perk.bh_magna_medicina"], [], ["perk.bh_scholastic_anatomy"]];
	}
});
