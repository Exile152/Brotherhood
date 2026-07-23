if (!("Brotherhood" in getroottable())) return;

// Runtime diagnostics are restricted to the exact current Obsidian allowlist.
// Old perk scripts remain registered for save compatibility, but are not
// reported as current perks by this module.
::Brotherhood.getPerkDebugActor <- function( _skill )
{
	if (_skill == null || !("getContainer" in _skill)) return null;
	local container = _skill.getContainer();
	return container == null || !("getActor" in container) ? null : container.getActor();
}

::Brotherhood.getPerkDebugEntityName <- function( _entity )
{
	return _entity == null ? "none" : (("getName" in _entity) ? _entity.getName() : "unknown entity");
}

::Brotherhood.getPerkDebugSkillID <- function( _skill )
{
	return _skill == null ? "none" : (("getID" in _skill) ? _skill.getID() : "unknown skill");
}

::Brotherhood.logActivePerkEvent <- function( _perk, _event, _details = null )
{
	if (!::Brotherhood.TestingMode || !::Brotherhood.PerkDebugLogging || _perk == null) return;

	local perkID = _perk.getID();
	if (!::Brotherhood.isActiveObsidianPerk(perkID)) return;

	local actor = ::Brotherhood.getPerkDebugActor(_perk);
	// A skill container can be only partially reconstructed while an old save or
	// an enemy is being deserialized. Diagnostics must never interfere with load.
	if (actor == null || !("isPlayerControlled" in actor) || !actor.isPlayerControlled() || !("getName" in actor)) return;
	local actorName = actor.getName();
	local text = "[Brotherhood][PERK][" + perkID + "][" + _event + "] " + actorName;
	if (_details != null && _details != "") text += ": " + _details;
	::logInfo(text);

	if (::Brotherhood.PerkDebugMirrorToCombatLog && ::Tactical.isActive())
	{
		local active = ::Tactical.TurnSequenceBar.getActiveEntity();
		if (active != null && active.isPlayerControlled()) ::Tactical.EventLog.log(text);
	}
}

::Brotherhood.getActivePerkIDByNote <- function( _note )
{
	if (typeof _note != "string") return null;
	local wanted = _note.toupper();
	foreach (entry in ::Brotherhood.ActiveObsidianPerks)
	{
		if (entry.Note.toupper() == wanted) return entry.ID;
	}
	return null;
}

::Brotherhood.logActivePerkMechanic <- function( _note, _actor, _message )
{
	if (!::Brotherhood.TestingMode || !::Brotherhood.PerkDebugLogging) return;
	local perkID = ::Brotherhood.getActivePerkIDByNote(_note);
	if (perkID == null) return;

	local actorName = _actor == null ? "unknown actor" : _actor.getName();
	::logInfo("[Brotherhood][PERK][" + perkID + "][MECHANIC] " + actorName + ": " + _message);
}

