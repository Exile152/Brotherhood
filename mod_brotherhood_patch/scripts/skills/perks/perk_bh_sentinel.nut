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
	function describeZoneOfControlFailure( _attacker )
	{
		local actor = this.getContainer().getActor();
		if (_attacker == null || actor == null || !actor.isPlacedOnMap())
			return "sentinel is not placed on the map";
		if (_attacker.isAlliedWith(actor))
			return "attacker is allied";

		local aoo = actor.getSkills().getAttackOfOpportunity();
		if (aoo == null)
			return "no attack of opportunity (need a melee weapon that can make free attacks)";
		if (!actor.hasZoneOfControl())
			return "cannot exert Zone of Control right now (stunned, fleeing, or no usable attack of opportunity)";

		local actorTile = actor.getTile();
		local attackerTile = _attacker.getTile();
		if (actorTile == null || attackerTile == null)
			return "missing tiles";

		local distance = attackerTile.getDistanceTo(actorTile);
		if (distance != 1)
			return "attacker is " + distance + " tiles away (must be adjacent)";

		if (this.Math.abs(attackerTile.Level - actorTile.Level) > 1)
			return "attacker is adjacent but height difference blocks Zone of Control";

		if (!actor.isExertingZoneOfControl())
		{
			actor.setZoneOfControl(actorTile, true);
			if (!actor.isExertingZoneOfControl())
				return "adjacent but not currently exerting Zone of Control";
		}
		return null;
	}
	function isAttackerInZoneOfControl( _attacker )
	{
		return this.describeZoneOfControlFailure(_attacker) == null;
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
		local zocFailure = this.describeZoneOfControlFailure(_attacker);
		if (zocFailure != null)
		{
			::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Declined a counter against " + _attacker.getName() + "; " + zocFailure + ".");
			return;
		}
		local skill = actor.getSkills().getAttackOfOpportunity();
		if (skill == null || !::Brotherhood.canUseSkillForFreeOnTile(skill, _attacker.getTile()))
		{
			::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Declined a counter against " + _attacker.getName() + "; " + (skill == null ? "no attack of opportunity is available" : skill.getName() + " cannot be used on that tile") + ".");
			return;
		}
		this.m.UsedThisTurn = true;
		::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Will counter " + _attacker.getName() + " for attacking " + _target.getName() + " in Zone of Control.");
		// Beat after the enemy hit resolves so the counter reads as a separate strike.
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 550, this.resolveCounter.bindenv(this), {
			Attacker = _attacker,
			Target = _target,
			Skill = skill
		});
	}
	function resolveCounter( _tag )
	{
		local actor = this.getContainer().getActor();
		local attacker = _tag.Attacker;
		local skill = _tag.Skill;
		if (actor == null || !actor.isAlive() || actor.isDying() || !actor.isPlacedOnMap()) return;
		if (attacker == null || !attacker.isAlive() || attacker.isDying() || !attacker.isPlacedOnMap()) return;
		if (skill == null || skill.getContainer() == null) skill = actor.getSkills().getAttackOfOpportunity();
		if (skill == null || !::Brotherhood.canUseSkillForFreeOnTile(skill, attacker.getTile()))
		{
			::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Counter against " + attacker.getName() + " failed; attack of opportunity no longer usable.");
			return;
		}
		skill.useForFree(attacker.getTile());
		if (actor.isPlacedOnMap()) this.spawnIcon("perk_05", actor.getTile());
		local victimName = _tag.Target != null ? _tag.Target.getName() : "their target";
		::Brotherhood.logFleshcraftMechanic("SENTINEL", actor, "Made a free attack against " + attacker.getName() + " for attacking " + victimName + " in Zone of Control.");
	}
});
