this.perk_bh_brute_force <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_brute_force";
		this.m.Name = "Brute Force";
		this.m.Description = ::Brotherhood.getBruteLaborerTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_brute_force.png";
		this.m.IconDisabled = "ui/perks/bh_brute_force_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDamageMult *= 1.05;
	}

	function onAdded()
	{
		::Brotherhood.logArchetypeTest("BRUTE FORCE", this.getContainer().getActor(), "Persistent +5% melee damage added to the displayed damage range.");
	}
});
