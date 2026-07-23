this.bh_scourged_shoulder_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_scourged_shoulder";
		this.m.Name = "Scourged Shoulder";
		this.m.Description = "Every lash of pain drives the wounded shoulder to strike with greater devotion.";
		this.m.DropIcon = "injury_icon_12";
		this.m.Icon = "ui/injury/injury_icon_12.png";
		this.m.IconMini = "injury_icon_12_mini";
		this.m.IsShownOnBody = true;
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/damage_dealt.png", text = ::Reforged.Mod.Tooltips.parseString("Deal " + ::MSU.Text.colorPositive("+5%") + " damage") }];
	}
	function applyFlagellantBonus( _properties ) { _properties.DamageTotalMult *= 1.05; }
});
