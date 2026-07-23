this.perk_bh_scholastic_anatomy <- this.inherit("scripts/skills/skill", {
	m = { IsConvertingInjuries = false },
	function create() { this.m.ID = "perk.bh_scholastic_anatomy"; this.m.Name = "Scholastic Anatomy"; this.m.Description = ::Brotherhood.getPlagueDoctorTooltip(this.m.ID); this.m.Icon = "ui/perks/perk_09.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; this.m.IsActive = false; }

	function getTemporaryReplacementScript( _injuryID )
	{
		local replacements = {
			"injury.brain_damage": "scripts/skills/injury/severe_concussion_injury",
			"injury.broken_elbow_joint": "scripts/skills/injury/fractured_elbow_injury",
			"injury.broken_knee": "scripts/skills/injury/injured_knee_cap_injury",
			"injury.collapsed_lung_part": "scripts/skills/injury/pierced_lung_injury",
			"injury.traumatized": "scripts/skills/injury/fractured_skull_injury",
			"injury.weakened_heart": "scripts/skills/injury/crushed_windpipe_injury"
		};
		return _injuryID in replacements ? replacements[_injuryID] : null;
	}

	function convertPermanentInjuries()
	{
		if (this.m.IsConvertingInjuries || this.getContainer() == null) return;
		this.m.IsConvertingInjuries = true;

		local replacements = [];
		foreach (injury in this.getContainer().getAllSkillsOfType(this.Const.SkillType.PermanentInjury))
		{
			local replacementScript = this.getTemporaryReplacementScript(injury.getID());
			if (replacementScript != null) replacements.push({ Injury = injury, Script = replacementScript });
		}

		foreach (replacement in replacements)
		{
			this.getContainer().remove(replacement.Injury);
			local temporaryInjury = this.new(replacement.Script);
			if ("setOutOfCombat" in temporaryInjury) temporaryInjury.setOutOfCombat(true);
			this.getContainer().add(temporaryInjury);
		}

		this.m.IsConvertingInjuries = false;
	}

	function halveTemporaryInjuryDurations()
	{
		if (this.getContainer() == null) return;
		foreach (injury in this.getContainer().getAllSkillsOfType(this.Const.SkillType.TemporaryInjury))
		{
			if (!("HealingTimeMin" in injury.m) || !("HealingTimeMax" in injury.m)) continue;
			if ("BH_ScholasticDurationHalved" in injury.m && injury.m.BH_ScholasticDurationHalved) continue;

			injury.m.HealingTimeMin = this.Math.max(1, this.Math.ceil(injury.m.HealingTimeMin * 0.5));
			injury.m.HealingTimeMax = this.Math.max(injury.m.HealingTimeMin, this.Math.ceil(injury.m.HealingTimeMax * 0.5));
			if ("BH_ScholasticDurationHalved" in injury.m) injury.m.BH_ScholasticDurationHalved = true;
			else injury.m.BH_ScholasticDurationHalved <- true;
		}
	}

	function onAdded()
	{
		this.convertPermanentInjuries();
		this.halveTemporaryInjuryDurations();
	}

	function onUpdate( _properties )
	{
		this.convertPermanentInjuries();
		this.halveTemporaryInjuryDurations();
	}
});
