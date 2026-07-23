this.bh_breath_of_penance_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_breath_of_penance";
		this.m.Name = "Breath of Penance";
		this.m.Description = "Each painful breath becomes a measured prayer that restores the body's rhythm.";
		this.m.DropIcon = "injury_icon_22";
		this.m.Icon = "ui/injury/injury_icon_22.png";
		this.m.IconMini = "injury_icon_22_mini";
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/fatigue.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+1") + " [Fatigue Recovery|Concept.FatigueRecovery] each turn") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.FatigueRecoveryRate += 1; }
});
