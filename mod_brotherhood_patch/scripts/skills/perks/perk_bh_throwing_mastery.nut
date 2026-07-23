this.perk_bh_throwing_mastery <- this.inherit("scripts/skills/skill", {
	m = {},

	function create()
	{
		this.m.ID = "perk.bh_throwing_mastery";
		this.m.Name = "Throwing Mastery";
		this.m.Description = ::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.mastery.throwing", "ui/perks/perk_10.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function isThrowingSkill( _skill )
	{
		if (_skill == null || !_skill.isAttack() || !_skill.isRanged()) return false;
		local item = _skill.getItem();
		return item != null
			&& item.isItemType(this.Const.Items.ItemType.Weapon)
			&& item.isWeaponType(this.Const.Items.WeaponType.Throwing);
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInThrowing = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null || !this.isThrowingSkill(_skill)) return;
		local actor = this.getContainer().getActor();
		local distance = actor.getTile().getDistanceTo(_targetEntity.getTile());
		local bonus = 0;
		if (distance == 2)
		{
			_properties.DamageTotalMult *= 1.20;
			bonus = 20;
		}
		else if (distance == 3)
		{
			_properties.DamageTotalMult *= 1.15;
			bonus = 15;
		}
		::Brotherhood.logArchetypeTest("THROWING MASTERY", actor, _skill.getName() + " at " + distance + " tiles received +" + bonus + "% damage; specialized throwing Fatigue reduction is active.");
	}
});
