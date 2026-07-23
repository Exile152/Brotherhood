this.perk_bh_not_important <- this.inherit("scripts/skills/skill", {
	m = { LastEnabled = null },
	function create()
	{
		this.m.ID = "perk.bh_not_important";
		this.m.Name = "Harmless";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_17.png";
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function isEnabled()
	{
		local actor = this.getContainer().getActor();
		if (!::Brotherhood.isEmptyHanded(actor)) return false;
		local mainhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local offhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return (mainhand == null || !mainhand.isItemType(this.Const.Items.ItemType.Shield))
			&& (offhand == null || !offhand.isItemType(this.Const.Items.ItemType.Shield));
	}

	function isHidden()
	{
		return !this.isEnabled();
	}

	function onUpdate( _properties )
	{
		local enabled = this.isEnabled();
		if (this.m.LastEnabled != enabled)
		{
			::Brotherhood.logObsidianTest("HARMLESS", this.getContainer().getActor(), enabled ? "Activated: no weapon or shield; Target Attraction x0.5." : "Deactivated: a weapon or shield is equipped.");
			this.m.LastEnabled = enabled;
		}
		if (enabled)
		{
			_properties.TargetAttractionMult *= 0.5;
		}
	}
});
