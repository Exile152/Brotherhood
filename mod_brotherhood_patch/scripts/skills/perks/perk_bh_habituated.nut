this.perk_bh_habituated <- this.inherit("scripts/skills/skill", {
	m = {
		LostHitpointsEarly = false
	},
	function create()
	{
		this.m.ID = "perk.bh_habituated";
		this.m.Name = "Habituated";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_34.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !::Tactical.isActive() || ::Time.getRound() < 4;
	}

	function onCombatStarted()
	{
		this.m.LostHitpointsEarly = false;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (::Time.getRound() <= 3 && _damageHitpoints > 0)
		{
			this.m.LostHitpointsEarly = true;
		}
	}

	function onNewRound()
	{
		this.getContainer().update();
	}

	function onUpdate( _properties )
	{
		if (::Tactical.isActive() && ::Time.getRound() >= 4)
		{
			local bonus = this.m.LostHitpointsEarly ? 10 : 5;
			_properties.MeleeDefense += bonus;
			_properties.RangedDefense += bonus;
		}
	}
});
