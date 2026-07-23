this.bh_vigilant_flesh_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_vigilant_flesh";
		this.m.Name = "Vigilant Flesh";
		this.m.Description = "Every wounded muscle anticipates the next approaching blow.";
		this.m.DropIcon = "injury_icon_23";
		this.m.Icon = "ui/injury/injury_icon_23.png";
		this.m.IconMini = "injury_icon_23_mini";
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+3") + " [Melee Defense|Concept.MeleeDefense]") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.MeleeDefense += 3; }
});
