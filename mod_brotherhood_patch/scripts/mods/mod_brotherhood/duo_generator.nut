// DUOs are closed-loop rewards: both retained archetypes and the perks that
// mechanically feed the DUO must already be present in this tree.
::Brotherhood.DuoRegistry <- [
	{ ID="perk.bh_learning_devil", Tier=1, Archetypes=["pg.bh_prodigy","pg.bh_impish"], RequiredPerks=["perk.bh_knowledge_mastery","perk.bh_little_devil"] },
	{ ID="perk.bh_scholarship", Tier=2, Archetypes=["pg.bh_blueblood","pg.bh_prodigy"], RequiredPerks=["perk.bh_birthright","perk.bh_knowledge_mastery"] },
	{ ID="perk.bh_ambition", Tier=3, Archetypes=["pg.bh_prodigy","pg.bh_braggart"], RequiredPerks=["perk.bh_student","perk.bh_winner_takes_all"] },
	{ ID="perk.bh_bladed_arm", Tier=6, Archetypes=["pg.bh_brawler","pg.bh_knave"], RequiredPerks=["perk.bh_callous_hands","perk.bh_dagger_mastery"] },
	{ ID="perk.bh_parry_a_gun", Tier=6, Archetypes=["pg.bh_artillerist","pg.bh_swashbuckler"], RequiredPerks=["perk.bh_explosive_bullets","perk.bh_change_of_tempo"] },
	{ ID="perk.bh_gods_eyes", Tier=7, Archetypes=["pg.bh_duelist","pg.bh_marksman"], RequiredPerks=["perk.bh_sword_mastery","perk.bh_eagle_eyesight"] },
	{ ID="perk.bh_swords_and_sandals", Tier=7, Archetypes=["pg.bh_bard","pg.bh_gladiator"], RequiredPerks=["perk.bh_music_mastery","perk.bh_all_eyes_on_me"] },
	{ ID="perk.bh_bloodletting", Tier=6, Archetypes=["pg.bh_plague_doctor","pg.bh_flagellant"], RequiredPerks=["perk.bh_ghost_pain","perk.bh_truthful_pain"] },
	{ ID="perk.bh_dragonet", Tier=7, Archetypes=["pg.bh_dragon","pg.bh_impish"], RequiredPerks=["perk.bh_dragons_breath","perk.bh_little_devil"] }
];

::Brotherhood.addCompatibleDuoPerks <- function( _perkTree )
{
	local added = [];
	foreach (duo in ::Brotherhood.DuoRegistry)
	{
		local valid = true;
		foreach (groupID in duo.Archetypes) if (!_perkTree.hasPerkGroup(groupID)) { valid = false; break; }
		if (!valid) continue;
		foreach (perkID in duo.RequiredPerks) if (!_perkTree.hasPerk(perkID)) { valid = false; break; }
		if (!valid || ::Const.Perks.findById(duo.ID) == null) continue;
		_perkTree.addPerk(duo.ID, duo.Tier);
		if (_perkTree.hasPerk(duo.ID)) added.push(duo.ID);
	}
	_perkTree.m.BH_CompatibleDuoPerks <- added;
	::logInfo("[Brotherhood][WheelOfFortune] Compatible DUOs added: [" + ::Brotherhood.formatIDsForLog(added) + "]");
	return added;
}
