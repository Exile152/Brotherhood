this.perk_bh_preparation <- this.inherit("scripts/skills/skill", {
	m = { BonusRecords = [], CombatActive = false },
	function create()
	{
		this.m.ID = "perk.bh_preparation";
		this.m.Name = "Preparation";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.bags_and_belts", "ui/perks/perk_20.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function hasRecord( _item )
	{
		foreach (record in this.m.BonusRecords)
			if (record.Item == _item) return record;
		return null;
	}
	function addCandidate( _items, _item )
	{
		if (::MSU.isNull(_item) || _item.getAmmoMax() <= 0) return;
		foreach (candidate in _items) if (candidate == _item) return;
		_items.push(_item);
	}
	function applyAmmoBonus()
	{
		if (!this.m.CombatActive || this.getContainer() == null) return;
		local actor = this.getContainer().getActor();
		local candidates = [];
		local items = actor.getItems();
		local ammo = items.getItemAtSlot(this.Const.ItemSlot.Ammo);
		if (ammo != null && ammo.isItemType(this.Const.Items.ItemType.Ammo)) this.addCandidate(candidates, ammo);
		foreach (slot in [this.Const.ItemSlot.Mainhand, this.Const.ItemSlot.Offhand])
		{
			local weapon = items.getItemAtSlot(slot);
			if (::Brotherhood.isFleshcraftThrowingWeapon(weapon)) this.addCandidate(candidates, weapon);
		}
		foreach (item in candidates)
		{
			local existing = this.hasRecord(item);
			if (existing != null)
			{
				// Some equipment refresh paths rebuild an item's authored ammunition
				// capacity during combat. Repair only the maximum; never refill spent
				// shots after Preparation has already granted its initial two.
				local desiredMax = existing.OriginalMax + 2;
				if (item.getAmmoMax() != desiredMax)
				{
					item.m.AmmoMax = desiredMax;
					::Brotherhood.logFleshcraftMechanic("PREPARATION", actor, "Repaired temporary ammunition capacity on " + item.getName() + " to " + item.getAmmo() + "/" + desiredMax + ".");
				}
				continue;
			}
			local originalMax = item.getAmmoMax();
			this.m.BonusRecords.push({ Item = item, OriginalMax = originalMax });
			item.m.AmmoMax = originalMax + 2;
			item.setAmmo(::Math.min(item.getAmmo() + 2, item.m.AmmoMax));
			::Brotherhood.logFleshcraftMechanic("PREPARATION", actor, "Granted +2 temporary ammunition to " + item.getName() + " (" + item.getAmmo() + "/" + item.getAmmoMax() + ").");
		}
		if (candidates.len() > 0) actor.setDirty(true);
	}
	function refreshAfterEquip()
	{
		if (this.getContainer() == null || !this.Tactical.isActive()) return;
		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap()) return;
		this.m.CombatActive = true;
		this.applyAmmoBonus();
	}
	function onCombatStarted()
	{
		this.skill.onCombatStarted();
		this.m.BonusRecords = [];
		this.m.CombatActive = true;
		this.applyAmmoBonus();
	}
	function onAdded()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap() && this.Tactical.isActive())
		{
			this.m.CombatActive = true;
			this.applyAmmoBonus();
		}
	}
	function onTurnStart()
	{
		// This also repairs combat-loaded characters whose skill missed the
		// initial onCombatStarted dispatch.
		this.m.CombatActive = true;
		this.applyAmmoBonus();
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (!this.m.CombatActive && actor != null && actor.isPlacedOnMap() && this.Tactical.isActive()) this.m.CombatActive = true;
		if (this.m.CombatActive) this.applyAmmoBonus();
	}
	function onCombatFinished()
	{
		this.m.CombatActive = false;
		foreach (record in this.m.BonusRecords)
		{
			local item = record.Item;
			if (::MSU.isNull(item)) continue;
			item.m.AmmoMax = record.OriginalMax;
			item.setAmmo(::Math.min(item.getAmmo(), record.OriginalMax));
		}
		this.m.BonusRecords = [];
		this.skill.onCombatFinished();
	}
});
