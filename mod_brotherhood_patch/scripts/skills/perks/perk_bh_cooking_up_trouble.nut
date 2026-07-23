this.perk_bh_cooking_up_trouble <- this.inherit("scripts/skills/skill", {
	m = { Records = {} },
	function create(){this.m.ID="perk.bh_cooking_up_trouble";this.m.Name="Cooking Up Trouble";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applyCustomPerkIcon(this);this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function getKey(_item){return _item.getInstanceID().tostring();}
	function isHidden(){return this.m.Records.len()==0;}
	function isRecordInBag(_record){return ("Item" in _record)&&!::MSU.isNull(_record.Item)&&_record.Item.getCurrentSlotType()==this.Const.ItemSlot.Bag;}
	function getTooltip()
	{
		local ret=[
			{id=1,type="title",text=this.getName()},
			{id=2,type="description",text="Weapons currently cooking or retaining their cooked damage bonus:"}
		];
		local id=10;
		foreach(k,r in this.m.Records)
		{
			local state=this.isRecordInBag(r)?"Cooking in bag":(r.Grace<=0?"Expires after this turn":r.Grace+" turn"+(r.Grace==1?"":"s")+" remaining");
			ret.push({id=id++,type="text",icon="ui/icons/damage_dealt.png",text=r.Name+": "+::MSU.Text.colorPositive("+"+r.Bonus+"% damage")+" ("+state+")"});
		}
		return ret;
	}
	function refreshDisplay(){this.getContainer().update();local actor=this.getContainer().getActor();if(actor!=null)actor.setDirty(true);}
	function onTurnStart()
	{
		local actor=this.getContainer().getActor();local items=actor.getItems();local inBag={};
		foreach(item in items.getAllItemsAtSlot(this.Const.ItemSlot.Bag))
		{
			if(item==null||!item.isItemType(this.Const.Items.ItemType.Weapon))continue;
			local k=this.getKey(item);inBag[k]<-true;
			if(!(k in this.m.Records))this.m.Records[k]<-{Item=item,Name=item.getName(),Bonus=0,Grace=2,InBag=true};
			local r=this.m.Records[k];if("Item" in r)r.Item=item;else r.Item<-item;r.Name=item.getName();r.Bonus=::Math.min(25,r.Bonus+5);r.Grace=2;r.InBag=true;
			::Brotherhood.logFleshcraftMechanic("COOKING UP TROUBLE",actor,r.Name+" is cooking at +"+r.Bonus+"% damage.");
		}
		local expired=[];
		foreach(k,r in this.m.Records)if(!(k in inBag)){r.InBag=false;--r.Grace;if(r.Grace<0)expired.push(k);}
		foreach(k in expired)delete this.m.Records[k];
		this.refreshDisplay();
	}
	function onAnySkillUsed(_s,_t,_p){local w=_s==null?null:_s.getItem();if(w==null)return;local k=this.getKey(w);if(k in this.m.Records){local r=this.m.Records[k];if("Item" in r)r.Item=w;else r.Item<-w;r.InBag=false;_p.DamageTotalMult*=1.0+r.Bonus*0.01;::Brotherhood.logFleshcraftMechanic("COOKING UP TROUBLE",this.getContainer().getActor(),"Applied +"+r.Bonus+"% damage from "+r.Name+".");}}
	function onCombatFinished(){this.m.Records.clear();this.skill.onCombatFinished();}
});
