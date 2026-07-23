this.perk_bh_endurance <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_endurance";
		this.m.Name = "Endurance";
		this.m.Description = ::Brotherhood.getEnduranceTooltip();
		this.m.Icon = "ui/perks/bh_endurance.png";
		this.m.IconDisabled = "ui/perks/bh_endurance_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function getArmorFatiguePenalty()
	{
		local items = this.getContainer().getActor().getItems();
		local modifier = 0;
		foreach (slot in [this.Const.ItemSlot.Body, this.Const.ItemSlot.Head])
		{
			local item = items.getItemAtSlot(slot);
			if (item != null) modifier += item.getStaminaModifier();
		}

		return this.Math.max(0, -modifier);
	}
});
