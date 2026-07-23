this.pg_bh_hunter <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create(){this.m.ID="pg.bh_hunter";this.m.Name="Hunter";this.m.Description="A calm ranged hunter who specializes for the quarry at hand.";this.m.Icon="ui/perk_groups/rf_marksmanship.png";this.m.Tree=[["perk.bh_small_head"],["perk.bh_steady_hands"],[],["perk.bh_bow_mastery"],[],["perk.bh_big_game_hunter","perk.head_hunter"],[]];}
	function getTree(){local pool=["perk.bh_bow_mastery","perk.bh_crossbow_mastery","perk.bh_throwing_mastery","perk.bh_net_mastery"];return [["perk.bh_small_head"],["perk.bh_steady_hands"],[],[pool[::Math.rand(0,pool.len()-1)]],[],["perk.bh_big_game_hunter","perk.head_hunter"],[]];}
});
