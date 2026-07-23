this.perk_bh_crimson <- this.inherit("scripts/skills/skill", {
	function create(){this.m.ID="perk.bh_crimson";this.m.Name="Crimson";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applyCustomPerkIcon(this);this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function ensureStatus()
	{
		if (this.getContainer() != null && !this.getContainer().hasSkill("effects.bh_crimson")) this.getContainer().add(this.new("scripts/skills/effects/bh_crimson_effect"));
	}
	function onAdded() { this.ensureStatus(); }
	function onRemoved() { if (this.getContainer() != null) this.getContainer().removeByID("effects.bh_crimson"); }
	function onCombatStarted() { this.ensureStatus(); }
	function onUpdate( _properties )
	{
		local bonus = ::Brotherhood.countCrimsonEnemies(this.getContainer().getActor()) * 2;
		_properties.MeleeSkill += bonus; _properties.RangedSkill += bonus; _properties.MeleeDefense += bonus; _properties.RangedDefense += bonus; _properties.Initiative += bonus;
	}
});
