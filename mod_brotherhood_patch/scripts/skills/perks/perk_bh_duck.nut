this.perk_bh_duck <- this.inherit("scripts/skills/skill", {
	m = { Spent = false },
	function create()
	{
		this.m.ID = "perk.bh_duck";
		this.m.Name = "Duck!";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_10.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onMissed( _attacker, _skill )
	{
		local actor = this.getContainer().getActor();
		if (this.m.Spent) { ::Brotherhood.logObsidianTest("DUCK", actor, "Miss ignored: redirect was already spent this round."); return; }
		if (_attacker == null || _skill == null || !_skill.isAttack() || _skill.isRanged()) { ::Brotherhood.logObsidianTest("DUCK", actor, "Miss ignored: requires a melee attack."); return; }
		local candidates = [];
		foreach (enemy in ::Brotherhood.getAdjacentEnemies(actor)) if (enemy.getID() != _attacker.getID() && enemy.isAlliedWith(_attacker)) candidates.push(enemy);
		if (candidates.len() == 0) { ::Brotherhood.logObsidianTest("DUCK", actor, "Miss by " + _attacker.getName() + " had no adjacent enemy redirect target."); return; }
		this.m.Spent = true;
		local target = candidates[::Math.rand(0, candidates.len() - 1)];
		local effect = this.new("scripts/skills/effects/bh_duck_redirect_effect");
		_attacker.getSkills().add(effect);
		::Brotherhood.logObsidianTest("DUCK", actor, "Redirecting " + _attacker.getName() + "'s missed " + _skill.getName() + " into " + target.getName() + " at 50% damage.");
		_skill.attackEntity(_attacker, target);
		_attacker.getSkills().remove(effect);
	}
	function onNewRound() { this.m.Spent = false; }
	function onCombatStarted() { this.m.Spent = false; }
});
