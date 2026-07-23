this.perk_bh_perfect_thrust <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_perfect_thrust";
		this.m.Name = "Perfect Thrust";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.berserk", "ui/perks/perk_35.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function ensureActive()
	{
		if (this.getContainer() == null) return null;
		local active = this.getContainer().getSkillByID("actives.bh_perfect_thrust");
		if (active == null)
		{
			active = this.new("scripts/skills/actives/bh_perfect_thrust_skill");
			this.getContainer().add(active);
			::Brotherhood.logFleshcraftMechanic("PERFECT THRUST", this.getContainer().getActor(), "Restored the granted active skill.");
		}
		return active;
	}
	function onAdded() { this.ensureActive(); }
	function onCombatStarted() { this.ensureActive(); }
	function onTurnStart() { this.ensureActive(); }
	function onRemoved() { this.getContainer().removeByID("actives.bh_perfect_thrust"); }
	function onUpdate( _properties )
	{
		local active = this.ensureActive();
		if (active != null)
		{
			active.setItem(this.getContainer().getActor().getMainhandItem());
			active.syncSourceSkill();
		}
	}
});
