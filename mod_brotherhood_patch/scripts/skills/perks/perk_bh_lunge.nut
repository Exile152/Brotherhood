this.perk_bh_lunge <- this.inherit("scripts/skills/skill", {
	m = { IsSpent = false },

	function create()
	{
		this.m.ID = "perk.bh_lunge";
		this.m.Name = "Lunge";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.footwork", "ui/perks/perk_25.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function isAvailable() { return !this.m.IsSpent; }
	function spend() { this.m.IsSpent = true; }
	function isHidden()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor == null || !this.Tactical.isActive() || !actor.isPlacedOnMap() || this.m.IsSpent;
	}
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "The first weapon skill you use this turn can reach 1 tile farther than normal. The step avoids adjacent enemies and low ground when possible. Leaving enemy zones of control can trigger a free attack that stops the lunge." },
			{ id = 10, type = "text", icon = "ui/icons/special.png", text = "Extended-range move is [color=" + this.Const.UI.Color.PositiveValue + "]ready[/color] this turn." }
		];
	}
	function refreshVisibility()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return;
		::Brotherhood.refreshLungeWeaponSkillRanges(actor);
		actor.setDirty(true);
	}

	function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.m.IsSpent || _skill == null || !_skill.m.IsWeaponSkill || _targetTile == null) return;
		local actor = this.getContainer().getActor();
		local origin = actor.getTile();
		if (origin == null) return;
		local normalRange = ::Brotherhood.getNormalWeaponSkillRangeToTarget(_skill, origin, _targetTile);
		if (origin.getDistanceTo(_targetTile) > normalRange) return;
		this.m.IsSpent = true;
		this.refreshVisibility();
		::Brotherhood.logFleshcraftMechanic("LUNGE", actor, "The first weapon skill was used at normal range; the extended-range move is spent for this turn.");
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
		this.refreshVisibility();
	}
	function onCombatStarted()
	{
		this.m.IsSpent = false;
		this.refreshVisibility();
	}
	function onCombatFinished() { this.m.IsSpent = false; this.skill.onCombatFinished(); }
});
