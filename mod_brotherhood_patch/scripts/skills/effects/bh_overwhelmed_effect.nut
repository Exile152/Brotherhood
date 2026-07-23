this.bh_overwhelmed_effect <- this.inherit("scripts/skills/skill", {
	m = { Count = 1 },
	function create()
	{
		this.m.ID = "effects.bh_overwhelmed";
		this.m.Name = "Overwhelmed";
		this.m.Description = "Each stack lowers this character's Melee Skill and Ranged Skill by 10% for one turn.";
		this.m.Icon = "skills/status_effect_74.png";
		this.m.IconMini = "status_effect_74_mini";
		this.m.Overlay = "status_effect_74";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function getName()
	{
		return this.m.Count <= 1 ? this.m.Name : this.m.Name + " (x" + this.m.Count + ")";
	}
	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=10, type="text", icon="ui/icons/melee_skill.png", text="[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 10 + "%[/color] Melee Skill" },
			{ id=11, type="text", icon="ui/icons/ranged_skill.png", text="[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.m.Count * 10 + "%[/color] Ranged Skill" }
		];
	}
	function onRefresh()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50) return;
		this.m.Count += 1;
		this.spawnIcon("status_effect_74", this.getContainer().getActor().getTile());
	}
	function onUpdate( _properties )
	{
		local multiplier = ::Math.maxf(0.0, 1.0 - 0.1 * this.m.Count);
		_properties.MeleeSkillMult *= multiplier;
		_properties.RangedSkillMult *= multiplier;
	}
	function onTurnEnd() { this.removeSelf(); }
	function onNewRound() { this.removeSelf(); }
});
