this.perk_bh_hope <- this.inherit("scripts/skills/skill", {
	m = { LastBonus = 0 },
	function create()
	{
		this.m.ID = "perk.bh_hope";
		this.m.Name = "Hope";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.fortified_mind", "ui/perks/perk_08.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local moraleLevelsBelowSteady = ::Math.max(0, this.Const.MoraleState.Steady - actor.getMoraleState());
		local bonus = moraleLevelsBelowSteady * 15;
		_properties.Bravery += bonus;
		if (bonus != this.m.LastBonus)
		{
			::Brotherhood.logLatestObsidianTest("HOPE", actor, "Morale state " + actor.getMoraleState() + " grants +" + bonus + " Resolve (" + moraleLevelsBelowSteady + " level(s) below Steady).");
			this.m.LastBonus = bonus;
		}
	}
});
