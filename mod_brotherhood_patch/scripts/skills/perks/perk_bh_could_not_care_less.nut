this.perk_bh_could_not_care_less <- this.inherit("scripts/skills/skill", {
	m = { HitEnemyIDs = [] },
	function create(){this.m.ID="perk.bh_could_not_care_less";this.m.Name="Could Not Care Less";this.m.Description=::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.dodge","ui/perks/perk_10.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function hasHit(_actor){return _actor!=null&&this.m.HitEnemyIDs.find(_actor.getID())!=null;}
	function isEligible(_attacker){local actor=this.getContainer().getActor();return _attacker!=null&&!this.hasHit(_attacker)&&_attacker.getCurrentProperties().getMeleeSkill()<actor.getCurrentProperties().getMeleeSkill();}
	function onTargetHit(_skill,_target,_bodyPart,_damageHP,_damageArmor){if(_skill==null||!_skill.isAttack()||_target==null||this.hasHit(_target))return;this.m.HitEnemyIDs.push(_target.getID());::Brotherhood.logArchetypeTest("COULD NOT CARE LESS",this.getContainer().getActor(),"Hit "+_target.getName()+"; that enemy is no longer intimidated.");}
	function onBeingAttacked(_attacker,_skill,_properties){if(_skill==null||!_skill.isAttack()||!this.isEligible(_attacker))return;_properties.MeleeDefense+=20;_properties.RangedDefense+=20;::Brotherhood.logArchetypeTest("COULD NOT CARE LESS",this.getContainer().getActor(),"Reduced "+_attacker.getName()+"'s hit chance by 20 because their current Melee Attack is lower and they have not been hit.");}
	function onGetHitFactorsAsTarget(_skill,_targetTile,_tooltip){local attacker=_skill==null||_skill.getContainer()==null?null:_skill.getContainer().getActor();if(this.isEligible(attacker))_tooltip.push({icon="ui/tooltips/negative.png",text=::MSU.Text.colorNegative("-20% ")+this.getName()});}
	function onCombatStarted(){this.m.HitEnemyIDs=[];}
	function onCombatFinished(){this.m.HitEnemyIDs=[];this.skill.onCombatFinished();}
	function onSerialize(_out){this.skill.onSerialize(_out);_out.writeU8(this.m.HitEnemyIDs.len());foreach(id in this.m.HitEnemyIDs)_out.writeU32(id);}
	function onDeserialize(_in){this.skill.onDeserialize(_in);this.m.HitEnemyIDs=[];local n=_in.readU8();for(local i=0;i<n;++i)this.m.HitEnemyIDs.push(_in.readU32());}
});
