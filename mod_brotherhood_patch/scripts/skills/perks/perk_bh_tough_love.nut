this.perk_bh_tough_love <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_tough_love";
		this.m.Name = "Hard Lesson";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function getInjuryCount()
	{
		return this.getContainer().getAllSkillsOfType(this.Const.SkillType.TemporaryInjury).len()
			+ this.getContainer().getAllSkillsOfType(this.Const.SkillType.PermanentInjury).len();
	}

	function isHidden()
	{
		return this.getInjuryCount() == 0;
	}

	function onUpdate( _properties )
	{
		local bonus = this.getInjuryCount() * 3;
		_properties.MeleeDefense += bonus;
	}
});
