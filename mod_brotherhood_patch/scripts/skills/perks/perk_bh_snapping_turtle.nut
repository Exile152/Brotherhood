this.perk_bh_snapping_turtle <- this.inherit("scripts/skills/skill", {
	m = {
		HasShieldAndTwoHander = false,
		PenaltyWasActive = false
	},
	function create()
	{
		this.m.ID = "perk.bh_snapping_turtle";
		this.m.Name = "Snapping Turtle";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.shield_expert", "ui/perks/perk_05.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function refreshLoadout()
	{
		local actor = this.getContainer().getActor();
		local items = actor.getItems();
		local main = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = items.getItemAtSlot(this.Const.ItemSlot.Offhand);
		this.m.HasShieldAndTwoHander = main != null && main.isItemType(this.Const.Items.ItemType.TwoHanded) && off != null && off.isItemType(this.Const.Items.ItemType.Shield);
	}
	function onAdded()
	{
		this.refreshLoadout();
		::Brotherhood.refreshSnappingTurtleLoadout(this.getContainer().getActor(), "perk added");
	}
	function onRemoved()
	{
		::Brotherhood.refreshSnappingTurtleLoadout(this.getContainer().getActor(), "perk removed");
		this.skill.onRemoved();
	}
	function onUpdate( _properties )
	{
		this.refreshLoadout();
		if (this.m.HasShieldAndTwoHander)
		{
			_properties.DamageRegularMin *= 0.5;
			_properties.DamageRegularMax *= 0.5;
		}

		if (this.m.HasShieldAndTwoHander != this.m.PenaltyWasActive)
		{
			::Brotherhood.logFleshcraftMechanic("SNAPPING TURTLE", this.getContainer().getActor(), this.m.HasShieldAndTwoHander
				? "Activated 50% attack damage penalty: shield and two-handed weapon are equipped."
				: "Deactivated attack damage penalty: shield and two-handed weapon are no longer both equipped.");
			this.m.PenaltyWasActive = this.m.HasShieldAndTwoHander;
		}
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		this.refreshLoadout();
		if (!this.m.HasShieldAndTwoHander || _skill == null || !_skill.isAttack()) return;
		::Brotherhood.logFleshcraftMechanic("SNAPPING TURTLE", this.getContainer().getActor(), "Attack used the active 50% damage penalty from the equipped shield and two-handed weapon.");
	}
});
