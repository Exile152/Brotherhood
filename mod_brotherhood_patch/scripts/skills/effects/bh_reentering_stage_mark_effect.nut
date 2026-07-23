this.bh_reentering_stage_mark_effect <- this.inherit("scripts/skills/skill", {
	m = { Sources = [] },
	function create()
	{
		this.m.ID = "effects.bh_reentering_stage_mark";
		this.m.Name = "Re-entering Stage";
		this.m.Description = "This character has been marked for a dramatic return.";
		this.m.Icon = "ui/perks/perk_26.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function refreshDescription()
	{
		local names = "";
		foreach (i, source in this.m.Sources)
		{
			if (i != 0) names += i == this.m.Sources.len() - 1 ? " and " : ", ";
			names += source.Name;
		}
		this.m.Description = this.m.Sources.len() == 0
			? "This character will take 25% more melee damage from the marking characters until the end of their respective next turns."
			: "This character will take 25% more melee damage from " + names + " until the end of their respective next turns.";
	}
	function getTooltip()
	{
		this.refreshDescription();
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.m.Description }
		];
	}
	function addSource( _actor )
	{
		foreach (source in this.m.Sources) if (source.ID == _actor.getID()) return this;
		this.m.Sources.push({ ID = _actor.getID(), Name = _actor.getName() });
		this.refreshDescription();
		return this;
	}
	function removeSource( _actorID )
	{
		for (local i = this.m.Sources.len() - 1; i >= 0; --i) if (this.m.Sources[i].ID == _actorID) this.m.Sources.remove(i);
		if (this.m.Sources.len() == 0) this.removeSelf();
		else this.refreshDescription();
	}
});
