this.bh_distracted_effect <- this.inherit("scripts/skills/skill", {
	m = { SourceID = 0, AppliedRound = 0 },
	function create()
	{
		this.m.ID = "effects.bh_distracted";
		this.m.Name = "Distracted";
		this.m.Description = "A nearby enemy is exploiting this character's divided attention.";
		this.m.Icon = "skills/status_effect_63.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function configure( _id )
	{
		this.m.SourceID = _id;
		this.m.ID = "effects.bh_distracted." + _id;
		this.m.AppliedRound = this.Time.getRound();
	}
	function getOwnerName()
	{
		if (this.m.SourceID == 0 || !::Tactical.isActive()) return null;
		local owner = ::Tactical.getEntityByID(this.m.SourceID);
		return owner == null ? null : owner.getName();
	}
	function getTooltip()
	{
		local ownerName = this.getOwnerName();
		local text = ownerName == null
			? "Attacks by the marking character against this target ignore an additional 20% of armor until the end of the round."
			: "Attacks by " + ownerName + " against this character ignore an additional 20% of armor until the end of the round.";
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = text }
		];
	}
	function onNewRound()
	{
		if (this.Time.getRound() > this.m.AppliedRound) this.removeSelf();
	}
});
