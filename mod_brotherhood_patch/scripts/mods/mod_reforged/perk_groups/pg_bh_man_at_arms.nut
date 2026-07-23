this.pg_bh_man_at_arms <- ::inherit(::DynamicPerks.Class.PerkGroup, {
	m = {},
	function create(){this.m.ID="pg.bh_man_at_arms";this.m.Name="Man-At-Arms";this.m.Description="A veteran soldier with one randomly selected battlefield mastery.";this.m.Icon="ui/perk_groups/rf_soldier.png";this.m.Tree=[[],[],[],["perk.bh_shield_mastery"],[],[],["perk.bh_veteran"]];}
	function getTree(){local pool=["perk.bh_axe_mastery","perk.bh_flail_mastery","perk.bh_hammer_mastery","perk.bh_mace_mastery","perk.bh_polearm_mastery","perk.bh_spear_mastery","perk.bh_sword_mastery"];return [[],[],[],["perk.bh_shield_mastery",pool[::Math.rand(0,pool.len()-1)]],[],[],["perk.bh_veteran"]];}
});
