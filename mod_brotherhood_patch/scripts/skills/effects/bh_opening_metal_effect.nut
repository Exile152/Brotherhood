this.bh_opening_metal_effect <- this.inherit("scripts/skills/skill", {
	m = { SourceID = 0 },
	function create()
	{
		this.m.ID = "effects.bh_opening_metal";
		this.m.Name = "Opening Metal";
		this.m.Description = "The next attack by another character deals 20% more damage.";
		this.m.Icon = "ui/perks/perk_16.png";
		this.m.IconMini = "perk_34_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function configure( _owner, _targetID )
	{
		this.m.SourceID = _owner.getID();
		this.m.ID = "effects.bh_opening_metal." + _targetID;
	}
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() }
		];
	}
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker == null || _skill == null || !_skill.isAttack()) return;
		local victim = this.getContainer().getActor();
		if (_attacker.getID() == this.m.SourceID)
		{
			::Brotherhood.logFleshcraftMechanic("OPENING METAL", _attacker, "Mark on " + victim.getName() + " not consumed; the attacker is the character that applied it.");
			return;
		}
		_properties.DamageReceivedTotalMult *= 1.20;
		::Brotherhood.logFleshcraftMechanic("OPENING METAL", _attacker, "Consumed the mark on " + victim.getName() + " for +20% damage.");
		this.getContainer().remove(this);
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU32(this.m.SourceID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.SourceID = _in.readU32(); }
});
