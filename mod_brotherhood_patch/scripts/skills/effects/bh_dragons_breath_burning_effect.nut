this.bh_dragons_breath_burning_effect <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "effects.bh_dragons_breath_burning";
		this.m.Name = "Burning";
		this.m.Description = "This character was hit by Dragon's Breath and is Burning until the start of their next turn.";
		this.m.Icon = "skills/active_202.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		::Brotherhood.logObsidianTest("DRAGONS BREATH", actor, "Burning expired at the start of this turn.");
		this.removeSelf();
	}
});
