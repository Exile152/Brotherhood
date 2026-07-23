this.perk_bh_flow_state <- this.inherit("scripts/skills/skill", {
	m = { Stacks = 0, HitEnemyThisTurn = false, MaxStacks = 6 },
	function create()
	{
		this.m.ID = "perk.bh_flow_state";
		this.m.Name = "Flow State";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.duelist", "ui/perks/perk_41.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}
	function isHidden() { return this.m.Stacks == 0; }
	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({ id = 10, type = "text", icon = "ui/icons/direct_damage.png", text = ::MSU.Text.colorPositive(this.m.Stacks + "/" + this.m.MaxStacks) + " Flow stacks (" + ::MSU.Text.colorPositive("+" + (this.m.Stacks * 5) + "%") + " armor penetration)." });
		return ret;
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == null || !_skill.m.IsWeaponSkill || !::Brotherhood.hasFleshcraftOneHandedSetup(this.getContainer().getActor())) return;
		_properties.DamageDirectAdd += 0.05 * this.m.Stacks;
	}
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local actor = this.getContainer().getActor();
		if (_skill == null || !_skill.m.IsWeaponSkill || _targetEntity == null || _targetEntity.isAlliedWith(actor) || !::Brotherhood.hasFleshcraftOneHandedSetup(actor)) return;
		this.m.HitEnemyThisTurn = true;
		this.m.Stacks = ::Math.min(this.m.MaxStacks, this.m.Stacks + 1);
		actor.setDirty(true);
	}
	function onTurnStart() { this.m.HitEnemyThisTurn = false; }
	function onTurnEnd()
	{
		if (!this.m.HitEnemyThisTurn) this.m.Stacks = ::Math.max(0, this.m.Stacks - 2);
		this.getContainer().getActor().setDirty(true);
	}
	function onCombatStarted() { this.m.Stacks = 0; this.m.HitEnemyThisTurn = false; }
	function onCombatFinished() { this.m.Stacks = 0; this.m.HitEnemyThisTurn = false; this.skill.onCombatFinished(); }
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeU8(this.m.Stacks); _out.writeBool(this.m.HitEnemyThisTurn); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.Stacks = _in.readU8(); this.m.HitEnemyThisTurn = _in.readBool(); }
});
