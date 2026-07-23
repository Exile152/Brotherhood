this.perk_bh_nerves_of_steel <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_nerves_of_steel";
		this.m.Name = "Nerves of Steel";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.indomitable", "ui/perks/perk_11.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 0.85;
	}
	function onCombatStarted()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null) ::Brotherhood.logFleshcraftMechanic("NERVES OF STEEL", actor, "Applying 15% damage reduction; damage morale checks are replaced with one unaffected by missing Hitpoints.");
		this.skill.onCombatStarted();
	}
	// The morale behavior is not a second check added here. Brotherhood rewrites
	// vanilla's own damage-triggered check in fleshcraft_live_module so exactly one
	// check happens, with the missing-Hitpoints scaling removed.
});
