this.bh_current_injury_debug_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},

	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.bh_current_injury_debug";
		this.m.Name = "[F6 CURRENT] Injury Baseline Draught";
		this.m.Description = "A current-perk testing consumable that applies one light and one heavy temporary injury.";
		this.m.Icon = "consumables/potion_01.png";
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local ret = this.anatomist_potion_item.getTooltip();
		ret.push({
			id = 60,
			type = "text",
			icon = "ui/icons/days_wounded.png",
			text = "Applies a fractured hand and broken ribs for testing current injury interactions"
		});
		ret.push({
			id = 61,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Useful for checking Resilient and injury-dependent character-sheet behavior"
		});
		return ret;
	}

	function onUse( _actor, _item = null )
	{
		_actor.getSkills().add(::new("scripts/skills/injury/fractured_hand_injury"));
		_actor.getSkills().add(::new("scripts/skills/injury/broken_ribs_injury"));
		::logInfo("[Brotherhood][F6 KIT] " + _actor.getName() + " received the light/heavy injury baseline.");
		return this.anatomist_potion_item.onUse(_actor, _item);
	}
});
