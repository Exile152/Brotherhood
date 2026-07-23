this.perk_bh_scholarship <- this.inherit("scripts/skills/skill", {
	m={},
	function create(){this.m.ID="perk.bh_scholarship";this.m.Name="Scholarship";this.m.Description=::Brotherhood.getLatestObsidianTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.student","ui/perks/perk_21.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onAdded()
	{
		local actor=this.getContainer().getActor();local flags=actor.getFlags();
		if(!actor.getSkills().hasSkill("trait.bright")){actor.getSkills().add(this.new("scripts/skills/traits/bright_trait"));::Brotherhood.logLatestObsidianTest("SCHOLARSHIP",actor,"Granted the Bright trait.");}
		if(flags.has("BH_ScholarshipTalentGranted"))return;
		local choices=[];for(local i=0;i<this.Const.Attributes.COUNT;++i)if(actor.m.Talents[i]<3)choices.push(i);
		if(choices.len()==0){::Brotherhood.logLatestObsidianTest("SCHOLARSHIP",actor,"Every attribute already has three talent stars; no star granted.");return;}
		local index=choices[this.Math.rand(0,choices.len()-1)];actor.m.Talents[index]+=1;flags.set("BH_ScholarshipTalentGranted",index);actor.setDirty(true);::Brotherhood.logLatestObsidianTest("SCHOLARSHIP",actor,"Granted one talent star to attribute index "+index+"; new value="+actor.m.Talents[index]+".");
	}
});
