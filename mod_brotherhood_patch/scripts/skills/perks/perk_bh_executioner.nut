// Dormant perk: implemented and ready, but deliberately not registered or
// assigned to any perk group until the Executioner tree pass goes live.
this.perk_bh_executioner <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_executioner";
		this.m.Name = "Executioner";
		this.m.Description = ::Brotherhood.getExecutionerTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_16.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function isExecutionerTarget( _targetEntity )
	{
		if (_targetEntity == null) return false;

		return _targetEntity.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && this.isExecutionerTarget(_targetEntity))
		{
			_properties.DamageTotalMult *= 1.20;
			::Brotherhood.logExecutionerTest(this.getContainer().getActor(), "Executioner applied +20% damage against injured target " + _targetEntity.getName() + ".");
		}
		else if (_skill.isAttack() && _targetEntity != null) ::Brotherhood.logExecutionerTest(this.getContainer().getActor(), "Executioner did not trigger against uninjured target " + _targetEntity.getName() + ".");
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill.isAttack() && this.isExecutionerTarget(_targetEntity))
		{
			this.spawnIcon("perk_16", this.getContainer().getActor().getTile());
		}
	}
});
