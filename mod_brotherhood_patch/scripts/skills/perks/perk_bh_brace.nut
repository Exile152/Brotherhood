this.perk_bh_brace <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_brace";
		this.m.Name = "Brace";
		this.m.Description = ::Brotherhood.getSurvivalPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_35.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.getAdjacentEnemyCount() < 3;
	}

	function getAdjacentEnemyCount()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 0;

		local tile = actor.getTile();
		local count = 0;

		for (local i = 0; i < 6; ++i)
		{
			if (!tile.hasNextTile(i)) continue;

			local next = tile.getNextTile(i);
			if (next.IsOccupiedByActor && this.Math.abs(next.Level - tile.Level) <= 1)
			{
				local other = next.getEntity();
				if (other.isAlive() && !other.isNonCombatant() && !other.isAlliedWith(actor))
				{
					++count;
				}
			}
		}

		return count;
	}

	function getReduction()
	{
		local enemies = this.getAdjacentEnemyCount();
		if (enemies < 3) return 0.0;
		return 0.15 + (enemies - 3) * 0.05;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker == null || _skill == null || !_skill.isAttack()) return;

		local mult = 1.0 - this.getReduction();
		_properties.DamageReceivedRegularMult *= mult;
		_properties.DamageReceivedArmorMult *= mult;
	}
});
