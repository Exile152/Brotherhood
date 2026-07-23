this.bh_aimed_sloth_effect <- this.inherit("scripts/skills/skill", {
	m = { AppliedRound = 0 },
	function create()
	{
		this.m.ID = "effects.bh_aimed_sloth";
		this.m.Name = "Aimed Sloth";
		this.m.Description = "Already affected by Aimed Sloth this round.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function onAdded()
	{
		this.m.AppliedRound = ::Time.getRound();
	}
	function onTurnStart()
	{
		if (::Time.getRound() == this.m.AppliedRound) return;
		::Brotherhood.logFleshcraftMechanic("AIMED SLOTH", this.getContainer().getActor(), "Once-per-round lock expired (applied round " + this.m.AppliedRound + ", now round " + ::Time.getRound() + ").");
		this.getContainer().remove(this);
	}
	function isHidden() { return true; }
});
