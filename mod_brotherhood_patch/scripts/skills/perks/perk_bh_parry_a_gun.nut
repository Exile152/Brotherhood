this.perk_bh_parry_a_gun <- this.inherit("scripts/skills/skill", {
	m={FreeHandgonneSwap=false,IsCloseRangeHandgonne=false},
	function create(){this.m.ID="perk.bh_parry_a_gun";this.m.Name="Parry a Gun!";this.m.Description=::Brotherhood.getArtilleristTooltip(this.m.ID);this.m.Icon="ui/perks/perk_39.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onTurnStart(){this.m.FreeHandgonneSwap=false;}
	function onTargetHit(_skill,_target,_bodyPart,_damageHitpoints,_damageArmor){if(_skill!=null&&_skill.isAttack()&&!_skill.isRanged())this.armFreeHandgonneSwap();}
	function onTargetMissed(_skill,_target){if(_skill!=null&&_skill.isAttack()&&!_skill.isRanged())this.armFreeHandgonneSwap();}
	function armFreeHandgonneSwap(){this.m.FreeHandgonneSwap=true;::Brotherhood.logArchetypeTest("PARRY A GUN",this.getContainer().getActor(),"Completed a melee attack; the next Handgonne switch this turn costs 0 AP.");}
	function findHandgonne(_items){foreach(item in _items)if(::Brotherhood.isHandgonne(item))return item;return null;}
	function findBagHandgonne(){local items=this.getContainer().getActor().getItems();for(local i=0;i<items.getUnlockedBagSlots();++i){local item=items.getItemAtBagSlot(i);if(::Brotherhood.isHandgonne(item))return item;}return null;}
	function itemsContainHandgonne(_items){return this.findHandgonne(_items)!=null;}
	function findOneHandedMelee(_items){foreach(item in _items)if(item!=null&&("isItemType" in item)&&item.isItemType(this.Const.Items.ItemType.Weapon)&&!item.isItemType(this.Const.Items.ItemType.RangedWeapon)&&item.getBlockedSlotType()==null)return item;return null;}
	function reloadHandgonne( _handgonne )
	{
		if(_handgonne==null || _handgonne.isLoaded()) return true;
		local ammo=this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		if(ammo==null || ammo.getAmmoType()!=this.Const.Items.AmmoType.Powder || ammo.getAmmo()<=0) return false;
		ammo.consumeAmmo();
		_handgonne.setLoaded(true);
		this.getContainer().removeByID("actives.reload_handgonne");
		return true;
	}
	function onFreeHandgonneEquipped(){this.m.FreeHandgonneSwap=false;this.m.IsCloseRangeHandgonne=true;local weapon=this.getContainer().getActor().getMainhandItem();local reloaded=this.reloadHandgonne(weapon);::Brotherhood.logArchetypeTest("PARRY A GUN",this.getContainer().getActor(),"Switched to a Handgonne for 0 AP; minimum firing range is now 1 tile"+(reloaded?" and the Handgonne is loaded.":", but no powder was available to reload it."));this.getContainer().update();}
	function onMeleeEquipped( _handgonne )
	{
		this.m.IsCloseRangeHandgonne=false;
		if(_handgonne!=null && !_handgonne.isLoaded())
		{
			if(this.reloadHandgonne(_handgonne))
			{
				::Brotherhood.logArchetypeTest("PARRY A GUN",this.getContainer().getActor(),"Switched back to a one-handed melee weapon and automatically reloaded the Handgonne.");
			}
		}
		this.getContainer().update();
	}
});
