this.bh_disrupt_effect <- this.inherit("scripts/skills/skill", {
	m = { SourceID = 0 },

	function create()
	{
		this.m.ID = "effects.bh_disrupt";
		this.m.Name = "Disrupted";
		this.m.Description = "This character deals 15% less damage until the disrupting enemy's next turn.";
		this.m.Icon = "ui/perks/bh_shock.png";
		this.m.IconMini = "status_effect_74_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function setSourceID( _sourceID )
	{
		this.m.SourceID = _sourceID;
		this.m.ID = "effects.bh_disrupt." + _sourceID;
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 0.85;
	}
});
