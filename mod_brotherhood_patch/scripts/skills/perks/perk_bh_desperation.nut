this.perk_bh_desperation <- this.inherit("scripts/skills/skill", {
	m = { CurrentBonus = 0, LastLoggedBonus = -1 },
	function create(){this.m.ID="perk.bh_desperation";this.m.Name="Desperation";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.executioner","ui/perks/perk_16.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;this.m.IsHidden=false;}
	function isHidden()
	{
		local actor=this.getContainer()==null?null:this.getContainer().getActor();
		return actor==null||!this.Tactical.isActive()||!actor.isPlacedOnMap();
	}
	function getAmmoForSkill(_skill)
	{
		local actor=this.getContainer().getActor();
		if(actor==null)return null;
		if(_skill!=null)
		{
			local bound=_skill.getItem();
			if(!::MSU.isNull(bound)&&::Brotherhood.isFleshcraftThrowingWeapon(bound))return bound;
			local slot=_skill.getID().find(".bh_volley_offhand")!=null?this.Const.ItemSlot.Offhand:this.Const.ItemSlot.Mainhand;
			local equipped=actor.getItems().getItemAtSlot(slot);
			if(!::MSU.isNull(equipped)&&::Brotherhood.isFleshcraftThrowingWeapon(equipped))return equipped;
		}
		local ammo=actor.getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		if(!::MSU.isNull(ammo)&&ammo.isItemType(this.Const.Items.ItemType.Ammo)&&ammo.getAmmoMax()>0)return ammo;
		local main=actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if(!::MSU.isNull(main)&&::Brotherhood.isFleshcraftThrowingWeapon(main))return main;
		local off=actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return !::MSU.isNull(off)&&::Brotherhood.isFleshcraftThrowingWeapon(off)?off:null;
	}
	function getMissingAmmo(_skill=null)
	{
		local ammo=this.getAmmoForSkill(_skill);
		return ammo==null ? 0 : ::Math.max(0,ammo.getAmmoMax()-ammo.getAmmo());
	}
	function getTooltip()
	{
		local missing=this.getMissingAmmo();
		return [
			{id=1,type="title",text=this.getName()},
			{id=2,type="description",text="Each missing piece of ammunition makes the rest stronger:"},
			{id=10,type="text",icon="ui/icons/damage_dealt.png",text="Current ranged damage bonus: "+::MSU.Text.colorPositive("+"+(missing*3)+"%")},
			{id=11,type="text",icon="ui/icons/ammo.png",text="Missing ammunition: "+::MSU.Text.colorPositive(missing)}
		];
	}
	function onUpdate(_properties)
	{
		this.m.CurrentBonus=this.getMissingAmmo()*3;
		if(this.m.CurrentBonus!=this.m.LastLoggedBonus)
		{
			this.m.LastLoggedBonus=this.m.CurrentBonus;
			::Brotherhood.logFleshcraftMechanic("DESPERATION",this.getContainer().getActor(),"Current ranged damage bonus is +"+this.m.CurrentBonus+"%.");
		}
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack() || !_skill.isRanged()) return;
		local actor = this.getContainer().getActor();
		local ammo = this.getAmmoForSkill(_skill);
		if (ammo == null)
		{
			::Brotherhood.logFleshcraftMechanic("DESPERATION", actor, "Rejected " + _skill.getName() + ": no live ammunition source was resolved.");
			return;
		}
		local missing = this.getMissingAmmo(_skill);
		this.m.CurrentBonus = missing * 3;
		if (missing == 0)
		{
			::Brotherhood.logFleshcraftMechanic("DESPERATION", actor, "Attack " + _skill.getName() + " is bound to " + ammo.getName() + " with no missing ammunition.");
			return;
		}
		_properties.DamageTotalMult *= 1.0 + 0.03 * missing;
		::Brotherhood.logFleshcraftMechanic("DESPERATION", actor, "Applied +" + (missing * 3) + "% ranged damage to " + _skill.getName() + " for " + missing + " missing ammunition.");
	}
});