::Brotherhood.initializePerkDebugLogging <- function()
{
	::Brotherhood.HooksMod.hook("scripts/skills/skill_container", function(q) {
		q.add = @(__original) { function add( _skill, _order = 0 )
		{
			__original(_skill, _order);
			::Brotherhood.logActivePerkEvent(_skill, "ADDED", "entered the skill container");
		}}.add;

		q.remove = @(__original) { function remove( _skill )
		{
			::Brotherhood.logActivePerkEvent(_skill, "REMOVED", "left the skill container");
			return __original(_skill);
		}}.remove;

		q.onCombatStarted = @(__original) { function onCombatStarted()
		{
			foreach (skill in this.m.Skills)
			{
				if (skill != null && !skill.isGarbage()) ::Brotherhood.logActivePerkEvent(skill, "COMBAT_ROSTER", "present when combat started");
			}
			return __original();
		}}.onCombatStarted;
	});

	::Brotherhood.HooksMod.hookTree("scripts/skills/skill", function(q) {
		// q.contains(..., false) is intentional: trace only callbacks implemented
		// by this exact perk class, not inherited no-op callbacks.
		if (q.contains("onAdded")) q.onAdded = @(__original) { function onAdded()
		{
			::Brotherhood.logActivePerkEvent(this, "onAdded");
			return __original();
		}}.onAdded;

		if (q.contains("onRemoved")) q.onRemoved = @(__original) { function onRemoved()
		{
			::Brotherhood.logActivePerkEvent(this, "onRemoved");
			return __original();
		}}.onRemoved;

		if (q.contains("onCombatStarted")) q.onCombatStarted = @(__original) { function onCombatStarted()
		{
			::Brotherhood.logActivePerkEvent(this, "onCombatStarted");
			return __original();
		}}.onCombatStarted;

		if (q.contains("onCombatFinished")) q.onCombatFinished = @(__original) { function onCombatFinished()
		{
			::Brotherhood.logActivePerkEvent(this, "onCombatFinished");
			return __original();
		}}.onCombatFinished;

		if (q.contains("onTurnStart")) q.onTurnStart = @(__original) { function onTurnStart()
		{
			::Brotherhood.logActivePerkEvent(this, "onTurnStart");
			return __original();
		}}.onTurnStart;

		if (q.contains("onTurnEnd")) q.onTurnEnd = @(__original) { function onTurnEnd()
		{
			::Brotherhood.logActivePerkEvent(this, "onTurnEnd");
			return __original();
		}}.onTurnEnd;

		if (q.contains("onNewRound")) q.onNewRound = @(__original) { function onNewRound()
		{
			::Brotherhood.logActivePerkEvent(this, "onNewRound");
			return __original();
		}}.onNewRound;

		if (q.contains("onWaitTurn")) q.onWaitTurn = @(__original) { function onWaitTurn()
		{
			::Brotherhood.logActivePerkEvent(this, "onWaitTurn");
			return __original();
		}}.onWaitTurn;

		if (q.contains("onAnySkillUsed")) q.onAnySkillUsed = @(__original) { function onAnySkillUsed( _skill, _targetEntity, _properties )
		{
			::Brotherhood.logActivePerkEvent(this, "onAnySkillUsed", "skill=" + ::Brotherhood.getPerkDebugSkillID(_skill) + "; target=" + ::Brotherhood.getPerkDebugEntityName(_targetEntity));
			return __original(_skill, _targetEntity, _properties);
		}}.onAnySkillUsed;

		if (q.contains("onAnySkillExecutedFully")) q.onAnySkillExecutedFully = @(__original) { function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
		{
			::Brotherhood.logActivePerkEvent(this, "onAnySkillExecutedFully", "skill=" + ::Brotherhood.getPerkDebugSkillID(_skill) + "; target=" + ::Brotherhood.getPerkDebugEntityName(_targetEntity) + "; free=" + _forFree.tostring());
			return __original(_skill, _targetTile, _targetEntity, _forFree);
		}}.onAnySkillExecutedFully;

		if (q.contains("onBeingAttacked")) q.onBeingAttacked = @(__original) { function onBeingAttacked( _attacker, _skill, _properties )
		{
			::Brotherhood.logActivePerkEvent(this, "onBeingAttacked", "attacker=" + ::Brotherhood.getPerkDebugEntityName(_attacker) + "; skill=" + ::Brotherhood.getPerkDebugSkillID(_skill));
			return __original(_attacker, _skill, _properties);
		}}.onBeingAttacked;

		if (q.contains("onBeforeDamageReceived")) q.onBeforeDamageReceived = @(__original) { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
		{
			::Brotherhood.logActivePerkEvent(this, "onBeforeDamageReceived", "attacker=" + ::Brotherhood.getPerkDebugEntityName(_attacker) + "; skill=" + ::Brotherhood.getPerkDebugSkillID(_skill));
			return __original(_attacker, _skill, _hitInfo, _properties);
		}}.onBeforeDamageReceived;

		if (q.contains("onDamageReceived")) q.onDamageReceived = @(__original) { function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
		{
			::Brotherhood.logActivePerkEvent(this, "onDamageReceived", "attacker=" + ::Brotherhood.getPerkDebugEntityName(_attacker) + "; hp=" + _damageHitpoints + "; armor=" + _damageArmor);
			return __original(_attacker, _damageHitpoints, _damageArmor);
		}}.onDamageReceived;

		if (q.contains("onBeforeTargetHit")) q.onBeforeTargetHit = @(__original) { function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
		{
			::Brotherhood.logActivePerkEvent(this, "onBeforeTargetHit", "skill=" + ::Brotherhood.getPerkDebugSkillID(_skill) + "; target=" + ::Brotherhood.getPerkDebugEntityName(_targetEntity));
			return __original(_skill, _targetEntity, _hitInfo);
		}}.onBeforeTargetHit;

		if (q.contains("onTargetHit")) q.onTargetHit = @(__original) { function onTargetHit( _skill, _targetEntity, _bodyPart, _damageHitpoints, _damageArmor )
		{
			::Brotherhood.logActivePerkEvent(this, "onTargetHit", "skill=" + ::Brotherhood.getPerkDebugSkillID(_skill) + "; target=" + ::Brotherhood.getPerkDebugEntityName(_targetEntity) + "; hp=" + _damageHitpoints + "; armor=" + _damageArmor);
			return __original(_skill, _targetEntity, _bodyPart, _damageHitpoints, _damageArmor);
		}}.onTargetHit;

		if (q.contains("onTargetMissed")) q.onTargetMissed = @(__original) { function onTargetMissed( _skill, _targetEntity )
		{
			::Brotherhood.logActivePerkEvent(this, "onTargetMissed", "skill=" + ::Brotherhood.getPerkDebugSkillID(_skill) + "; target=" + ::Brotherhood.getPerkDebugEntityName(_targetEntity));
			return __original(_skill, _targetEntity);
		}}.onTargetMissed;

		if (q.contains("onTargetKilled")) q.onTargetKilled = @(__original) { function onTargetKilled( _targetEntity, _skill )
		{
			::Brotherhood.logActivePerkEvent(this, "onTargetKilled", "skill=" + ::Brotherhood.getPerkDebugSkillID(_skill) + "; target=" + ::Brotherhood.getPerkDebugEntityName(_targetEntity));
			return __original(_targetEntity, _skill);
		}}.onTargetKilled;

		if (q.contains("onMissed")) q.onMissed = @(__original) { function onMissed( _attacker, _skill )
		{
			::Brotherhood.logActivePerkEvent(this, "onMissed", "attacker=" + ::Brotherhood.getPerkDebugEntityName(_attacker) + "; skill=" + ::Brotherhood.getPerkDebugSkillID(_skill));
			return __original(_attacker, _skill);
		}}.onMissed;

		if (q.contains("onOtherActorDeath")) q.onOtherActorDeath = @(__original) { function onOtherActorDeath( _killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType )
		{
			::Brotherhood.logActivePerkEvent(this, "onOtherActorDeath", "killer=" + ::Brotherhood.getPerkDebugEntityName(_killer) + "; victim=" + ::Brotherhood.getPerkDebugEntityName(_victim) + "; skill=" + ::Brotherhood.getPerkDebugSkillID(_skill));
			return __original(_killer, _victim, _skill, _deathTile, _corpseTile, _fatalityType);
		}}.onOtherActorDeath;

		if (q.contains("onMovementStarted")) q.onMovementStarted = @(__original) { function onMovementStarted( _tile, _numTiles )
		{
			::Brotherhood.logActivePerkEvent(this, "onMovementStarted", "tiles=" + _numTiles);
			return __original(_tile, _numTiles);
		}}.onMovementStarted;

		if (q.contains("onMovementFinished")) q.onMovementFinished = @(__original) { function onMovementFinished()
		{
			::Brotherhood.logActivePerkEvent(this, "onMovementFinished");
			return __original();
		}}.onMovementFinished;

		if (q.contains("onMovementStep")) q.onMovementStep = @(__original) { function onMovementStep( _tile, _levelDifference )
		{
			::Brotherhood.logActivePerkEvent(this, "onMovementStep", "level_difference=" + _levelDifference);
			return __original(_tile, _levelDifference);
		}}.onMovementStep;
	});
}
