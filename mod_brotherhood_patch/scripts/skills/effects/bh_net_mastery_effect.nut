this.bh_net_mastery_effect <- this.inherit("scripts/skills/skill", {
	m={OwnerID=0,IsReinforced=false,CanReturnPhysicalNet=false,Returned=false},
	function create(){this.m.ID="effects.bh_net_mastery";this.m.Name="Net Master's Net";this.m.Description="This net is twice as difficult to escape from.";this.m.Type=this.Const.SkillType.StatusEffect;this.m.IsActive=false;this.m.IsHidden=true;this.m.IsRemovedAfterBattle=true;}
	function setSource(_ownerID,_reinforced,_canReturn){this.m.OwnerID=_ownerID;this.m.IsReinforced=_reinforced;this.m.CanReturnPhysicalNet=_canReturn;}
	function onNetDestroyed( _reason = "it was destroyed" )
	{
		if (this.m.Returned) { this.removeSelf(); return; }
		this.m.Returned = true;
		if (!this.m.CanReturnPhysicalNet || this.m.OwnerID == 0 || !::Tactical.isActive()) { this.removeSelf(); return; }
		local owner = ::Tactical.getEntityByID(this.m.OwnerID);
		if (owner == null || !owner.isAlive()) { this.removeSelf(); return; }
		local script = "scripts/items/tools/throwing_net";
		if (this.m.IsReinforced) script = "scripts/items/tools/reinforced_throwing_net";
		local item = this.new(script);
		local items = owner.getItems();
		local returned = false;
		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null) returned = items.equip(item);
		if (!returned) returned = items.addToBag(item);
		if (!returned) item.drop(owner.getTile());
		owner.setDirty(true);
		local netName = this.m.IsReinforced ? "reinforced throwing net" : "throwing net";
		local message = "Recovered a " + netName + " after " + _reason + ".";
		if (!returned) message = "Recovered a " + netName + ", but no hand or bag slot was free, so it dropped at their feet.";
		::Brotherhood.logArchetypeTest("NET MASTERY", owner, message);
		this.removeSelf();
	}
	function onSerialize(_out){this.skill.onSerialize(_out);_out.writeU32(this.m.OwnerID);_out.writeBool(this.m.IsReinforced);_out.writeBool(this.m.CanReturnPhysicalNet);_out.writeBool(this.m.Returned);}
	function onDeserialize(_in){this.skill.onDeserialize(_in);this.m.OwnerID=_in.readU32();this.m.IsReinforced=_in.readBool();this.m.CanReturnPhysicalNet=_in.readBool();this.m.Returned=_in.readBool();}
});
