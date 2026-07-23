this.perk_bh_sentinel <- this.inherit("scripts/skills/skill", {
	m = { UsedThisTurn = false },
	function create()
	{
		this.m.ID = "perk.bh_sentinel";
		this.m.Name = "Sentinel";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.underdog", "ui/perks/perk_05.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onTurnStart()
	{
		this.m.UsedThisTurn = false;
	}
	function isAttackerInZoneOfControl( _attacker )
	{
		local actor = this.getContainer().getActor();
		if (_attacker == null || actor == null || !actor.isPlacedOnMap() || !actor.hasZoneOfControl()) return false;
		local actorTile = actor.getTile();
		local attackerTile = _attacker.getTile();
		if (actorTile == null || attackerTile == null) return false;
		if (_attacker.isAlliedWith(actor)) return false;
		if (attackerTile.getDistanceTo(actorTile) != 1) return false;
		return actor.isExertingZoneOfControl();
	}
	function tryCounter( _attacker, _target )
	{
		if (_attacker == null || _target == null) return;
		local actor = this.getContainer().getActor();
		if (_attacker == actor || _target == actor || _attacker.isAlliedWith(actor)) return;
		if (this.m.UsedThisTurn)
		{
			::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Declined a counter against " + _attacker.getName() + "; already countered this turn.");
			return;
		}
		if (!this.isAttackerInZoneOfControl(_attacker))
		{
			::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Declined a counter against " + _attacker.getName() + "; not an adjacent enemy inside an exerted Zone of Control.");
			return;
		}
		local skill = actor.getSkills().getAttackOfOpportunity();
		if (skill == null || !skill.isUsableOn(_attacker.getTile()))
		{
			::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Declined a counter against " + _attacker.getName() + "; " + (skill == null ? "no attack of opportunity is available" : skill.getName() + " is not usable on that tile") + ".");
			return;
		}
		this.m.UsedThisTurn = true;
		skill.useForFree(_attacker.getTile());
		if (actor.isPlacedOnMap()) this.spawnIcon("perk_05", actor.getTile());
		::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Made a free attack against " + _attacker.getName() + " for attacking " + _target.getName() + " in Zone of Control.");
	}
});
