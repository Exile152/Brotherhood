this.perk_bh_dead_mans_arsenal <- this.inherit("scripts/skills/skill", {
	m={},function create(){this.m.ID="perk.bh_dead_mans_arsenal";this.m.Name="Dead Man's Arsenal";this.m.Description=::Brotherhood.getNewArchetypeTooltip(this.m.ID);this.m.Icon="ui/perks/perk_rf_fruits_of_labor.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onAdded(){if(!this.getContainer().hasSkill("effects.bh_dead_mans_arsenal"))this.getContainer().add(this.new("scripts/skills/effects/bh_dead_mans_arsenal_effect"));}
	function onRemoved(){this.getContainer().removeByID("effects.bh_dead_mans_arsenal");}
	function markWeapon(_item){if(!_item.isItemType(this.Const.Items.ItemType.Weapon))return;_item.m.BH_DeadMansArsenalActive<-true;::Brotherhood.logArchetypeTest("DEAD MANS ARSENAL",this.getContainer().getActor(),"Marked picked-up enemy weapon "+_item.getName()+" for +25% damage this combat.");}
});
