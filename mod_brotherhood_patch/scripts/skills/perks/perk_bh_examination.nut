this.perk_bh_examination <- this.inherit("scripts/skills/skill", {
	m = { UsedWeaponSkillThisTurn = false, BonusReady = false, LastConsumedSkillCounter = -1 },
	function create()
	{
		this.m.ID = "perk.bh_examination";
		this.m.Name = "Examination";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}
	function isHidden() { return !this.m.BonusReady; }
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.m.IsWeaponSkill) return;
		if (!this.m.BonusReady) return;
		_properties.MeleeSkill += 15;
		_properties.RangedSkill += 15;
	}
	function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill == null || !_skill.m.IsWeaponSkill) return;
		this.m.UsedWeaponSkillThisTurn = true;
		if (this.m.BonusReady)
		{
			this.m.BonusReady = false;
			this.m.LastConsumedSkillCounter = this.Const.SkillCounter;
			this.getContainer().getActor().setDirty(true);
		}
	}
	function onTurnStart() { this.m.UsedWeaponSkillThisTurn = false; }
	function onTurnEnd()
	{
		if (!this.m.UsedWeaponSkillThisTurn)
		{
			this.m.BonusReady = true;
			this.getContainer().getActor().setDirty(true);
		}
	}
	function onCombatStarted() { this.m.UsedWeaponSkillThisTurn = false; }
	function onCombatFinished() { this.m.UsedWeaponSkillThisTurn = false; this.m.BonusReady = false; this.skill.onCombatFinished(); }
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeBool(this.m.UsedWeaponSkillThisTurn); _out.writeBool(this.m.BonusReady); _out.writeI32(this.m.LastConsumedSkillCounter); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.UsedWeaponSkillThisTurn = _in.readBool(); this.m.BonusReady = _in.readBool(); this.m.LastConsumedSkillCounter = _in.readI32(); }
});
