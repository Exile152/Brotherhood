this.perk_bh_sangria <- this.inherit("scripts/skills/skill", {
	m = { LastCount = 0 },
	function create()
	{
		this.m.ID = "perk.bh_sangria";
		this.m.Name = "Sangria";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_07.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function count()
	{
		local container = this.getContainer();
		return container.getAllSkillsOfType(this.Const.SkillType.TemporaryInjury).len() + container.getAllSkillsOfType(this.Const.SkillType.PermanentInjury).len();
	}
	function onAdded() { this.m.LastCount = this.count(); }
	function onDamageReceived( _attacker, _hp, _armor )
	{
		local count = this.count();
		if (count > this.m.LastCount)
		{
			local actor = this.getContainer().getActor();
			local gained = count - this.m.LastCount;
			local heal = ::Math.floor(actor.getHitpointsMax() * 0.10 * gained);
			local before = actor.getHitpoints();
			actor.setHitpoints(::Math.min(actor.getHitpointsMax(), before + heal));
			::Brotherhood.logObsidianTest("SANGRIA", actor, "Received " + gained + " new injury/injuries; healed " + (actor.getHitpoints() - before) + " HP (requested " + heal + ").");
		}
		this.m.LastCount = count;
	}
	function onCombatStarted() { this.m.LastCount = this.count(); }
});
