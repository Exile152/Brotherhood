this.perk_bh_music_mastery <- this.inherit("scripts/skills/skill", {
	m = { UsedLuteSkillThisRound = false },
	function create()
	{
		this.m.ID = "perk.bh_music_mastery";
		this.m.Name = "Music Mastery";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_music_mastery.png";
		this.m.IconDisabled = "ui/perks/bh_music_mastery_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onAdded() { ::Brotherhood.refreshMusicMasteryLutes(this.getContainer().getActor()); }
	function onUpdate( _p ) { if (::Brotherhood.hasLute(this.getContainer().getActor())) _p.Bravery += 10; }
	function onNewRound() { this.m.UsedLuteSkillThisRound = false; }
	function onCombatStarted() { this.m.UsedLuteSkillThisRound = false; }
	function onCombatFinished() { this.m.UsedLuteSkillThisRound = false; this.skill.onCombatFinished(); }
});
