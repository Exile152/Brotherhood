this.pg_bh_devout <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create(){this.m.ID="pg.bh_devout";this.m.Name="Devout";this.m.Description="A resolute believer who draws strength from adversity.";this.m.Icon="ui/perk_groups/rf_leadership.png";this.m.Tree=[[],["perk.fortified_mind"],["perk.bh_hope"],["perk.bh_mace_mastery"],[],[],[]];}
	function getTree(){local pool=["perk.bh_mace_mastery","perk.bh_hammer_mastery"];return [[],["perk.fortified_mind"],["perk.bh_hope"],[pool[::Math.rand(0,pool.len()-1)]],[],[],[]];}
});
