this.perk_bh_quick_hands <- this.inherit("scripts/skills/skill", {
	m={IsSpent=false},
	function create(){this.m.ID="perk.bh_quick_hands";this.m.Name="Quick Hands";this.m.Description=::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.quick_hands","ui/perks/perk_39.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk|this.Const.SkillOrder.Any;this.m.IsActive=false;this.m.IsHidden=false;}
	function canUseFor(_items){if(this.m.IsSpent)return false;local twoHanded=0;foreach(item in _items){if(item==null)continue;if(item.isItemType(this.Const.Items.ItemType.Shield))return false;if(item.isItemType(this.Const.Items.ItemType.Weapon)&&item.getBlockedSlotType()==this.Const.ItemSlot.Offhand)++twoHanded;}return twoHanded<2;}
	function spend(_items){this.m.IsSpent=true;this.m.IsHidden=true;this.getContainer().getActor().setDirty(true);::Brotherhood.logArchetypeTest("QUICK HANDS",this.getContainer().getActor(),"Consumed the once-per-turn free item swap.");}
	function onUpdate(_properties){local actor=this.getContainer().getActor();this.m.IsHidden=!actor.isPlayerControlled()||!actor.isPlacedOnMap()||this.m.IsSpent;}
	function onTurnStart(){this.m.IsSpent=false;this.m.IsHidden=false;}
	function onCombatStarted(){this.m.IsSpent=false;this.m.IsHidden=!this.getContainer().getActor().isPlayerControlled();}
	function onCombatFinished(){this.m.IsSpent=false;this.m.IsHidden=true;this.skill.onCombatFinished();}
});
