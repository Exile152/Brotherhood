this.bh_cleansing_fever_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_cleansing_fever";
		this.m.Name = "Cleansing Fever";
		this.m.Description = "The burning fever scours weakness from the body and leaves only purpose.";
		this.m.DropIcon = "rf_heatstroke_injury";
		this.m.Icon = "ui/injury/rf_heatstroke_injury.png";
		this.m.IconMini = "rf_heatstroke_injury_mini";
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/fatigue.png", text = ::Reforged.Mod.Tooltips.parseString("Build " + ::MSU.Text.colorPositive("5%") + " less [Fatigue|Concept.Fatigue]") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.FatigueEffectMult *= 0.95; }
});
