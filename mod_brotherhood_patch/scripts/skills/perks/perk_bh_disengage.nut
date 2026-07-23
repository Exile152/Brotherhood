this.perk_bh_disengage <- this.inherit("scripts/skills/skill", {
	m={CanDisengage=false,DefenseActive=false,ForceMiss=false},
	function create(){this.m.ID="perk.bh_disengage";this.m.Name="Disengage";this.m.Description=::Brotherhood.getNewArchetypeTooltip(this.m.ID);this.m.Icon="ui/perks/bh_disengage.png";this.m.IconDisabled="ui/perks/bh_disengage_sw.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isValidWeapon(_skill){local item=_skill==null?null:_skill.getItem();return item!=null&&item.isItemType(this.Const.Items.ItemType.MeleeWeapon)&&!item.isItemType(this.Const.Items.ItemType.TwoHanded);}
	function onUpdate(_p){if(this.m.CanDisengage)_p.IsImmuneToZoneOfControl=true;if(this.m.DefenseActive)_p.MeleeDefense+=15;}
	function onTargetMissed(_skill,_target)
	{
		if(this.m.ForceMiss){this.m.ForceMiss=false;return;}
		if(this.isValidWeapon(_skill)){this.m.CanDisengage=true;this.getContainer().update();::Brotherhood.logArchetypeTest("DISENGAGE",this.getContainer().getActor(),"One-handed attack missed; Zone-of-Control immunity enabled until movement or turn end.");}
	}
	function onTargetHit(_skill,_target,_part,_hp,_armor){if(this.isValidWeapon(_skill)){this.m.DefenseActive=true;this.m.ForceMiss=true;this.getContainer().update();::Brotherhood.logArchetypeTest("DISENGAGE",this.getContainer().getActor(),"One-handed attack hit; applied +15 Melee Defense and armed forced miss.");}}
	function onMovementFinished(){this.m.CanDisengage=false;this.getContainer().update();}
	function onTurnStart(){this.m.CanDisengage=false;this.m.DefenseActive=false;this.m.ForceMiss=false;this.getContainer().update();}
	function onTurnEnd(){this.m.CanDisengage=false;this.m.DefenseActive=false;this.m.ForceMiss=false;this.getContainer().update();}
	function onCombatFinished(){this.m.CanDisengage=false;this.m.DefenseActive=false;this.m.ForceMiss=false;this.skill.onCombatFinished();}
});
