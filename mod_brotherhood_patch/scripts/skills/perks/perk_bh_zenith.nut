this.perk_bh_zenith <- this.inherit("scripts/skills/skill", {
	m = { HitTargets = [] },
	function create()
	{
		this.m.ID = "perk.bh_zenith";
		this.m.Name = "Zenith";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.dodge", "ui/perks/perk_05.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsHidden = false;
	}
	function isHidden()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor == null || !this.Tactical.isActive() || !actor.isPlacedOnMap();
	}
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "Your first melee hit against each enemy triggers a second attack. Consumed marks appear on those enemies." }
		];
	}
	function getMarkID()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner == null ? null : "effects.bh_zenith." + owner.getID();
	}
	function applyMarkToTarget( _target )
	{
		if (_target == null) return;
		local owner = this.getContainer().getActor();
		local markID = this.getMarkID();
		if (markID == null || _target.getSkills().hasSkill(markID)) return;
		local effect = this.new("scripts/skills/effects/bh_zenith_mark_effect");
		effect.configure(owner);
		_target.getSkills().add(effect);
		_target.setDirty(true);
	}
	function onTargetHit( _skill, _target, _bodyPart, _damage, _armorDamage )
	{
		if (_skill == null || !_skill.isAttack() || _skill.isRanged() || _target == null) return;
		if (this.m.HitTargets.find(_target.getID()) != null) return;
		this.m.HitTargets.push(_target.getID());
		this.applyMarkToTarget(_target);
		::Brotherhood.logFleshcraftMechanic("ZENITH", this.getContainer().getActor(), "First melee hit against " + _target.getName() + "; repeating " + _skill.getName() + ".");
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 150, this.repeatAttack.bindenv(this), { Skill = _skill, Target = _target });
	}
	function repeatAttack( _tag )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (_tag.Skill == null || _tag.Target == null || !_tag.Target.isAlive() || _tag.Target.isDying())
		{
			::Brotherhood.logFleshcraftMechanic("ZENITH", actor, "Second attack cancelled; the target died or is no longer valid.");
			return;
		}
		local targetTile = _tag.Target.getTile();
		if (!::Brotherhood.canUseSkillForFreeOnTile(_tag.Skill, targetTile))
		{
			::Brotherhood.logFleshcraftMechanic("ZENITH", actor, "Second attack cancelled; " + _tag.Skill.getName() + " is not usable on " + _tag.Target.getName() + " right now.");
			return;
		}
		::Brotherhood.logFleshcraftMechanic("ZENITH", actor, "Second attack firing: " + _tag.Skill.getName() + " against " + _tag.Target.getName() + ".");
		if (!_tag.Skill.useForFree(targetTile))
		{
			::Brotherhood.logFleshcraftMechanic("ZENITH", actor, "Second attack rejected by " + _tag.Skill.getName() + ".");
		}
	}
	function onCombatFinished()
	{
		this.m.HitTargets = [];
		this.skill.onCombatFinished();
	}
});
