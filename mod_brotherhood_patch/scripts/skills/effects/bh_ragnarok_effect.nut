this.bh_ragnarok_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.bh_ragnarok";
		this.m.Name = "Ragnarok";
		this.m.Description = "Attacks cost 3 Action Points and build twice their normal Fatigue.";
		this.m.Icon = "ui/perks/perk_03.png";
		this.m.IconDisabled = "ui/perks/perk_03_sw.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function onAdded()
	{
		::Brotherhood.logFleshcraftMechanic("RAGNAROK", this.getContainer().getActor(), "Ragnarok effect active.");
	}
	function onTurnEnd()
	{
		this.getContainer().remove(this);
	}
});
