this.bh_dead_mans_arsenal_effect <- this.inherit("scripts/skills/skill", {
	m={},
	function create(){this.m.ID="effects.bh_dead_mans_arsenal";this.m.Name="Dead Man's Arsenal";this.m.Description="The equipped enemy weapon was recovered from the battlefield.";this.m.Icon="ui/perks/perk_rf_fruits_of_labor.png";this.m.Type=this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Any;this.m.IsActive=false;this.m.IsRemovedAfterBattle=false;}
	function getActiveWeapon(){local a=this.getContainer().getActor();local w=a.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);return w!=null&&"BH_DeadMansArsenalActive" in w.m&&w.m.BH_DeadMansArsenalActive?w:null;}
	function isHidden(){return this.getActiveWeapon()==null;}
	function getTooltip(){local ret=this.skill.getTooltip();local w=this.getActiveWeapon();if(w!=null)ret.push({id=10,type="text",icon="ui/icons/regular_damage.png",text=::MSU.Text.colorPositive("25%")+" more damage with "+w.getName()});return ret;}
	function onAnySkillUsed(_skill,_target,_properties){local w=this.getActiveWeapon();if(w!=null&&_skill!=null&&_skill.isAttack()&&_skill.getItem()==w){_properties.DamageTotalMult*=1.25;::Brotherhood.logArchetypeTest("DEAD MANS ARSENAL",this.getContainer().getActor(),"Applied +25% damage to "+_skill.getID()+" with "+w.getName()+".");}}
	function onCombatFinished(){foreach(item in this.getContainer().getActor().getItems().getAllItems())if(item!=null&&"BH_DeadMansArsenalActive" in item.m)item.m.BH_DeadMansArsenalActive=false;this.skill.onCombatFinished();}
});
