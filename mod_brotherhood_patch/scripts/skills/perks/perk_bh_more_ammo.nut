this.perk_bh_more_ammo <- this.inherit("scripts/skills/skill", {
	m={AmmoItem=null,OriginalMax=0,BonusApplied=false},
	function create(){this.m.ID="perk.bh_more_ammo";this.m.Name="More Ammo!";this.m.Description=::Brotherhood.getArtilleristTooltip(this.m.ID);this.m.Icon="ui/perks/bh_more_ammo.png";this.m.IconDisabled="ui/perks/bh_more_ammo_sw.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function applyAmmoBonus()
	{
		if(this.m.BonusApplied || this.getContainer()==null) return;
		local item=this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		if(item==null || !item.isItemType(this.Const.Items.ItemType.Ammo)) return;
		this.m.AmmoItem=item;
		this.m.OriginalMax=item.m.AmmoMax;
		item.m.AmmoMax+=2;
		item.setAmmo(item.getAmmo()+2);
		this.m.BonusApplied=true;
		this.getContainer().getActor().setDirty(true);
		::Brotherhood.logArchetypeTest("MORE AMMO",this.getContainer().getActor(),"Granted +2 temporary maximum ammunition to "+item.getName()+" ("+item.getAmmo()+"/"+item.getAmmoMax()+").");
	}
	function onCombatStarted(){this.skill.onCombatStarted();this.m.BonusApplied=false;this.applyAmmoBonus();}
	function onTurnStart(){this.applyAmmoBonus();}
	function onUpdate(_properties)
	{
		if(this.Tactical.isActive())this.applyAmmoBonus();
	}
	function onCombatFinished()
	{
		if(this.m.AmmoItem!=null)
		{
			this.m.AmmoItem.m.AmmoMax=this.m.OriginalMax;
			this.m.AmmoItem.setAmmo(::Math.min(this.m.AmmoItem.getAmmo(),this.m.OriginalMax));
		}
		this.m.AmmoItem=null;
		this.m.OriginalMax=0;
		this.m.BonusApplied=false;
		this.skill.onCombatFinished();
	}
});
