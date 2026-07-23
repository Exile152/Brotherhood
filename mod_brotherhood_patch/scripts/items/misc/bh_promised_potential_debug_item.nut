this.bh_promised_potential_debug_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.bh_promised_potential_debug";
		this.m.Name = "[DEBUG] Elixir of Certain Potential";
		this.m.Description = "A testing consumable that sets Promised Potential's current success chance to 80%.";
		this.m.Icon = "consumables/potion_01.png";
		this.m.Value = 0;
	}
	function getTooltip()
	{
		local ret=this.anatomist_potion_item.getTooltip();
		ret.push({id=60,type="text",icon="ui/icons/special.png",text="Sets Promised Potential's stored chance to 80%."});
		ret.push({id=61,type="hint",icon="ui/tooltips/warning.png",text="Debug item. Has no effect if the selected character does not have Promised Potential."});
		return ret;
	}
	function onUse( _actor, _item = null )
	{
		local perk=_actor.getSkills().getSkillByID("perk.bh_promised_potential");
		if(perk==null){::logInfo("[BH PROMISED POTENTIAL DEBUG] "+_actor.getName()+": consumable rejected; perk not found.");return false;}
		perk.setSuccessChance(80);
		::logInfo("[BH PROMISED POTENTIAL DEBUG] "+_actor.getName()+": chance set to 80%.");
		return this.anatomist_potion_item.onUse(_actor,_item);
	}
});
