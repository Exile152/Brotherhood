this.perk_bh_all_eyes_on_me <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_all_eyes_on_me";
		this.m.Name = "All Eyes on Me";
		this.m.Description = ::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.lone_wolf", "ui/perks/perk_61.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function countAdjacentEnemies()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 0;

		local tile = actor.getTile();
		local count = 0;
		for (local i = 0; i < 6; ++i)
		{
			if (!tile.hasNextTile(i)) continue;
			local next = tile.getNextTile(i);
			if (next.IsOccupiedByActor && next.getEntity() != null && next.getEntity().isAlive() && !next.getEntity().isAlliedWith(actor)) ++count;
		}
		return count;
	}

	function getDamageBonus()
	{
		return ::Math.max(0, this.countAdjacentEnemies() - 1) * 5;
	}

	function isHidden()
	{
		return this.getDamageBonus() == 0;
	}

	function getDescription()
	{
		local enemies = this.countAdjacentEnemies();
		return "The crowd roars as " + enemies + " enemies close in. Deal " + ::MSU.Text.colorPositive("+" + this.getDamageBonus() + "%") + " damage.";
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;
		local count = this.countAdjacentEnemies();
		if (count <= 1) return;
		local bonus = (count - 1) * 0.05;
		_properties.DamageTotalMult *= 1.0 + bonus;
		::Brotherhood.logArchetypeTest("ALL EYES ON ME", this.getContainer().getActor(), "Applied +" + (bonus * 100) + "% damage for " + count + " adjacent enemies.");
	}
});
