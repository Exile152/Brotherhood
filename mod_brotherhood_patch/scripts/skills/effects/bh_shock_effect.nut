this.bh_shock_effect <- this.inherit("scripts/skills/skill", {
	m = { SourceActorID = "" },
	function create()
	{
		this.m.ID = "effects.bh_shock";
		this.m.Name = "Shock";
		this.m.Description = "This character deals 15% less damage until the injury source's next turn.";
		this.m.Icon = "skills/status_effect_65.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsRemovedAfterBattle = true;
	}
	function configure( _sourceActorID ) { this.m.SourceActorID = _sourceActorID; this.m.ID = "effects.bh_shock." + _sourceActorID; }
	function getDescription()
	{
		local source = !("Tactical" in getroottable()) ? null : ::Tactical.getEntityByID(this.m.SourceActorID);
		local sourceName = source == null ? "the injury source" : ::MSU.Text.colorPositive(source.getNameOnly());
		return "This character deals 15% less damage until " + sourceName + "'s next turn.";
	}
	function refresh() { this.getContainer().getActor().setDirty(true); }
	function onUpdate( _properties ) { _properties.DamageTotalMult *= 0.85; }
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeString(this.m.SourceActorID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.configure(_in.readString()); }
});
