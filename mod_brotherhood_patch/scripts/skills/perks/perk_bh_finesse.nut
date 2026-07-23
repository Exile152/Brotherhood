this.perk_bh_finesse <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_finesse";
		this.m.Name = "Finesse";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.dodge", "ui/perks/perk_10.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onMissed( _attacker, _skill )
	{
		local actor = this.getContainer().getActor();
		if (_attacker == null || _attacker.isAlliedWith(actor) || _skill == null || !_skill.isAttack()) return;
		local effect = _attacker.getSkills().getSkillByID("effects.bh_disabled_off_hand");
		if (effect == null)
		{
			effect = this.new("scripts/skills/effects/bh_disabled_off_hand_effect");
			_attacker.getSkills().add(effect);
		}
		effect.refreshForNextTurn();
	}
});
