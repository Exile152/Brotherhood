this.perk_bh_finders_keepers <- this.inherit("scripts/skills/skill", {
	m={},function create(){this.m.ID="perk.bh_finders_keepers";this.m.Name="Finders Keepers";this.m.Description=::Brotherhood.getNewArchetypeTooltip(this.m.ID);this.m.Icon="ui/perks/bh_finders_keepers.png";this.m.IconDisabled="ui/perks/bh_finders_keepers_sw.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function getItemActionCost(_items)
	{
		local foundGround=false;local rememberedGroundItem=false;local shield=false;
		foreach(item in _items)if(item!=null)
		{
			if(item.isItemType(this.Const.Items.ItemType.Shield))shield=true;
			if(item.getContainer()==null)
			{
				foundGround=true;
				if("BH_FindersKeepersGroundItem" in item.m)item.m.BH_FindersKeepersGroundItem=true;else item.m.BH_FindersKeepersGroundItem<-true;
			}
			if("BH_FindersKeepersGroundItem" in item.m&&item.m.BH_FindersKeepersGroundItem)rememberedGroundItem=true;
		}
		if(!foundGround&&!rememberedGroundItem)return null;
		local cost=shield?1:(foundGround&&_items.len()<=1?1:0);
		::Brotherhood.logArchetypeTest("FINDERS KEEPERS",this.getContainer().getActor(),"Remembered-ground item action cost set to "+cost+" AP; currentlyGround="+foundGround+", shield="+shield+".");return cost;
	}
	function onPayForItemAction(_skill,_items)
	{
		local arsenal=this.getContainer().getSkillByID("perk.bh_dead_mans_arsenal");if(arsenal==null)return;
		foreach(item in _items)if(item!=null&&"BH_DroppedByEnemy" in item.m&&item.m.BH_DroppedByEnemy)arsenal.markWeapon(item);
	}
	function onCombatFinished(){foreach(item in this.getContainer().getActor().getItems().getAllItems())if(item!=null&&"BH_FindersKeepersGroundItem" in item.m)item.m.BH_FindersKeepersGroundItem=false;this.skill.onCombatFinished();}
});
