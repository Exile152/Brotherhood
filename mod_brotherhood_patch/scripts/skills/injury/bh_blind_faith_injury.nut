this.bh_blind_faith_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_blind_faith";
		this.m.Name = "Blind Faith";
		this.m.Description = "The eyes may fail, but faith reads every threat written in the air.";
		this.m.DropIcon = "injury_icon_10";
		this.m.Icon = "ui/injury/injury_icon_10.png";
		this.m.IconMini = "injury_icon_10_mini";
		this.m.IsShownOnHead = true;
	}
	function getBonusTooltip()
	{
		return [
			{ id = 10, type = "text", icon = "ui/icons/melee_defense.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+3") + " [Melee Defense|Concept.MeleeDefense]") },
			{ id = 11, type = "text", icon = "ui/icons/ranged_defense.png", text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorPositive("+3") + " [Ranged Defense|Concept.RangeDefense]") }
		];
	}
	function applyFlagellantBonus( _properties ) { _properties.MeleeDefense += 3; _properties.RangedDefense += 3; }
});
