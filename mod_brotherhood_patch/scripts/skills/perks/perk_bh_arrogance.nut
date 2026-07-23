this.perk_bh_arrogance <- this.inherit("scripts/skills/skill", {
	m = { WasActive = false },
	function create()
	{
		this.m.ID = "perk.bh_arrogance";
		this.m.Name = "Arrogance";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.lone_wolf", "ui/perks/perk_61.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onUpdate( _properties )
	{
		local active = this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Confident;
		if (active)
		{
			local extra = 1.2 / 1.1;
			_properties.MeleeSkillMult *= extra;
			_properties.RangedSkillMult *= extra;
			_properties.MeleeDefenseMult *= extra;
			_properties.RangedDefenseMult *= extra;
		}
		if (active != this.m.WasActive)
		{
			local message = active ? "Doubled Confident attribute bonuses to +20%." : "Confident bonus doubling is inactive.";
			::Brotherhood.logLatestObsidianTest("ARROGANCE", this.getContainer().getActor(), message);
			this.m.WasActive = active;
		}
	}
});
