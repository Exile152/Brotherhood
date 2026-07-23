this.perk_bh_reentering_stage <- this.inherit("scripts/skills/skill", {
	m = { Targets = [], StartingEnemies = [], MarkedRounds = {} },
	function create() { this.m.ID = "perk.bh_reentering_stage"; this.m.Name = "Re-entering Stage"; this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID); this.m.Icon = "ui/perks/perk_26.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; this.m.IsActive = false; }
	function removeMark( _id )
	{
		local enemy = ::Tactical.getEntityByID(_id);
		if (enemy != null)
		{
			local mark = enemy.getSkills().getSkillByID("effects.bh_reentering_stage_mark");
			if (mark != null) mark.removeSource(this.getContainer().getActor().getID());
		}
		local pos = this.m.Targets.find(_id);
		if (pos != null) this.m.Targets.remove(pos);
		if (_id in this.m.MarkedRounds) delete this.m.MarkedRounds[_id];
	}
	function clearMarks()
	{
		local ids = clone this.m.Targets;
		foreach (id in ids) this.removeMark(id);
	}
	function onTurnStart() {}
	function onTurnEnd()
	{
		local round = ::Time.getRound();
		local expired = [];
		foreach (id in this.m.Targets)
		{
			if (!(id in this.m.MarkedRounds) || this.m.MarkedRounds[id] < round) expired.push(id);
		}
		foreach (id in expired) this.removeMark(id);
	}
	function onMovementStarted( _tile, _numTiles )
	{
		local actor = this.getContainer().getActor();
		this.m.StartingEnemies.clear();
		foreach (faction in ::Tactical.Entities.getAllInstances()) foreach (enemy in faction) if (enemy != null && enemy.isAlive() && !enemy.isAlliedWith(actor) && enemy.isPlacedOnMap() && enemy.getTile().getDistanceTo(_tile) == 1) this.m.StartingEnemies.push(enemy.getID());
	}
	function onMovementFinished()
	{
		local actor = this.getContainer().getActor();
		foreach (id in this.m.StartingEnemies)
		{
			local enemy = ::Tactical.getEntityByID(id);
			if (enemy == null || !enemy.isPlacedOnMap() || enemy.getTile().getDistanceTo(actor.getTile()) <= 1 || this.m.Targets.find(id) != null) continue;
			local mark = enemy.getSkills().getSkillByID("effects.bh_reentering_stage_mark");
			this.m.Targets.push(id);
			this.m.MarkedRounds[id] <- ::Time.getRound();
			if (mark == null)
			{
				mark = this.new("scripts/skills/effects/bh_reentering_stage_mark_effect");
				enemy.getSkills().add(mark);
			}
			mark.addSource(actor);
			::Brotherhood.logSwashbucklerTest(actor, "Re-entering Stage marked " + enemy.getName() + " after leaving their Zone of Control.");
		}
		this.m.StartingEnemies.clear();
	}
	function onAnySkillUsed( _skill, _target, _properties ) { if (_target != null && _skill.isAttack() && !_skill.isRanged() && this.m.Targets.find(_target.getID()) != null) { _properties.DamageTotalMult *= 1.25; ::Brotherhood.logSwashbucklerTest(this.getContainer().getActor(), "Re-entering Stage applied +25% melee damage against " + _target.getName() + "."); } }
	function onCombatFinished() { this.clearMarks(); this.m.StartingEnemies.clear(); this.m.MarkedRounds.clear(); this.skill.onCombatFinished(); }
});
