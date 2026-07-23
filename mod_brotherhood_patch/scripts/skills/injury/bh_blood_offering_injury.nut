this.bh_blood_offering_injury <- this.inherit("scripts/skills/injury/bh_flagellant_injury", {
	m = {},
	function create()
	{
		this.bh_flagellant_injury.create();
		this.m.ID = "injury.bh_blood_offering";
		this.m.Name = "Blood Offering";
		this.m.Description = "Spilled blood becomes an offering, and nearing death makes every strike more fervent.";
		this.m.DropIcon = "injury_icon_31";
		this.m.Icon = "ui/injury/injury_icon_31.png";
		this.m.IconMini = "injury_icon_31_mini";
		this.m.IsShownOnArm = true;
	}
	function getBonusTooltip()
	{
		return [{ id = 10, type = "text", icon = "ui/icons/damage_dealt.png", text = ::Reforged.Mod.Tooltips.parseString("While below " + ::MSU.Text.colorNegative("50%") + " [Hitpoints|Concept.Hitpoints], deal " + ::MSU.Text.colorPositive("+5%") + " damage") }];
	}
	function applyFlagellantBonus( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getHitpoints() < actor.getHitpointsMax() * 0.5) _properties.DamageTotalMult *= 1.05;
	}
});
