this.perk_bh_opening_metal <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_opening_metal";
		this.m.Name = "Opening Metal";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.executioner", "ui/perks/perk_16.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function getMarkID( _target )
	{
		return _target == null ? null : "effects.bh_opening_metal." + _target.getID();
	}
	function onTargetHit( _skill, _target, _bodyPart, _damage, _armorDamage )
	{
		if (_skill == null || !_skill.isAttack() || _target == null) return;
		local actor = this.getContainer().getActor();
		local id = this.getMarkID(_target);
		if (_target.getSkills().hasSkill(id)) _target.getSkills().removeByID(id);
		local effect = this.new("scripts/skills/effects/bh_opening_metal_effect");
		effect.configure(actor, _target.getID());
		_target.getSkills().add(effect);
		_target.setDirty(true);
		::Brotherhood.logFleshcraftMechanic("OPENING METAL", actor, "Marked " + _target.getName() + " for ally follow-up damage.");
	}
});
