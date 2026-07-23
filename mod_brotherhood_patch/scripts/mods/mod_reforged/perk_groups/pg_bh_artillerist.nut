this.pg_bh_artillerist <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create()
	{
		this.m.ID="pg.bh_artillerist";
		this.m.Name="Artillerist";
		this.m.Description="A gunpowder specialist who brings extra ammunition and devastating Handgonne loads.";
		this.m.Icon="ui/perk_groups/rf_crossbow.png";
		this.m.Tree=[["perk.bh_more_ammo"],[],["perk.bh_anticipation"],["perk.bh_gunpowder_mastery"],[],[],["perk.bh_explosive_bullets"]];
	}
});
