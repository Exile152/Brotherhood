this.perk_bh_determination <- this.inherit("scripts/skills/skill", {
	m = { NegativeSuccessesThisTurn = 0 },
	function create()
	{
		this.m.ID = "perk.bh_determination";
		this.m.Name = "Determination";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onMoraleEffect( _type, _success )
	{
		if (_type != this.Const.MoraleCheckType.Negative || !_success) return;
		local recovery = ::Math.max(0, 5 - this.m.NegativeSuccessesThisTurn);
		++this.m.NegativeSuccessesThisTurn;
		if (recovery <= 0) return;
		local actor = this.getContainer().getActor();
		actor.setFatigue(::Math.max(0, actor.getFatigue() - recovery));
		actor.setDirty(true);
		if (actor.isPlacedOnMap()) this.spawnIcon("perk_08", actor.getTile());
		::Brotherhood.logFleshcraftMechanic("DETERMINATION", actor, "Recovered " + recovery + " Fatigue after passing a negative morale check.");
	}
	function onTurnStart()
	{
		this.m.NegativeSuccessesThisTurn = 0;
	}
});
