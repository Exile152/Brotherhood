this.perk_bh_truthful_pain <- this.inherit("scripts/skills/skill", {
	m = { Converting = false },
	function create()
	{
		this.m.ID = "perk.bh_truthful_pain";
		this.m.Name = "Truthful Pain";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_13.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function convert()
	{
		if (this.m.Converting) return;
		this.m.Converting = true;
		local replacements = {
			"injury.crushed_finger": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.fractured_hand": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.smashed_hand": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.cut_arm": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.split_hand": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.pierced_arm_muscles": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.pierced_hand": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.burnt_hands": "scripts/skills/injury/bh_hands_stigmata_injury",
			"injury.broken_arm": "scripts/skills/injury/bh_scourged_shoulder_injury",
			"injury.dislocated_shoulder": "scripts/skills/injury/bh_scourged_shoulder_injury",
			"injury.injured_shoulder": "scripts/skills/injury/bh_scourged_shoulder_injury",
			"injury.cut_arm_sinew": "scripts/skills/injury/bh_scourged_shoulder_injury",
			"injury.split_shoulder": "scripts/skills/injury/bh_scourged_shoulder_injury",
			"injury.bruised_leg": "scripts/skills/injury/bh_pilgrims_agony_injury",
			"injury.sprained_ankle": "scripts/skills/injury/bh_pilgrims_agony_injury",
			"injury.broken_leg": "scripts/skills/injury/bh_pilgrims_agony_injury",
			"injury.cut_achilles_tendon": "scripts/skills/injury/bh_pilgrims_agony_injury",
			"injury.injured_knee_cap": "scripts/skills/injury/bh_pilgrims_agony_injury",
			"injury.burnt_legs": "scripts/skills/injury/bh_pilgrims_agony_injury",
			"injury.ripped_ear": "scripts/skills/injury/bh_pilgrims_agony_injury",
			"injury.fractured_elbow": "scripts/skills/injury/bh_vigilant_flesh_injury",
			"injury.cut_leg_muscles": "scripts/skills/injury/bh_vigilant_flesh_injury",
			"injury.pierced_leg_muscles": "scripts/skills/injury/bh_vigilant_flesh_injury",
			"injury.broken_nose": "scripts/skills/injury/bh_breath_of_penance_injury",
			"injury.split_nose": "scripts/skills/injury/bh_breath_of_penance_injury",
			"injury.pierced_cheek": "scripts/skills/injury/bh_breath_of_penance_injury",
			"injury.crushed_windpipe": "scripts/skills/injury/bh_breath_of_penance_injury",
			"injury.rf_dislocated_jaw": "scripts/skills/injury/bh_breath_of_penance_injury",
			"injury.broken_ribs": "scripts/skills/injury/bh_hollowed_vessel_injury",
			"injury.fractured_ribs": "scripts/skills/injury/bh_hollowed_vessel_injury",
			"injury.pierced_chest": "scripts/skills/injury/bh_hollowed_vessel_injury",
			"injury.pierced_side": "scripts/skills/injury/bh_hollowed_vessel_injury",
			"injury.pierced_lung": "scripts/skills/injury/bh_hollowed_vessel_injury",
			"injury.inhaled_flames": "scripts/skills/injury/bh_hollowed_vessel_injury",
			"injury.exposed_ribs": "scripts/skills/injury/bh_mortification_of_the_flesh_injury",
			"injury.grazed_kidney": "scripts/skills/injury/bh_mortification_of_the_flesh_injury",
			"injury.deep_abdominal_cut": "scripts/skills/injury/bh_mortification_of_the_flesh_injury",
			"injury.deep_chest_cut": "scripts/skills/injury/bh_mortification_of_the_flesh_injury",
			"injury.stabbed_guts": "scripts/skills/injury/bh_mortification_of_the_flesh_injury",
			"injury.cut_artery": "scripts/skills/injury/bh_blood_offering_injury",
			"injury.cut_throat": "scripts/skills/injury/bh_blood_offering_injury",
			"injury.grazed_neck": "scripts/skills/injury/bh_blood_offering_injury",
			"injury.deep_face_cut": "scripts/skills/injury/bh_blind_faith_injury",
			"injury.grazed_eye_socket": "scripts/skills/injury/bh_blind_faith_injury",
			"injury.burnt_face": "scripts/skills/injury/bh_blind_faith_injury",
			"injury.rf_black_eye": "scripts/skills/injury/bh_blind_faith_injury",
			"injury.severe_concussion": "scripts/skills/injury/bh_holy_delirium_injury",
			"injury.fractured_skull": "scripts/skills/injury/bh_holy_delirium_injury",
			"injury.rf_heat_stroke": "scripts/skills/injury/bh_cleansing_fever_injury"
		};
		local pending = [];
		foreach (injury in this.getContainer().getAllSkillsOfType(this.Const.SkillType.TemporaryInjury))
		{
			if (injury.getID() in replacements) pending.push({ Source = injury, Script = replacements[injury.getID()] });
		}
		local actor = this.getContainer().getActor();
		local bonusDescriptions = {
			"scripts/skills/injury/bh_hands_stigmata_injury": "+3 Melee Skill and +3 Ranged Skill",
			"scripts/skills/injury/bh_scourged_shoulder_injury": "+5% damage",
			"scripts/skills/injury/bh_pilgrims_agony_injury": "+10 Initiative",
			"scripts/skills/injury/bh_vigilant_flesh_injury": "+3 Melee Defense",
			"scripts/skills/injury/bh_breath_of_penance_injury": "+1 Fatigue Recovery each turn",
			"scripts/skills/injury/bh_hollowed_vessel_injury": "+5 Maximum Fatigue",
			"scripts/skills/injury/bh_mortification_of_the_flesh_injury": "+5 Resolve",
			"scripts/skills/injury/bh_blood_offering_injury": "+5% damage while below 50% Hitpoints",
			"scripts/skills/injury/bh_blind_faith_injury": "+3 Melee Defense and +3 Ranged Defense",
			"scripts/skills/injury/bh_holy_delirium_injury": "+10 Resolve",
			"scripts/skills/injury/bh_cleansing_fever_injury": "5% less Fatigue built"
		};
		foreach (entry in pending)
		{
			local source = entry.Source;
			local sourceID = source.getID();
			local sourceName = source.getNameOnly();
			local replacement = ::new(entry.Script);
			replacement.m.HealingTimeMin = source.m.HealingTimeMin;
			replacement.m.HealingTimeMax = source.m.HealingTimeMax;
			replacement.m.TimeApplied = source.m.TimeApplied;
			replacement.m.IsFresh = source.m.IsFresh;
			replacement.m.IsTreated = source.m.IsTreated;
			replacement.m.IsShownOutOfCombat = source.m.IsShownOutOfCombat;
			local existing = this.getContainer().getSkillByID(replacement.getID());
			if (existing != null)
			{
				existing.m.HealingTimeMin = this.Math.max(existing.m.HealingTimeMin, source.m.HealingTimeMin);
				existing.m.HealingTimeMax = this.Math.max(existing.m.HealingTimeMax, source.m.HealingTimeMax);
				existing.m.TimeApplied = this.Math.maxf(existing.m.TimeApplied, source.m.TimeApplied);
				existing.m.IsFresh = existing.m.IsFresh || source.m.IsFresh;
				existing.m.IsTreated = existing.m.IsTreated && source.m.IsTreated;
				this.getContainer().remove(source);
				::Brotherhood.logObsidianTest("TRUTHFUL PAIN", actor, "Merged " + sourceName + " (" + sourceID + ") into existing " + existing.getNameOnly() + "; fixed bonus remains " + bonusDescriptions[entry.Script] + ", healing " + existing.m.HealingTimeMin + "-" + existing.m.HealingTimeMax + " days.");
				continue;
			}
			this.getContainer().remove(source);
			this.getContainer().add(replacement);
			::Brotherhood.logObsidianTest("TRUTHFUL PAIN", actor, "Converted " + sourceName + " (" + sourceID + ") into " + replacement.getNameOnly() + " (" + replacement.getID() + "); bonus " + bonusDescriptions[entry.Script] + "; healing " + replacement.m.HealingTimeMin + "-" + replacement.m.HealingTimeMax + " days.");
		}
		this.m.Converting = false;
	}
	function onAdded() { this.convert(); }
	function onDamageReceived( _attacker, _hp, _armor ) { this.convert(); }
	function onCombatStarted() { this.convert(); }
});
