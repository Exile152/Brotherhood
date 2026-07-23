this.perk_bh_bladed_loop <- this.inherit("scripts/skills/skill", {
	m = { Armed = false, MissedByID = null },
	function create()
	{
		this.m.ID = "perk.bh_bladed_loop";
		this.m.Name = "Bladed Loop";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.duelist", "ui/perks/perk_05.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}
	function isHidden()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor == null || !this.Tactical.isActive() || !actor.isPlacedOnMap() || !this.m.Armed;
	}
	function getTooltip()
	{
		local missedName = "an enemy";
		if (this.m.MissedByID != null)
		{
			local missed = this.Tactical.getEntityByID(this.m.MissedByID);
			if (missed != null) missedName = missed.getName();
		}
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "After an enemy misses you in melee, your next melee attack against a different enemy can't miss." },
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "Guaranteed hit ready. [color=" + this.Const.UI.Color.NegativeValue + "]" + missedName + "[/color] cannot be the target." }
		];
	}
	function refreshVisibility()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null) actor.setDirty(true);
	}
	function onMissed( _attacker, _skill )
	{
		if (_attacker == null || _skill == null || _skill.isRanged()) return;
		local actor = this.getContainer().getActor();
		if (_attacker == actor) return;
		if (this.m.Armed && this.m.MissedByID == _attacker.getID()) return;
		this.m.Armed = true;
		this.m.MissedByID = _attacker.getID();
		this.refreshVisibility();
		::Brotherhood.logFleshcraftMechanic("BLADED LOOP", actor, "Armed after " + _attacker.getName() + " missed in melee.");
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (!this.m.Armed || _skill == null || !_skill.isAttack() || _skill.isRanged() || _target == null) return;
		// The guaranteed hit only applies against an enemy other than the one that missed.
		if (_target.getID() == this.m.MissedByID)
		{
			::Brotherhood.logFleshcraftMechanic("BLADED LOOP", this.getContainer().getActor(), "Holding the guaranteed hit; " + _target.getName() + " is the enemy that missed, and it must be spent on a different one.");
			return;
		}
		_properties.MeleeSkill = 999;
		this.m.Armed = false;
		this.m.MissedByID = null;
		this.refreshVisibility();
		::Brotherhood.logFleshcraftMechanic("BLADED LOOP", this.getContainer().getActor(), "Guaranteed the next melee attack against " + _target.getName() + ".");
	}
	function onCombatFinished()
	{
		if (this.m.Armed) ::Brotherhood.logFleshcraftMechanic("BLADED LOOP", this.getContainer() == null ? null : this.getContainer().getActor(), "Combat ended with an unspent guaranteed hit; discarding it.");
		this.m.Armed = false;
		this.m.MissedByID = null;
		this.skill.onCombatFinished();
	}
});
