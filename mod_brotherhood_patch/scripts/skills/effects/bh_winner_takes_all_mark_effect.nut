this.bh_winner_takes_all_mark_effect <- this.inherit("scripts/skills/skill", {
	m = { OwnerID = 0 },
	function create()
	{
		this.m.ID = "effects.bh_winner_takes_all_mark";
		this.m.Name = "Winner Takes All";
		this.m.Description = "This character has been marked as somebody else's target.";
		this.m.Icon = "skills/status_effect_25.png";
		this.m.IconMini = "status_effect_25_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}
	function setOwner( _id ) { this.m.OwnerID = _id; }
	function getTooltip()
	{
		local text = this.getDescription();
		if (this.m.OwnerID != 0 && ::Tactical.isActive())
		{
			local owner = ::Tactical.getEntityByID(this.m.OwnerID);
			if (owner != null) text = "Killing this target grants " + owner.getName() + " a Winner Takes All stack; an ally stealing the kill removes all of their stacks.";
		}
		return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = text }];
	}
	function resolveDeath( _killer )
	{
		if (this.m.OwnerID == 0 || !::Tactical.isActive()) return;
		local owner = ::Tactical.getEntityByID(this.m.OwnerID);
		if (owner == null || !owner.isAlive()) return;
		local perk = owner.getSkills().getSkillByID("perk.bh_winner_takes_all");
		if (perk != null) perk.resolveMarkedDeath(this.getContainer().getActor(), _killer);
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU32(this.m.OwnerID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.OwnerID = _in.readU32(); }
});
