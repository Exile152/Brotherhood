this.bh_flagellant_injury_debug_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},

	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.bh_flagellant_injury_debug";
		this.m.Name = "[DEBUG] Draught of Eleven Pains";
		this.m.Description = "A testing potion that immediately inflicts one temporary injury from each Truthful Pain family.";
		this.m.Icon = "consumables/potion_01.png";
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local ret = this.anatomist_potion_item.getTooltip();
		ret.push({
			id = 60,
			type = "text",
			icon = "ui/icons/days_wounded.png",
			text = "Inflicts " + ::MSU.Text.colorDamage("11") + " temporary injuries, one from each Truthful Pain family"
		});
		ret.push({
			id = 61,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Use on the Flagellant with Truthful Pain; all injuries are converted immediately"
		});
		return ret;
	}

	function onUse( _actor, _item = null )
	{
		local sourceScripts = [
			"scripts/skills/injury/fractured_hand_injury",
			"scripts/skills/injury/injured_shoulder_injury",
			"scripts/skills/injury/sprained_ankle_injury",
			"scripts/skills/injury/fractured_elbow_injury",
			"scripts/skills/injury/broken_nose_injury",
			"scripts/skills/injury/broken_ribs_injury",
			"scripts/skills/injury/exposed_ribs_injury",
			"scripts/skills/injury/cut_artery_injury",
			"scripts/skills/injury/deep_face_cut_injury",
			"scripts/skills/injury/severe_concussion_injury",
			"scripts/skills/injury/rf_heat_stroke_injury"
		];
		foreach (script in sourceScripts) _actor.getSkills().add(::new(script));

		local truthfulPain = _actor.getSkills().getSkillByID("perk.bh_truthful_pain");
		if (truthfulPain != null) truthfulPain.convert();
		::Brotherhood.logObsidianTest("TRUTHFUL PAIN DEBUG", _actor, "Draught of Eleven Pains added " + sourceScripts.len() + " representative source injuries; Truthful Pain present=" + (truthfulPain != null ? "true" : "false") + ".");
		return this.anatomist_potion_item.onUse(_actor, _item);
	}
});
