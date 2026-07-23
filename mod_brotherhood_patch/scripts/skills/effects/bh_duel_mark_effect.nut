this.bh_duel_mark_effect <- this.inherit("scripts/skills/skill", {
	m = { OwnerID = 0 },
	function create()
	{
		this.m.ID = "effects.bh_duel_mark";
		this.m.Name = "Challenged to a Duel";
		this.m.Description = "This character has been challenged to a duel.";
		this.m.Icon = "skills/status_effect_01.png";
		this.m.IconMini = "status_effect_01_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}
	function setOwner( _id ) { this.m.OwnerID = _id; }
	function getOwner()
	{
		if (this.m.OwnerID == 0 || !::Tactical.isActive()) return null;
		return ::Tactical.getEntityByID(this.m.OwnerID);
	}
	function forceDuelOpponent( _reason )
	{
		local owner = this.getOwner();
		local target = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null || !owner.isAlive() || target == null || target.getAIAgent() == null) return false;
		target.getAIAgent().setForcedOpponent(owner);
		::Brotherhood.logArchetypeTest("DUEL", owner, "Forced " + target.getName() + " to prioritize the challenger " + _reason + ".");
		return true;
	}
	function clearForcedOpponent()
	{
		local target = this.getContainer() == null ? null : this.getContainer().getActor();
		if (target == null || target.getAIAgent() == null) return;
		local forced = target.getAIAgent().getForcedOpponent();
		if (!::MSU.isNull(forced) && forced.getID() == this.m.OwnerID) target.getAIAgent().m.ForcedOpponent = null;
	}
	function onAdded() { this.forceDuelOpponent("when the duel began"); }
	function onRemoved() { this.clearForcedOpponent(); }
	function onTurnStart() { this.forceDuelOpponent("at the start of the challenged enemy's turn"); }
	function getTooltip()
	{
		local owner = this.getOwner();
		local description = owner == null ? this.getDescription() : "Challenged by " + owner.getName() + ". " + this.getDescription();
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = description },
			{ id = 9, type = "text", icon = "ui/icons/special.png", text = "This character must prioritize engaging and attacking the challenger, if possible" },
			{ id = 10, type = "text", icon = "ui/icons/morale.png", text = "The duel ends if this character becomes Breaking or Fleeing" }
		];
	}
	function getOwnerPerk()
	{
		if (this.m.OwnerID == 0 || !::Tactical.isActive()) return null;
		local owner = this.getOwner();
		return owner == null ? null : owner.getSkills().getSkillByID("perk.bh_duel_coward");
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.getMoraleState() != this.Const.MoraleState.Ignore && actor.getMoraleState() <= this.Const.MoraleState.Breaking)
		{
			local perk = this.getOwnerPerk();
			if (perk != null) perk.clearDuel("the challenged enemy's morale broke");
			this.removeSelf();
		}
	}
	function resolveDeath()
	{
		local perk = this.getOwnerPerk();
		if (perk != null) perk.clearDuel("the challenged enemy died");
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU32(this.m.OwnerID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.OwnerID = _in.readU32(); }
});
