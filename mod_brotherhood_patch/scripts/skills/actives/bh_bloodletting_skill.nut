this.bh_bloodletting_skill <- this.inherit("scripts/skills/skill", {
	m={HealedTargets={}},
	function create(){this.m.ID="actives.bh_bloodletting";this.m.Name="Bloodletting";this.m.Description="Transfer the most recent temporary injury from an adjacent ally to yourself.";this.m.Icon="skills/active_55.png";this.m.IconDisabled="skills/active_55_sw.png";this.m.Overlay="active_55";this.m.Type=this.Const.SkillType.Active;this.m.Order=this.Const.SkillOrder.Any-1;this.m.IsSerialized=false;this.m.IsActive=true;this.m.IsTargeted=true;this.m.IsAttack=false;this.m.ActionPointCost=4;this.m.FatigueCost=20;this.m.MinRange=1;this.m.MaxRange=1;}
	function getInjuryRecord(_target)
	{
		local injuries=_target.getSkills().getAllSkillsOfType(this.Const.SkillType.TemporaryInjury);for(local i=injuries.len()-1;i>=0;--i){local injury=injuries[i];if(this.getContainer().hasSkill(injury.getID()))continue;foreach(def in this.Const.Injury.All)if(def.ID==injury.getID())return {Injury=injury,Definition=def};}return null;
	}
	function getTooltip(){local ret=this.getDefaultUtilityTooltip();ret.push({id=10,type="text",icon="ui/icons/health.png",text="The first use on each ally per battle heals "+::MSU.Text.colorPositive("30%")+" of their maximum Hitpoints"});return ret;}
	function onVerifyTarget(_origin,_targetTile){if(!this.skill.onVerifyTarget(_origin,_targetTile)||!_targetTile.IsOccupiedByActor)return false;local user=this.getContainer().getActor();local target=_targetTile.getEntity();return target!=null&&target.getID()!=user.getID()&&target.isAlliedWith(user)&&this.getInjuryRecord(target)!=null;}
	function onUse(_user,_targetTile)
	{
		local target=_targetTile.getEntity();local record=this.getInjuryRecord(target);if(record==null)return false;local transferred=this.new("scripts/skills/"+record.Definition.Script);
		if("HealingTimeMin" in record.Injury.m){transferred.m.HealingTimeMin=record.Injury.m.HealingTimeMin;transferred.m.HealingTimeMax=record.Injury.m.HealingTimeMax;transferred.m.TimeApplied=record.Injury.m.TimeApplied;}
		target.getSkills().remove(record.Injury);_user.getSkills().add(transferred);local key=target.getID().tostring();local healed=0;if(!(key in this.m.HealedTargets)){this.m.HealedTargets[key]<-true;local before=target.getHitpoints();target.setHitpoints(::Math.min(target.getHitpointsMax(),before+::Math.floor(target.getHitpointsMax()*0.30)));healed=target.getHitpoints()-before;}
		target.setDirty(true);_user.setDirty(true);::Brotherhood.logLatestObsidianTest("BLOODLETTING",_user,"Transferred "+record.Injury.getNameOnly()+" from "+target.getName()+" and healed "+healed+" HP.");return true;
	}
	function onCombatStarted(){this.m.HealedTargets={};}function onCombatFinished(){this.m.HealedTargets={};this.skill.onCombatFinished();}
});
