this.bh_misdirect_effect <- this.inherit("scripts/skills/skill", {
	m = { SourceID = 0, IsRanged = false, PendingAttackerID = 0 },
	function create()
	{
		this.m.ID = "effects.bh_misdirect";
		this.m.Name = "Misdirect";
		this.m.Description = "The next matching allied attack gains +10 chance to hit.";
		this.m.Icon = "ui/perks/bh_misdirect.png";
		this.m.IconDisabled = "ui/perks/bh_misdirect_sw.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function setSource( _source, _isRanged )
	{
		this.m.SourceID = _source.getID();
		this.m.IsRanged = _isRanged;
		this.m.PendingAttackerID = 0;
	}
	function getTooltip()
	{
		local attackType = this.m.IsRanged ? "ranged" : "melee";
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = "The next allied " + attackType + " attack against this character gains +10 chance to hit." }
		];
	}
	function isValidAttack( _attacker, _skill )
	{
		if (_attacker == null || _skill == null || !_skill.isAttack() || _attacker.getID() == this.m.SourceID || _skill.isRanged() != this.m.IsRanged) return false;
		local source = ::Tactical.getEntityByID(this.m.SourceID);
		return source != null && _attacker.isAlliedWith(source);
	}
	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (!this.isValidAttack(_attacker, _skill))
		{
			::Brotherhood.logArchetypeTest("MISDIRECT", this.getContainer().getActor(), "Mark not consumed by " + (_attacker == null ? "unknown attacker" : _attacker.getName()) + ": attack type or ally/source requirement did not match.");
			return;
		}
		if (this.m.IsRanged) _properties.RangedDefense -= 10;
		else _properties.MeleeDefense -= 10;
		this.m.PendingAttackerID = _attacker.getID();
		::Brotherhood.logArchetypeTest("MISDIRECT", this.getContainer().getActor(), "Granted +10 hit chance to " + _attacker.getName() + " for this " + (this.m.IsRanged ? "ranged" : "melee") + " attack.");
	}
	function onGetHitFactorsAsTarget( _skill, _targetTile, _tooltip )
	{
		local attacker = _skill == null || _skill.getContainer() == null ? null : _skill.getContainer().getActor();
		if (this.isValidAttack(attacker, _skill)) _tooltip.push({ icon = "ui/tooltips/positive.png", text = ::MSU.Text.colorPositive("10%") + " Misdirect" });
	}
	function consume( _attacker )
	{
		if (_attacker != null && this.m.PendingAttackerID == _attacker.getID())
		{
			::Brotherhood.logArchetypeTest("MISDIRECT", this.getContainer().getActor(), "Consumed mark after " + _attacker.getName() + " completed the qualifying attack.");
			this.removeSelf();
		}
	}
	function onMissed( _attacker, _skill ) { this.consume(_attacker); }
	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor ) { this.consume(_attacker); }
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU32(this.m.SourceID); _out.writeBool(this.m.IsRanged); _out.writeU32(this.m.PendingAttackerID); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.SourceID = _in.readU32(); this.m.IsRanged = _in.readBool(); this.m.PendingAttackerID = _in.readU32(); }
});
