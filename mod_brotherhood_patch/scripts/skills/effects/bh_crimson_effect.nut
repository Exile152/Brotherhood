this.bh_crimson_effect <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "effects.bh_crimson";
		this.m.Name = "Crimson";
		this.m.Description = "Injured enemies are feeding you more power.";
		this.m.Icon = "ui/perks/bh_crimson.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
	}
	function getStacks()
	{
		return this.getContainer() == null ? 0 : ::Brotherhood.countCrimsonEnemies(this.getContainer().getActor());
	}
	function getDescription()
	{
		return this.m.Description;
	}
	function getTooltip()
	{
		local stacks = this.getStacks();
		local bonus = stacks * 2;
		return [
			{ id = 1, type = "title", text = this.m.Name },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "Current stacks: " + ::MSU.Text.colorPositive(stacks) },
			{ id = 7, type = "text", icon = "ui/icons/melee_skill.png", text = ::MSU.Text.colorPositive("+" + bonus) + " Melee Skill, Ranged Skill, Melee Defense, Ranged Defense, and Initiative" }
		];
	}
});
