this.perk_bh_disrupt <- this.inherit("scripts/skills/skill", {
	m = { AffectedEntityIDs = [] },

	function create()
	{
		this.m.ID = "perk.bh_disrupt";
		this.m.Name = "Disrupt";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.overwhelm", "ui/perks/perk_42.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function getEffectID()
	{
		return "effects.bh_disrupt." + this.getContainer().getActor().getID();
	}

	function applyTo( _skill, _target )
	{
		if (_skill == null || !_skill.isAttack() || _target == null || !_target.isAlive()) return;
		local actor = this.getContainer().getActor();
		if (_target.isAlliedWith(actor)) return;

		local targetID = _target.getID();
		local effectID = this.getEffectID();
		_target.getSkills().removeByID(effectID);
		local effect = this.new("scripts/skills/effects/bh_disrupt_effect");
		effect.setSourceID(actor.getID());
		_target.getSkills().add(effect);
		if (this.m.AffectedEntityIDs.find(targetID) == null) this.m.AffectedEntityIDs.push(targetID);
		::Brotherhood.logFleshcraftMechanic("DISRUPT", actor, "Applied -15% damage to " + _target.getName() + " with " + _skill.getName() + ".");
	}

	function clearEffects()
	{
		local effectID = this.getEffectID();
		foreach (entityID in this.m.AffectedEntityIDs)
		{
			local entity = ::Tactical.isActive() ? ::Tactical.getEntityByID(entityID) : null;
			if (entity != null) entity.getSkills().removeByID(effectID);
		}
		this.m.AffectedEntityIDs.clear();
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) { this.applyTo(_skill, _targetEntity); }
	function onTargetMissed( _skill, _targetEntity ) { this.applyTo(_skill, _targetEntity); }
	function onTurnStart() { this.clearEffects(); }
	function onRemoved() { this.clearEffects(); }
	function onDeath( _fatalityType ) { this.clearEffects(); }
	function onCombatStarted() { this.m.AffectedEntityIDs.clear(); }
	function onCombatFinished() { this.clearEffects(); this.skill.onCombatFinished(); }
});
