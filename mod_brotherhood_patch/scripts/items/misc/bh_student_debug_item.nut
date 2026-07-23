this.bh_student_debug_item <- this.inherit("scripts/items/misc/anatomist/anatomist_potion_item", {
	m = {},
	function create()
	{
		this.anatomist_potion_item.create();
		this.m.ID = "misc.bh_student_debug";
		this.m.Name = "[DEBUG] Elixir of Certain Learning";
		this.m.Description = "A testing consumable that forces Student's next eligible permanent-attribute battle roll to have a 100% success chance.";
		this.m.Icon = "consumables/potion_01.png";
		this.m.Value = 0;
	}

	function getTooltip()
	{
		local ret = this.anatomist_potion_item.getTooltip();
		ret.push({
			id = 60,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Forces Student's next eligible battle to use a " + ::MSU.Text.colorPositive("100%") + " permanent-attribute chance."
		});
		ret.push({
			id = 61,
			type = "hint",
			icon = "ui/tooltips/warning.png",
			text = "Debug item. The selected character must have Student and be below Level 11."
		});
		return ret;
	}

	function onUse( _actor, _item = null )
	{
		local perk = _actor.getSkills().getSkillByID("perk.bh_student");
		if (perk == null || _actor.getLevel() >= 11)
		{
			::logInfo("[Brotherhood][STUDENT] " + _actor.getName() + ": debug potion rejected; Student is missing or the character is Level 11 or higher.");
			return false;
		}

		_actor.getFlags().set("BH_StudentDebugForce100", true);
		::logInfo("[Brotherhood][STUDENT] " + _actor.getName() + ": debug potion armed a 100% permanent-attribute roll for the next eligible battle.");
		return this.anatomist_potion_item.onUse(_actor, _item);
	}
});
