this.perk_bh_hard_lesson <- this.inherit("scripts/skills/skill", {
	m = { LastInjuryCount = -1 },
	function create()
	{
		this.m.ID = "perk.bh_hard_lesson";
		this.m.Name = "Hard Lesson";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_13.png";
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onUpdate( _properties )
	{
		local container = this.getContainer();
		local count = container.getAllSkillsOfType(this.Const.SkillType.TemporaryInjury).len() + container.getAllSkillsOfType(this.Const.SkillType.PermanentInjury).len();
		_properties.MeleeDefense += count * 3;
		if (this.m.LastInjuryCount != count)
		{
			::Brotherhood.logObsidianTest("HARD LESSON", container.getActor(), count + " injury/injuries grant +" + (count * 3) + " Melee Defense.");
			this.m.LastInjuryCount = count;
		}
	}
});
