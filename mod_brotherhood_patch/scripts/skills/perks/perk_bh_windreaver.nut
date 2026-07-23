this.perk_bh_windreaver <- this.inherit("scripts/skills/skill", {
	m = { Targets = [] },
	function create(){this.m.ID="perk.bh_windreaver";this.m.Name="Windreaver";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.berserk","ui/perks/perk_35.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isHidden(){return this.m.Targets.len()==0;}
	function onAfterUpdate(_p){local n=this.m.Targets.len();if(n==0)return;foreach(s in this.getContainer().getAllSkillsOfType(this.Const.SkillType.Active))if(s.isAttack()&&s.isRanged()&&s.m.ActionPointCost>2)s.m.ActionPointCost=::Math.max(2,s.m.ActionPointCost-n);}
	function onAnySkillExecutedFully(_s,_tile,_target,_free){if(_s==null||!_s.isAttack()||!_s.isRanged()||_target==null)return;local id=_target.getID();if(this.m.Targets.find(id)==null)this.m.Targets.push(id);this.getContainer().update();}
	function reset(){this.m.Targets.clear();}
	function onTurnStart(){this.reset();this.getContainer().update();}
	function onTurnEnd(){this.reset();this.getContainer().update();}
	function onCombatFinished(){this.reset();this.skill.onCombatFinished();}
});
