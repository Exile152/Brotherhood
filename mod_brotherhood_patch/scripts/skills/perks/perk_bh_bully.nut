this.perk_bh_bully <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_bully";
		this.m.Name = "Bully";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.fearsome", "ui/perks/perk_03.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack() || _target == null) return;
		local actor = this.getContainer().getActor();
		if (actor.getMoraleState() > _target.getMoraleState())
		{
			_properties.MeleeSkill += 10;
			_properties.RangedSkill += 10;
			::Brotherhood.logFleshcraftMechanic("BULLY", actor, "Applied +10% hit chance against " + _target.getName() + " with lower morale.");
		}
	}
	function onGetHitFactors( _skill, _targetTile, _tooltip )
	{
		if (_skill == null || !_skill.isAttack() || _targetTile == null || !_targetTile.IsOccupiedByActor) return;
		local actor = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		if (actor.getMoraleState() > target.getMoraleState())
			_tooltip.push({ icon = "ui/tooltips/positive.png", text = ::MSU.Text.colorPositive("+10% ") + this.getName() });
	}
});
