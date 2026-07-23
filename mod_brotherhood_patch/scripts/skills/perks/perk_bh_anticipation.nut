this.perk_bh_anticipation <- this.inherit("scripts/skills/perks/perk_anticipation", {
	function create()
	{
		this.perk_anticipation.create();
		this.m.ID = "perk.bh_anticipation";
		this.m.Name = "Anticipation";
		this.m.Description = ::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);
	}

	function onUpdate( _properties )
	{
		this.perk_anticipation.onUpdate(_properties);
		_properties.Vision += 1;
	}
});
