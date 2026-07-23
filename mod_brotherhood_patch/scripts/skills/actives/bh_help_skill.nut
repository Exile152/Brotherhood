this.bh_help_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.bh_help";
		this.m.Name = "Help";
		this.m.Description = "Give the first item in your bag to an adjacent ally.";
		this.m.Icon = "skills/active_38.png";
		this.m.IconDisabled = "skills/active_38_sw.png";
		this.m.Overlay = "active_38";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any - 1;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({ id = 10, type = "text", icon = "ui/icons/bag.png", text = "Gives the first item in your bag to the targeted adjacent ally" });
		ret.push({ id = 11, type = "text", icon = "ui/icons/special.png", text = "The item goes into an empty bag slot, or into an empty main hand if it is a weapon" });
		return ret;
	}
	function getFirst(){local items=this.getContainer().getActor().getItems();for(local i=0;i<items.getUnlockedBagSlots();++i){local item=items.getItemAtBagSlot(i);if(item!=null)return item;}return null;}
	function canReceive(_target,_item){local items=_target.getItems();for(local i=0;i<items.getUnlockedBagSlots();++i)if(items.getItemAtBagSlot(i)==null)return true;return _item.isItemType(this.Const.Items.ItemType.Weapon)&&items.getItemAtSlot(this.Const.ItemSlot.Mainhand)==null;}
	function isUsable(){return this.getFirst()!=null&&this.skill.isUsable();}
	function onVerifyTarget(_origin,_targetTile){if(!_targetTile.IsOccupiedByActor||_origin.getDistanceTo(_targetTile)!=1)return false;local target=_targetTile.getEntity();local item=this.getFirst();return item!=null&&target.isAlliedWith(this.getContainer().getActor())&&this.canReceive(target,item);}
	function onUse(_user,_targetTile)
	{
		local item=this.getFirst();local target=_targetTile.getEntity();
		if(item==null){::Brotherhood.logObsidianTest("HELP",_user,"Rejected: bag is empty.");return false;}
		_user.getItems().removeFromBag(item);local targetItems=target.getItems();local destination="bag";
		if(!targetItems.addToBag(item))
		{
			destination="main hand";
			if(!targetItems.equip(item)){_user.getItems().addToBag(item);::Brotherhood.logObsidianTest("HELP",_user,"Failed to give "+item.getName()+" to "+target.getName()+"; item returned to source bag.");return false;}
		}
		::Brotherhood.trackHelpEquipmentTransfer(_user, target, item, destination == "bag" ? this.Const.ItemSlot.Bag : this.Const.ItemSlot.Mainhand);
		::Brotherhood.logObsidianTest("HELP",_user,"Gave "+item.getName()+" to "+target.getName()+"'s "+destination+".");
		return true;
	}
});
