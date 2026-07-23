this.perk_bh_bloodloaded <- this.inherit("scripts/skills/skill", {
	m = { PreviousWeapon = null },
	function create(){this.m.ID="perk.bh_bloodloaded";this.m.Name="Bloodloaded";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.quick_hands","ui/perks/perk_39.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function remember(_weapon){if(_weapon!=null&&_weapon.isItemType(this.Const.Items.ItemType.Weapon))this.m.PreviousWeapon=_weapon;}
	function onTargetKilled(_target,_skill)
	{
		local actor=this.getContainer().getActor();
		if(_target==null||!actor.isPlacedOnMap()||!_target.isPlacedOnMap()||actor.getTile().getDistanceTo(_target.getTile())!=1)return;
		local w=this.m.PreviousWeapon;
		if(::MSU.isNull(w))return;
		if("isLoaded" in w&&"setLoaded" in w&&!w.isLoaded())
		{
			local ammo=actor.getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
			if(ammo==null||ammo.getAmmo()<=0)return;
			ammo.setAmmo(ammo.getAmmo()-1);
			w.setLoaded(true);
		}
		else if("getAmmo" in w&&w.getAmmoMax()>0&&w.getAmmo()<w.getAmmoMax())w.setAmmo(w.getAmmo()+1);
		else return;
		actor.setDirty(true);
		::Brotherhood.logFleshcraftMechanic("BLOODLOADED",actor,"Reloaded "+w.getName()+" after an adjacent kill.");
	}
	function onCombatFinished(){this.m.PreviousWeapon=null;this.skill.onCombatFinished();}
});
