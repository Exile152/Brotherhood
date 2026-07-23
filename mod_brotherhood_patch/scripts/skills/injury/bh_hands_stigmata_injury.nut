this.bh_hands_stigmata_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_hands_stigmata";
		this.m.Name = "Hand's Stigmata";
		this.m.Description = "Pain marks the hands, and every movement closes more firmly around bowstring and hilt.";
		this.m.DropIcon = "injury_icon_01";
		this.m.Icon = "ui/injury/injury_icon_01.png";
		this.m.IconMini = "injury_icon_01_mini";
	}
	function getBonusTooltip()
	{
		return [
			{ id = 10, type = "text", icon = "ui/icons/melee_skill.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+3") + " [Melee Skill|Concept.MeleeSkill]") },
			{ id = 11, type = "text", icon = "ui/icons/ranged_skill.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+3") + " [Ranged Skill|Concept.RangeSkill]") }
		];
	}
	function applyFlagellantBonus( _properties ) { _properties.MeleeSkill += 3; _properties.RangedSkill += 3; }
});
