this.bh_pilgrims_agony_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_pilgrims_agony";
		this.m.Name = "Pilgrim's Agony";
		this.m.Description = "Pain drives each step onward with feverish urgency.";
		this.m.DropIcon = "injury_icon_24";
		this.m.Icon = "ui/injury/injury_icon_24.png";
		this.m.IconMini = "injury_icon_24_mini";
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/initiative.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+10") + " [Initiative|Concept.Initiative]") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.Initiative += 10; }
});
