this.perk_bh_fast_adaptation <- this.inherit("scripts/skills/skill", {
	m={Stacks=0,Frame=0,SkillCount=0},
	function create(){this.m.ID="perk.bh_fast_adaptation";this.m.Name="Fast Adaptation";this.m.Description=::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.fast_adaption","ui/perks/perk_33.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;this.m.IsHidden=true;}
	function getDescription(){return "Gain "+::MSU.Text.colorPositive("+"+(this.m.Stacks*10)+"%")+" chance to hit with the next attack.";}
	function onUpdate(_properties){this.m.IsHidden=this.m.Stacks==0;}
	function onAnySkillUsed(_skill,_target,_properties){if(this.m.Stacks>0&&_skill!=null&&_skill.isAttack()){_properties.MeleeSkill+=10*this.m.Stacks;_properties.RangedSkill+=10*this.m.Stacks;}}
	function onGetHitFactors(_skill,_targetTile,_tooltip){if(this.m.Stacks>0&&_skill!=null&&_skill.isAttack())_tooltip.push({icon="ui/tooltips/positive.png",text=::MSU.Text.colorPositive("+"+(this.m.Stacks*10)+"% ")+this.getName()});}
	function onTargetHit(_skill,_target,_bodyPart,_damageHP,_damageArmor){if(_target==null)return;local old=this.m.Stacks;this.m.Stacks=0;this.m.Frame=0;this.m.SkillCount=0;this.m.IsHidden=true;if(old>0){this.getContainer().getActor().setDirty(true);::Brotherhood.logArchetypeTest("FAST ADAPTATION",this.getContainer().getActor(),"Hit "+_target.getName()+" and reset "+old+" stacks.");}}
	function onTargetMissed(_skill,_target){if(this.Time.getFrame()==this.m.Frame||this.m.SkillCount==this.Const.SkillCounter)return;++this.m.Stacks;this.m.Frame=this.Time.getFrame();this.m.SkillCount=this.Const.SkillCounter;this.m.IsHidden=false;this.getContainer().getActor().setDirty(true);::Brotherhood.logArchetypeTest("FAST ADAPTATION",this.getContainer().getActor(),"Missed and gained stack "+this.m.Stacks+".");}
	function reset(){this.m.Stacks=0;this.m.Frame=0;this.m.SkillCount=0;this.m.IsHidden=true;}
	function onCombatStarted(){this.reset();}function onCombatFinished(){this.reset();this.skill.onCombatFinished();}
});
