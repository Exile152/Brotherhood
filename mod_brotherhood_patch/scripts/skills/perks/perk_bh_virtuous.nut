this.perk_bh_virtuous <- this.inherit("scripts/skills/skill", {
	m={CandidateScripts=["athletic_trait","brave_trait","bright_trait","dexterous_trait","eagle_eyes_trait","iron_lungs_trait","quick_trait","strong_trait","sure_footing_trait","tough_trait"]},
	function create(){this.m.ID="perk.bh_virtuous";this.m.Name="Virtuous";this.m.Description=::Brotherhood.getLatestObsidianTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.gifted","ui/perks/perk_56.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onAdded()
	{
		local actor=this.getContainer().getActor();local flags=actor.getFlags();if(flags.has("BH_VirtuousGranted"))return;
		local existing=actor.getSkills().getAllSkillsOfType(this.Const.SkillType.Trait);local candidates=[];
		foreach(scriptName in this.m.CandidateScripts)
		{
			local trait=this.new("scripts/skills/traits/"+scriptName);local blocked=actor.getSkills().hasSkill(trait.getID());
			if(!blocked)foreach(oldTrait in existing){if(trait.isExcluded(oldTrait.getID())||("isExcluded" in oldTrait&&oldTrait.isExcluded(trait.getID()))){blocked=true;break;}}
			if(!blocked)candidates.push(trait);
		}
		if(candidates.len()==0){::Brotherhood.logLatestObsidianTest("VIRTUOUS",actor,"No compatible positive numerical trait was available.");return;}
		local chosen=candidates[this.Math.rand(0,candidates.len()-1)];flags.set("BH_VirtuousGranted",chosen.getID());actor.getSkills().add(chosen);actor.setDirty(true);::Brotherhood.logLatestObsidianTest("VIRTUOUS",actor,"Granted "+chosen.getName()+" ("+chosen.getID()+").");
	}
});
