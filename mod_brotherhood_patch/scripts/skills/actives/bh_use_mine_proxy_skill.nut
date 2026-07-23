this.bh_use_mine_proxy_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SourceActorID = 0,
		SourceItemID = null,
		SourceSkill = null
	},

	function create()
	{
		this.m.ID = "actives.bh_use_mine_proxy";
		this.m.Name = "Use Mine";
		this.m.Description = "Use a consumable carried by an adjacent Improviser.";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any - 1;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsAttack = false;
		this.m.IsUsingHitchance = false;
		this.m.IsSerialized = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 1;
	}

	function configure( _actorID, _itemID, _skill )
	{
		this.m.SourceActorID = _actorID;
		this.m.SourceItemID = _itemID;
		this.m.SourceSkill = _skill;
		this.m.ID = "actives.bh_use_mine_proxy." + _itemID + "." + _skill.getID();
		this.m.Name = _skill.getName() + " (Use Mine)";
		this.m.Description = "Use " + _skill.getName() + " from an adjacent ally's bag.";
		this.m.Icon = _skill.m.Icon;
		this.m.IconDisabled = _skill.m.IconDisabled;
		this.m.Overlay = _skill.m.Overlay;
		this.m.IsTargeted = _skill.m.IsTargeted;
		this.m.IsTargetingActor = _skill.m.IsTargetingActor;
		this.m.ActionPointCost = _skill.m.ActionPointCost;
		this.m.FatigueCost = _skill.m.FatigueCost;
		this.m.MinRange = _skill.m.MinRange;
		this.m.MaxRange = _skill.m.MaxRange;
	}

	function onAdded()
	{
		if (this.m.SourceSkill != null) this.m.SourceSkill.setContainer(this.getContainer());
	}

	function onRemoved()
	{
		if (this.m.SourceSkill != null) this.m.SourceSkill.setContainer(null);
	}

	function getSource()
	{
		return this.m.SourceActorID == 0 ? null : ::Tactical.getEntityByID(this.m.SourceActorID);
	}

	function valid()
	{
		local source = this.getSource();
		if (source == null || !source.isAlive() || !source.isPlacedOnMap()) return false;
		if (source.getTile().getDistanceTo(this.getContainer().getActor().getTile()) != 1) return false;
		local item = source.getItems().getItemByInstanceID(this.m.SourceItemID);
		return item != null && item.getCurrentSlotType() == this.Const.ItemSlot.Bag && this.m.SourceSkill != null;
	}

	function isUsable()
	{
		return this.valid() && this.m.SourceSkill.isUsable() && this.skill.isUsable();
	}

	function onVerifyTarget( _origin, _target )
	{
		return this.valid() && this.m.SourceSkill.onVerifyTarget(_origin, _target);
	}

	function getTooltip()
	{
		if (this.m.SourceSkill == null) return this.skill.getTooltip();
		local ret = this.m.SourceSkill.getTooltip();
		foreach (entry in ret) if (("id" in entry) && entry.id == 1 && ("text" in entry)) entry.text = this.m.Name;
		ret.push({ id = 97, type = "text", icon = "ui/icons/bag.png", text = "Uses the adjacent Improviser's consumable directly from their bag" });
		return ret;
	}

	function rememberDisplaced( _items, _item )
	{
		if (_item == null || _item == -1 || _items.find(_item) != null) return;
		_items.push(_item);
	}

	function findItemBlockingSlot( _items, _slot )
	{
		for (local slot = this.Const.ItemSlot.Mainhand; slot <= this.Const.ItemSlot.Ammo; ++slot)
		{
			local item = _items.getItemAtSlot(slot);
			if (item != null && item != -1 && item.getBlockedSlotType() == _slot) return item;
		}
		return null;
	}

	function placeBorrowedItem( _user, _source, _item, _displaced )
	{
		local sourceItems = _source.getItems();
		local userItems = _user.getItems();
		if (!sourceItems.removeFromBag(_item)) return false;

		if (_item.getSlotType() == this.Const.ItemSlot.Bag)
		{
			if (userItems.addToBag(_item)) return true;
			sourceItems.addToBag(_item);
			return false;
		}

		local occupying = userItems.getItemAtSlot(_item.getSlotType());
		if (occupying == -1) occupying = this.findItemBlockingSlot(userItems, _item.getSlotType());
		this.rememberDisplaced(_displaced, occupying);
		if (occupying != null && occupying != -1) userItems.unequip(occupying);

		if (_item.getBlockedSlotType() != null)
		{
			local blocked = userItems.getItemAtSlot(_item.getBlockedSlotType());
			if (blocked == -1) blocked = this.findItemBlockingSlot(userItems, _item.getBlockedSlotType());
			this.rememberDisplaced(_displaced, blocked);
			if (blocked != null && blocked != -1) userItems.unequip(blocked);
		}

		if (userItems.equip(_item)) return true;
		foreach (oldItem in _displaced) if (!userItems.equip(oldItem)) userItems.addToBag(oldItem);
		_displaced.clear();
		sourceItems.addToBag(_item);
		return false;
	}

	function restoreBorrowedEquipment( _user, _source, _item, _displaced )
	{
		local userItems = _user.getItems();
		if (!_item.isGarbage() && userItems.getItemByInstanceID(_item.getInstanceID()) != null)
		{
			if (_item.getCurrentSlotType() == this.Const.ItemSlot.Bag) userItems.removeFromBag(_item);
			else userItems.unequip(_item);
			if (!_source.getItems().addToBag(_item)) userItems.addToBag(_item);
		}
		foreach (oldItem in _displaced) if (!userItems.equip(oldItem)) userItems.addToBag(oldItem);
	}

	function onUse( _user, _target )
	{
		local source = this.getSource();
		if (!this.valid())
		{
			::Brotherhood.logObsidianTest("USE MINE", _user, "Rejected shared consumable: source moved, died, or no longer carries the item.");
			return false;
		}

		local item = source.getItems().getItemByInstanceID(this.m.SourceItemID);
		local displaced = [];
		if (item == null || !this.placeBorrowedItem(_user, source, item, displaced))
		{
			::Brotherhood.logObsidianTest("USE MINE", _user, "Rejected " + this.m.SourceSkill.getName() + ": could not temporarily place " + (item == null ? "the missing consumable" : item.getName()) + " into the required slot.");
			return false;
		}

		local result = this.m.SourceSkill.onUse(_user, _target);
		this.restoreBorrowedEquipment(_user, source, item, displaced);
		::Brotherhood.logObsidianTest("USE MINE", _user, "Used " + this.m.SourceSkill.getName() + " from " + source.getName() + "'s bag; item instance=" + this.m.SourceItemID + ", displaced items restored=" + displaced.len() + ", result=" + (result ? "true" : "false") + ".");
		return result;
	}
});
