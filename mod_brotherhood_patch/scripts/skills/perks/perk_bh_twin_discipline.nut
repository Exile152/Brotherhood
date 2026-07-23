this.perk_bh_twin_discipline <- this.inherit("scripts/skills/skill", {
	m = { Marks = [] },
	function create()
	{
		this.m.ID = "perk.bh_twin_discipline";
		this.m.Name = "Twin Discipline";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.dodge", "ui/perks/perk_05.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function getMarkID()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner == null ? null : "effects.bh_twin_discipline." + owner.getID();
	}
	function removeMarkFromTarget( _targetID )
	{
		local markID = this.getMarkID();
		if (markID == null) return;
		local entity = this.Tactical.getEntityByID(_targetID);
		if (entity == null || !entity.getSkills().hasSkill(markID)) return;
		entity.getSkills().removeByID(markID);
		entity.setDirty(true);
	}
	function applyMarkToTarget( _target )
	{
		if (_target == null) return;
		local owner = this.getContainer().getActor();
		local markID = this.getMarkID();
		if (markID == null) return;
		if (!_target.getSkills().hasSkill(markID))
		{
			local effect = this.new("scripts/skills/effects/bh_twin_discipline_mark_effect");
			effect.configure(owner);
			_target.getSkills().add(effect);
		}
		_target.setDirty(true);
	}
	function rememberHit( _target )
	{
		if (_target == null) return;
		local id = _target.getID();
		local existing = this.m.Marks.find(id);
		if (existing != null) this.m.Marks.remove(existing);
		this.m.Marks.push(id);
		local dropped = null;
		while (this.m.Marks.len() > 2)
		{
			dropped = this.m.Marks.remove(0);
			this.removeMarkFromTarget(dropped);
		}
		this.applyMarkToTarget(_target);
		::Brotherhood.logFleshcraftMechanic("TWIN DISCIPLINE", this.getContainer().getActor(), "Marked " + _target.getName() + (dropped == null ? "" : "; oldest mark dropped") + ". Marks now hold " + this.m.Marks.len() + " enemy or enemies.");
	}
	function isMarked( _target )
	{
		if (_target == null) return false;
		local markID = this.getMarkID();
		return markID != null && _target.getSkills().hasSkill(markID);
	}
	function onTargetHit( _skill, _target, _bodyPart, _damage, _armorDamage )
	{
		if (_skill == null || !_skill.isAttack() || _target == null) return;
		this.rememberHit(_target);
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _target == null || !this.isMarked(_target)) return;
		local actor = this.getContainer().getActor();
		local otherMarked = null;
		foreach (id in this.m.Marks)
		{
			if (id == _target.getID()) continue;
			local entity = this.Tactical.getEntityByID(id);
			if (entity != null && entity.isAlive()) { otherMarked = entity; break; }
		}
		if (otherMarked == null) return;
		_properties.DamageTotalMult *= 1.10;
		::Brotherhood.logFleshcraftMechanic("TWIN DISCIPLINE", actor, "Applied +10% damage against marked " + _target.getName() + ".");
	}
	function onCombatFinished()
	{
		foreach (id in this.m.Marks) this.removeMarkFromTarget(id);
		this.m.Marks = [];
		this.skill.onCombatFinished();
	}
});
