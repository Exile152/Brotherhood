this.bh_holy_delirium_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_holy_delirium";
		this.m.Name = "Holy Delirium";
		this.m.Description = "Through the blood and ringing skull comes a revelation that no fear can silence.";
		this.m.DropIcon = "injury_icon_17";
		this.m.Icon = "ui/injury/injury_icon_17.png";
		this.m.IconMini = "injury_icon_17_mini";
		this.m.IsShownOnHead = true;
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/bravery.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + " [Resolve|Concept.Bravery]") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.Bravery += 10; }
});
