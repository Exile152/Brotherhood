this.perk_bh_not_you <- this.inherit("scripts/skills/skill", {
	m = { Before = [], Entered = [], Active = false },
	function create()
	{
		this.m.ID = "perk.bh_not_you";
		this.m.Name = "Not You";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_05.png";
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function getAdjacentIDs()
	{
		local ids = [];
		foreach (enemy in ::Brotherhood.getAdjacentEnemies(this.getContainer().getActor())) ids.push(enemy.getID());
		return ids;
	}
	function onMovementStarted( _tile, _num ) { this.m.Before = this.getAdjacentIDs(); }
	function onMovementFinished()
	{
		local now = this.getAdjacentIDs();
		this.m.Entered = [];
		foreach (id in now) if (this.m.Before.find(id) == null) this.m.Entered.push(id);
		this.m.Active = this.m.Entered.len() != 0;
		::Brotherhood.logObsidianTest("NOT YOU", this.getContainer().getActor(), this.m.Active ? "Entered " + this.m.Entered.len() + " new enemy Zone(s) of Control; next attack against another enemy is armed." : "Movement entered no new enemy Zone of Control; trigger not armed.");
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (!this.m.Active || _skill == null || !_skill.isAttack() || _target == null) return;
		local actor = this.getContainer().getActor();
		if (this.m.Entered.find(_target.getID()) != null)
		{
			::Brotherhood.logObsidianTest("NOT YOU", actor, "Rejected attack against " + _target.getName() + ": this is the enemy whose Zone of Control was entered.");
			return;
		}
		_properties.DamageTotalMult *= 1.10;
		this.m.Active = false;
		::Brotherhood.logObsidianTest("NOT YOU", actor, "Applied +10% damage against different target " + _target.getName() + "; trigger consumed.");
	}
	function onTurnStart() { this.m.Active = false; this.m.Before = []; this.m.Entered = []; }
	function onCombatFinished() { this.onTurnStart(); this.skill.onCombatFinished(); }
});
