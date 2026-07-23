this.bh_disabled_off_hand_effect <- this.inherit("scripts/skills/skill", {
	m = { ActiveNow = false, PendingNextTurn = true },
	function create()
	{
		this.m.ID = "effects.bh_disabled_off_hand";
		this.m.Name = "Disabled Off Hand";
		this.m.Description = "This unit cannot use or benefit from its off hand during its next turn.";
		this.m.Icon = "skills/status_effect_61.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function isActiveNow() { return this.m.ActiveNow; }
	function refreshForNextTurn()
	{
		this.m.PendingNextTurn = true;
		this.getContainer().getActor().setDirty(true);
	}
	function onUpdate( _properties )
	{
		if (!this.m.ActiveNow) return;
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (off != null && off.isItemType(this.Const.Items.ItemType.Shield))
		{
			_properties.MeleeDefense -= off.getMeleeDefense();
			_properties.RangedDefense -= off.getRangedDefense();
		}
		_properties.IsSpecializedInShields = false;
	}
	function onTurnStart()
	{
		if (!this.m.PendingNextTurn) return;
		this.m.ActiveNow = true;
		this.m.PendingNextTurn = false;
		this.getContainer().getActor().setDirty(true);
	}
	function onTurnEnd()
	{
		if (!this.m.ActiveNow) return;
		this.m.ActiveNow = false;
		if (!this.m.PendingNextTurn) this.removeSelf();
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeBool(this.m.ActiveNow); _out.writeBool(this.m.PendingNextTurn); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.ActiveNow = _in.readBool(); this.m.PendingNextTurn = _in.readBool(); }
});
