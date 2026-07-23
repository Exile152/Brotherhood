this.perk_bh_overwhelm <- this.inherit("scripts/skills/skill", {
	m = {
		SkillCount = -1,
		TargetIDs = []
	},
	function create()
	{
		this.m.TargetIDs = [];
		this.m.ID = "perk.bh_overwhelm";
		this.m.Name = "Overwhelm";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.overwhelm", "ui/perks/perk_62.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function tryApply( _target )
	{
		local actor = this.getContainer().getActor();
		local active = this.Tactical.TurnSequenceBar.getActiveEntity();
		if (active == null || active.getID() != actor.getID()) return;
		if (_target == null || !_target.isAlive() || _target.isDying() || _target.isAlliedWith(actor)) return;
		if (_target.isTurnStarted() || _target.isTurnDone()) return;
		if (this.m.SkillCount != this.Const.SkillCounter)
		{
			this.m.SkillCount = this.Const.SkillCounter;
			this.m.TargetIDs.clear();
		}
		if (this.m.TargetIDs.find(_target.getID()) != null) return;
		this.m.TargetIDs.push(_target.getID());
		_target.getSkills().add(this.new("scripts/skills/effects/bh_overwhelmed_effect"));
		::Brotherhood.logFleshcraftMechanic("OVERWHELM", actor, "Applied Overwhelmed to " + _target.getName() + ".");
	}
	function onTargetHit( _skill, _target, _bodyPart, _damageHitpoints, _damageArmor )
	{
		this.tryApply(_target);
	}
	function onTargetMissed( _skill, _target )
	{
		this.tryApply(_target);
	}
	function resetTracking()
	{
		this.m.SkillCount = -1;
		this.m.TargetIDs.clear();
	}
	function onCombatStarted() { this.resetTracking(); }
	function onCombatFinished() { this.resetTracking(); this.skill.onCombatFinished(); }
});
