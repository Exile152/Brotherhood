this.bh_promised_potential_effect <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "effects.bh_promised_potential";
		this.m.Name = "Promised Potential";
		this.m.Description = "This character's potential will be decided upon reaching level 11.";
		this.m.Icon = "ui/perks/bh_promised_potential.png";
		this.m.IconDisabled = "ui/perks/bh_promised_potential_sw.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function getCurrentChance()
	{
		if (this.getContainer() == null) return 0;

		local perk = this.getContainer().getSkillByID("perk.bh_promised_potential");
		return perk == null ? 0 : perk.getSuccessChance();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Current success chance: " + ::MSU.Text.colorPositive(this.getCurrentChance().tostring() + "%")
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getSkillByID("perk.bh_promised_potential") == null) this.removeSelf();
	}
});
