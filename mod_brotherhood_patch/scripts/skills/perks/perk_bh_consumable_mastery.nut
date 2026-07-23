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
		this.m.IsHidden = true;
	}
	function applyStartBonus()
	{
		if (this.m.BonusApplied || this.getContainer() == null) return;
		local actor = this.getContainer().getActor();
		local boosted = 0;
		foreach (item in actor.getItems().getAllItems())
		{
			if (!::Brotherhood.isCombatToolConsumable(item)) continue;
			::Brotherhood.applyCombatToolAmmoTrack(item);

			local originalMax = item.getAmmoMax();
			local originalAmmo = item.getAmmo();
			item.m.AmmoMax = originalMax + 2;
			item.setAmmo(::Math.min(originalAmmo + 2, item.m.AmmoMax));
			this.m.BonusRecords.push({
				Item = item,
				OriginalMax = originalMax,
				OriginalAmmo = originalAmmo
			});
			boosted += 1;
			::Brotherhood.logFleshcraftMechanic("CONSUMABLE MASTERY", actor, "Boosted " + item.getName() + " to " + item.getAmmo() + "/" + item.getAmmoMax() + ".");
		}
		this.m.BonusApplied = true;
		actor.setDirty(true);
		if (boosted == 0)
			::Brotherhood.logFleshcraftMechanic("CONSUMABLE MASTERY", actor, "No combat tools were available to boost.");
		else
			::Brotherhood.logFleshcraftMechanic("CONSUMABLE MASTERY", actor, "Granted +2 uses to " + boosted + " combat tool(s).");
	}
	function onCombatStarted()
	{
		this.m.BonusRecords = [];
		this.m.BonusApplied = false;
		this.applyStartBonus();
	}
	function onCombatFinished()
	{
		foreach (record in this.m.BonusRecords)
		{
			local item = record.Item;
			if (::MSU.isNull(item)) continue;
			item.m.AmmoMax = record.OriginalMax;
			item.setAmmo(::Math.min(item.getAmmo(), record.OriginalMax));
		}
		this.m.BonusRecords = [];
		this.m.BonusApplied = false;
		this.skill.onCombatFinished();
	}
	function onAdded()
	{
		if (this.getContainer() != null && this.Tactical.isActive()) this.applyStartBonus();
	}
});
