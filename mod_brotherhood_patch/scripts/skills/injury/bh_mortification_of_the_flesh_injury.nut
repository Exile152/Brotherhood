this.bh_mortification_of_the_flesh_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_mortification_of_the_flesh";
		this.m.Name = "Mortification of the Flesh";
		this.m.Description = "The torn flesh is proof that conviction can outlast the body.";
		this.m.DropIcon = "injury_icon_27";
		this.m.Icon = "ui/injury/injury_icon_27.png";
		this.m.IconMini = "injury_icon_27_mini";
		this.m.IsShownOnBody = true;
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+5") + " [Resolve|Concept.Bravery]") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.Bravery += 5; }
});
