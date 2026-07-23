this.perk_bh_sturdy <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		IsResolvingAttack = false
	},
	function create()
	{
		this.m.ID = "perk.bh_sturdy";
		this.m.Name = "Sturdy";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_06.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function onNewRound()
	{
		this.m.IsSpent = false;
		this.m.IsResolvingAttack = false;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		this.m.IsResolvingAttack = _skill != null && _skill.isAttack();
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (this.m.IsSpent || !this.m.IsResolvingAttack || _damageHitpoints <= 0) return;

		local actor = this.getContainer().getActor();
		local cap = this.Math.floor(actor.getHitpointsMax() * 0.40);
		local prevented = this.Math.max(0, _damageHitpoints - cap);
		if (prevented > 0) actor.m.Hitpoints += prevented;

		this.m.IsSpent = true;
		this.m.IsResolvingAttack = false;
	}
});
