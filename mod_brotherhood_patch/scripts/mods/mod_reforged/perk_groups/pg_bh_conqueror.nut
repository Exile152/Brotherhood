this.pg_bh_conqueror <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create(){this.m.ID="pg.bh_conqueror";this.m.Name="Conqueror";this.m.Description="A ruthless breaker of defenses, bodies, and fleeing enemies.";this.m.Icon="ui/perk_groups/rf_vicious.png";this.m.Tree=[[],["perk.bh_breach"],["perk.bh_shatter"],["perk.bh_flail_mastery","perk.bh_sword_mastery"],[],[],["perk.bh_despair","perk.bh_fearsome"]];}
	function getTree(){local pool=["perk.bh_sword_mastery","perk.bh_sword_mastery","perk.bh_hammer_mastery","perk.bh_mace_mastery","perk.bh_cleaver_mastery"];return [[],["perk.bh_breach"],["perk.bh_shatter"],["perk.bh_flail_mastery",pool[::Math.rand(0,pool.len()-1)]],[],[],["perk.bh_despair","perk.bh_fearsome"]];}
});
