this.perk_bh_prepared <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_prepared";
		this.m.Name = "Prepared";
		this.m.Description = ::Brotherhood.getMobilityPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_42.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !::Tactical.isActive() || ::Time.getRound() != 1;
	}

	function onUpdate( _properties )
	{
		if (::Tactical.isActive() && ::Time.getRound() == 1)
		{
			_properties.Initiative += 25;
		}
	}

	function onCombatStarted()
	{
		this.getContainer().update();
	}

	function onTurnStart()
	{
		this.getContainer().update();
	}
});
