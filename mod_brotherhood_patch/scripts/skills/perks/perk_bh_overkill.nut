this.perk_bh_overkill <- this.inherit("scripts/skills/skill", {
	m = { TargetID = null, TurnsRemaining = 0 },
	function create()
	{
		this.m.ID = "perk.bh_overkill";
		this.m.Name = "Overkill";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.killing_frenzy", "ui/perks/perk_03.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onTargetHit( _skill, _target, _bodyPart, _damage, _armorDamage )
	{
		if (_skill == null || !_skill.isAttack() || _target == null) return;
		local renewed = this.m.TargetID == _target.getID() && this.m.TurnsRemaining > 0;
		this.m.TargetID = _target.getID();
		this.m.TurnsRemaining = 2;
		::Brotherhood.logFleshcraftMechanic("OVERKILL", this.getContainer().getActor(), (renewed ? "Refreshed" : "Started") + " the damage chain on " + _target.getName() + " for 2 turns.");
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _target == null || this.m.TargetID != _target.getID() || this.m.TurnsRemaining <= 0) return;
		_properties.DamageTotalMult *= 1.25;
		::Brotherhood.logFleshcraftMechanic("OVERKILL", this.getContainer().getActor(), "Applied +25% damage against chained target " + _target.getName() + ".");
	}
	function onTurnEnd()
	{
		if (this.m.TurnsRemaining <= 0) return;
		--this.m.TurnsRemaining;
		if (this.m.TurnsRemaining <= 0)
		{
			::Brotherhood.logFleshcraftMechanic("OVERKILL", this.getContainer().getActor(), "Damage chain expired.");
			this.m.TargetID = null;
		}
	}
	function onCombatFinished()
	{
		// Entity IDs are only unique within a battle, so a live chain must never
		// survive into the next one.
		this.m.TargetID = null;
		this.m.TurnsRemaining = 0;
		this.skill.onCombatFinished();
	}
});
