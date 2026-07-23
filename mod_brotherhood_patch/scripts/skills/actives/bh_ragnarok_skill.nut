this.bh_ragnarok_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.bh_ragnarok";
		this.m.Name = "Ragnarok";
		this.m.Description = "Your attacks cost 3 Action Points and build twice their normal Fatigue until the end of your turn.";
		this.m.Icon = "ui/perks/perk_03.png";
		this.m.IconDisabled = "ui/perks/perk_03_sw.png";
		this.m.Overlay = "perk_03";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any - 1;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 20;
	}
	function getTooltip() { return this.getDefaultUtilityTooltip(); }
	function isUsable() { return this.skill.isUsable(); }
	function onUse( _user, _targetTile )
	{
		if (!_user.getSkills().hasSkill("effects.bh_ragnarok")) _user.getSkills().add(this.new("scripts/skills/effects/bh_ragnarok_effect"));
		::Brotherhood.logFleshcraftMechanic("RAGNAROK", _user, "Activated Ragnarok until end of turn.");
		return true;
	}
});
