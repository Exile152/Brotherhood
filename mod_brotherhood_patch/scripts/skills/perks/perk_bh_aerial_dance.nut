this.perk_bh_aerial_dance <- this.inherit("scripts/skills/skill", {
	m = { TriggeredThisRound = false },
	function create()
	{
		this.m.ID = "perk.bh_aerial_dance";
		this.m.Name = "Aerial Dance";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.dodge", "ui/perks/perk_05.png");
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
		local status = this.m.TriggeredThisRound
			? "Already triggered this round."
			: "Ready to recover Fatigue on the first enemy miss this round.";
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "The first time each round an enemy misses you, recover 5 Fatigue, or 10 if the attack missed by 5 or less." },
			{ id = 10, type = "text", icon = "ui/icons/fatigue.png", text = status }
		];
	}
	function refreshVisibility()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null) actor.setDirty(true);
	}
	function onTurnStart()
	{
		this.m.TriggeredThisRound = false;
		this.refreshVisibility();
	}
	function onMissed( _attacker, _skill )
	{
		if (this.m.TriggeredThisRound || _attacker == null) return;
		local actor = this.getContainer().getActor();
		if (_attacker.isAlliedWith(actor)) return;
		this.m.TriggeredThisRound = true;
		this.refreshVisibility();
		local margin = ::Brotherhood.LastAttackMissMargin;
		local recovery = margin != null && margin <= 5 ? 10 : 5;
		actor.setFatigue(::Math.max(0, actor.getFatigue() - recovery));
		::Brotherhood.logFleshcraftMechanic("AERIAL DANCE", actor, "Recovered " + recovery + " Fatigue after an enemy miss this round.");
	}
});
