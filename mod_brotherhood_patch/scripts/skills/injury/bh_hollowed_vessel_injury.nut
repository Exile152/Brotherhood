this.bh_hollowed_vessel_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_hollowed_vessel";
		this.m.Name = "Hollowed Vessel";
		this.m.Description = "The wounded body empties itself of weakness and makes room for further trial.";
		this.m.DropIcon = "injury_icon_20";
		this.m.Icon = "ui/injury/injury_icon_20.png";
		this.m.IconMini = "injury_icon_20_mini";
		this.m.IsShownOnBody = true;
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/fatigue.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+5") + " [Maximum Fatigue|Concept.MaximumFatigue]") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.Stamina += 5; }
});
