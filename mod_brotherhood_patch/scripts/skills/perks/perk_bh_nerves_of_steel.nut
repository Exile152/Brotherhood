this.perk_bh_nerves_of_steel <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_nerves_of_steel";
		this.m.Name = "Nerves of Steel";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.indomitable", "ui/perks/perk_11.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsHidden = false;
	}
	function isHidden()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor == null || !this.Tactical.isActive() || !actor.isPlacedOnMap();
	}
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "Receive 15% less damage." },
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "Damage taken reduced by [color=" + this.Const.UI.Color.PositiveValue + "]15%[/color]." }
		];
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
