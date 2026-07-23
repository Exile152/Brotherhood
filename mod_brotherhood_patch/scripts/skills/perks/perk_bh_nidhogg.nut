this.perk_bh_nidhogg <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_nidhogg";
		this.m.Name = "Nidhogg";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.berserk", "ui/perks/perk_03.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function getMarkID( _target )
	{
		return _target == null ? null : "effects.bh_nidhogg." + _target.getID();
	}
	function markAttacker( _attacker )
	{
		if (_attacker == null) return;
		local id = this.getMarkID(_attacker);
		if (_attacker.getSkills().hasSkill(id)) return;
		local owner = this.getContainer().getActor();
		local effect = this.new("scripts/skills/effects/bh_nidhogg_mark_effect");
		effect.configure(owner, _attacker.getID());
		_attacker.getSkills().add(effect);
		_attacker.setDirty(true);
		::Brotherhood.logFleshcraftMechanic("NIDHOGG", this.getContainer().getActor(), "Marked " + _attacker.getName() + ".");
	}
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		this.markAttacker(_attacker);
	}
	function onTargetHit( _skill, _target, _bodyPart, _damage, _armorDamage )
	{
		if (_skill == null || !_skill.isAttack() || _target == null) return;
		local markID = this.getMarkID(_target);
		if (!_target.getSkills().hasSkill(markID)) return;
		_target.getSkills().removeByID(markID);
		::Brotherhood.logFleshcraftMechanic("NIDHOGG", this.getContainer().getActor(), "Consumed mark on " + _target.getName() + " and will repeat " + _skill.getName() + ".");
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, this.repeatAttack.bindenv(this), { Skill = _skill, Target = _target });
	}
	function repeatAttack( _tag )
	{
		if (_tag.Skill == null || _tag.Target == null || !_tag.Target.isAlive() || _tag.Target.isDying()) return;
		local targetTile = _tag.Target.getTile();
		if (!::Brotherhood.canUseSkillForFreeOnTile(_tag.Skill, targetTile)) return;
		_tag.Skill.useForFree(targetTile);
	}
});
