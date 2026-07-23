this.bh_twin_discipline_mark_effect <- this.inherit("scripts/skills/skill", {
	m = { OwnerID = 0 },
	function create()
	{
		this.m.ID = "effects.bh_twin_discipline_mark";
		this.m.Name = "Twin Discipline";
		this.m.Description = "You do not exert a Zone of Control against the mercenary who marked you. While they have two marked enemies, they deal +10% damage to both.";
		this.m.Icon = "ui/perks/perk_05.png";
		this.m.IconMini = "perk_01_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}
	function configure( _owner )
	{
		this.m.OwnerID = _owner.getID();
		this.m.ID = "effects.bh_twin_discipline." + this.m.OwnerID;
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
			: "You do not exert a Zone of Control against " + ownerName + ". While " + ownerName + " has two marked enemies, they deal +10% damage to both.";
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = text }
		];
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU32(this.m.OwnerID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.OwnerID = _in.readU32(); }
});
