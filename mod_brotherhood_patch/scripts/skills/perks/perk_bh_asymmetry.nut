this.perk_bh_asymmetry <- this.inherit("scripts/skills/skill", {
	m = { Stacks = 0 },
	function create(){this.m.ID="perk.bh_asymmetry";this.m.Name="Asymmetry";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applyCustomPerkIcon(this);this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isHidden(){return this.m.Stacks==0;}
	function getTooltip(){local r=this.skill.getTooltip();r.push({id=10,type="text",icon="ui/icons/action_points.png",text="Ranged-hit stacks: "+this.m.Stacks+" / 3"});return r;}
	function onAfterUpdate(_p){if(this.m.Stacks==0)return;foreach(s in this.getContainer().getAllSkillsOfType(this.Const.SkillType.Active))if(s.isAttack()&&!s.isRanged()&&s.m.ActionPointCost>1)s.m.ActionPointCost-=1;}
	function onTargetHit(_s,_t,_part,_hp,_armor){if(_s!=null&&_s.isAttack()&&_s.isRanged()){this.m.Stacks=::Math.min(3,this.m.Stacks+1);this.getContainer().update();}}
	function onAnySkillExecutedFully(_s,_tile,_target,_free){if(this.m.Stacks>0&&_s!=null&&_s.isAttack()&&!_s.isRanged()){local actor=this.getContainer().getActor();if(actor.isPlacedOnMap())this.spawnIcon("bh_asymmetry",actor.getTile());--this.m.Stacks;::Brotherhood.logFleshcraftMechanic("ASYMMETRY",actor,"Consumed one ranged-hit stack; "+this.m.Stacks+" remain.");this.getContainer().update();}}
	function onCombatFinished(){this.m.Stacks=0;this.skill.onCombatFinished();}
});
