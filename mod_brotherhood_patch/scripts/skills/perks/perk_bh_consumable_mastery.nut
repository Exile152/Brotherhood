this.perk_bh_consumable_mastery <- this.inherit("scripts/skills/skill", {
	m = { BonusApplied = false, BonusRecords = [] },
	function create()
	{
		this.m.ID = "perk.bh_consumable_mastery";
		this.m.Name = "Consumable Mastery";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.bags_and_belts", "ui/perks/perk_20.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function isConsumableItem( _item )
	{
		return _item != null && (_item.isItemType(this.Const.Items.ItemType.Usable) || _item.isItemType(this.Const.Items.ItemType.Tool));
	}
	function applyStartBonus()
	{
		if (this.m.BonusApplied || this.getContainer() == null) return;
		local actor = this.getContainer().getActor();
		foreach (item in actor.getItems().getAllItems())
		{
			if (!this.isConsumableItem(item) || !("getAmmoMax" in item) || item.getAmmoMax() <= 0) continue;
			// Record the authored capacity so the bonus is always base + 2 rather
			// than compounding by two on every subsequent battle.
			local originalMax = item.getAmmoMax();
			this.m.BonusRecords.push({ Item = item, OriginalMax = originalMax });
			item.m.AmmoMax = originalMax + 2;
			item.setAmmo(::Math.min(item.getAmmo() + 2, item.m.AmmoMax));
		}
		this.m.BonusApplied = true;
		::Brotherhood.logFleshcraftMechanic("CONSUMABLE MASTERY", actor, "Granted +2 uses to equipped and bagged consumables.");
	}
	function onCombatStarted()
	{
		this.m.BonusApplied = false;
		this.applyStartBonus();
	}
	function onCombatFinished()
	{
		this.m.BonusApplied = false;
		foreach (record in this.m.BonusRecords)
		{
			local item = record.Item;
			if (::MSU.isNull(item)) continue;
			item.m.AmmoMax = record.OriginalMax;
			item.setAmmo(::Math.min(item.getAmmo(), record.OriginalMax));
			::Brotherhood.logFleshcraftMechanic("CONSUMABLE MASTERY", this.getContainer() == null ? null : this.getContainer().getActor(), "Restored " + item.getName() + " to its authored capacity of " + record.OriginalMax + ".");
		}
		this.m.BonusRecords = [];
		this.skill.onCombatFinished();
	}
	function onAdded()
	{
		if (this.getContainer() != null && this.Tactical.isActive()) this.applyStartBonus();
	}
});
