this.perk_bh_despair <- this.inherit("scripts/skills/skill", {
	m={Stacks=0},
	function create(){this.m.ID="perk.bh_despair";this.m.Name="Despair";this.m.Description=::Brotherhood.getLatestObsidianTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.fearsome","ui/perks/perk_27.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;this.m.IsHidden=true;}
	function onUpdate(_p){this.m.IsHidden=this.m.Stacks==0;_p.MeleeSkill+=this.m.Stacks*2;_p.Bravery+=this.m.Stacks*2;}
	function onAnySkillUsed(_s,_t,_p){if(_s!=null&&_s.isAttack()&&_t!=null&&_t.getMoraleState()==this.Const.MoraleState.Fleeing){_p.DamageTotalMult*=1.5;::Brotherhood.logLatestObsidianTest("DESPAIR",this.getContainer().getActor(),"Applied +50% damage against fleeing "+_t.getName()+".");}}
	function onTargetKilled(_t,_s){if(_t==null||_t.getMoraleState()!=this.Const.MoraleState.Fleeing)return;++this.m.Stacks;this.m.IsHidden=false;this.getContainer().update();this.getContainer().getActor().setDirty(true);::Brotherhood.logLatestObsidianTest("DESPAIR",this.getContainer().getActor(),"Killed fleeing "+_t.getName()+"; stacks="+this.m.Stacks+" (+"+(this.m.Stacks*2)+" Melee Skill and Resolve).");}
	function onCombatStarted(){this.m.Stacks=0;this.m.IsHidden=true;}function onCombatFinished(){this.m.Stacks=0;this.m.IsHidden=true;this.skill.onCombatFinished();}
});
