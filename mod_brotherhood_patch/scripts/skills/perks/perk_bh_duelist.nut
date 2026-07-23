this.perk_bh_duelist <- this.inherit("scripts/skills/skill", {
	m = { WasVisible = false },
	function create()
	{
		this.m.ID = "perk.bh_duelist";
		this.m.Name = "Duelist";
		this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_41.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}
	function hasValidHands()
	{
		return ::Brotherhood.hasFleshcraftOneHandedSetup(this.getContainer().getActor());
	}
	function isHidden() { return !this.hasValidHands(); }
	function onUpdate( _properties ) { local visible = this.hasValidHands(); if (visible != this.m.WasVisible) ::Brotherhood.logDuelistTest(this.getContainer().getActor(), "Duelist passive " + (visible ? "activated." : "deactivated; hand condition not met.")); this.m.WasVisible = visible; }
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.isAttack() || !this.hasValidHands()) return;
		local actor = this.getContainer().getActor();
		local bonus = ::Brotherhood.hasExactlyOneAdjacentOpponent(actor) ? 0.40 : 0.20;
		_properties.DamageDirectAdd += bonus;
		::Brotherhood.logFleshcraftMechanic("DUELIST", actor, "Applied " + (bonus * 100).tointeger() + "% armor penetration.");
	}
});
