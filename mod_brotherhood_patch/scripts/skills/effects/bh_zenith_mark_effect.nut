this.bh_zenith_mark_effect <- this.inherit("scripts/skills/skill", {
	m = { OwnerID = 0 },
	function create()
	{
		this.m.ID = "effects.bh_zenith_mark";
		this.m.Name = "Zenith";
		this.m.Description = "Zenith already triggered its repeat attack against this character.";
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
		this.m.ID = "effects.bh_zenith." + this.m.OwnerID;
	}
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() }
		];
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU32(this.m.OwnerID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.OwnerID = _in.readU32(); }
});
