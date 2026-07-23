this.perk_bh_playful_smile <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_playful_smile";
		this.m.Name = "Playful Smile";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_06.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onMissed( _attacker, _skill )
	{
		local actor = this.getContainer().getActor();
		local roll = ::Math.rand(1, 100);
		if (roll <= 25)
		{
			local result = actor.checkMorale(1, 0);
			::Brotherhood.logObsidianTest("PLAYFUL SMILE", actor, "Miss roll " + roll + " <= 25; positive morale check triggered (result=" + (result ? "true" : "false") + ").");
		}
		else ::Brotherhood.logObsidianTest("PLAYFUL SMILE", actor, "Miss roll " + roll + " > 25; no morale check.");
	}
});
