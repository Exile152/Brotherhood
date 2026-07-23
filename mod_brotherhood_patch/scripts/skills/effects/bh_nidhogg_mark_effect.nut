this.bh_nidhogg_mark_effect <- this.inherit("scripts/skills/skill", {
	m = { OwnerID = 0 },
	function create()
	{
		this.m.ID = "effects.bh_nidhogg";
		this.m.Name = "Nidhogg";
		this.m.Description = "When the marking character hits this target, they repeat their attack.";
		this.m.Icon = "ui/perks/perk_03.png";
		this.m.IconMini = "perk_36_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function configure( _owner, _targetID )
	{
		this.m.OwnerID = _owner.getID();
		this.m.ID = "effects.bh_nidhogg." + _targetID;
	}
	function getOwnerName()
	{
		if (this.m.OwnerID == 0 || !::Tactical.isActive()) return null;
		local owner = ::Tactical.getEntityByID(this.m.OwnerID);
		return owner == null ? null : owner.getName();
	}
	function getTooltip()
	{
		local ownerName = this.getOwnerName();
		local text = ownerName == null
			? this.getDescription()
			: "When " + ownerName + " hits this character, they repeat their attack.";
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = text }
		];
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU32(this.m.OwnerID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.OwnerID = _in.readU32(); }
});
