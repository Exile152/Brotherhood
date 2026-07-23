this.bh_flagellant_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},

	function create()
	{
		this.injury.create();
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.IsContentWithReserve = false;
	}

	function getBonusTooltip()
	{
		return [];
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		foreach (entry in this.getBonusTooltip()) ret.push(entry);
		this.addTooltipHint(ret);
		return ret;
	}

	function applyFlagellantBonus( _properties )
	{
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		this.applyFlagellantBonus(_properties);
	}
});
