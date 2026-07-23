this.perk_bh_hard_boiled_egg <- this.inherit("scripts/skills/skill", {
	m = { StacksByAttacker = {} },

	function create()
	{
		this.m.ID = "perk.bh_hard_boiled_egg";
		this.m.Name = "Hard-Boiled Egg";
		this.m.Description = ::Brotherhood.getBruteLaborerTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_hard_boiled_egg.png";
		this.m.IconDisabled = "ui/perks/bh_hard_boiled_egg_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function getAttackerID( _attacker )
	{
		return _attacker == null ? null : _attacker.getID();
	}

	function getStacks( _attacker )
	{
		local id = this.getAttackerID(_attacker);
		return id != null && id in this.m.StacksByAttacker ? this.m.StacksByAttacker[id] : 0;
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (_attacker == null || _skill == null || !_skill.isAttack()) return;
		local penalty = (this.getStacks(_attacker) + 1) * 10;
		_properties.MeleeSkill -= penalty;
		_properties.RangedSkill -= penalty;
	}

	function recordHit( _attacker )
	{
		local id = this.getAttackerID(_attacker);
		if (id == null) return;
		local stacks = this.getStacks(_attacker) + 1;
		this.m.StacksByAttacker[id] <- stacks;
		::Brotherhood.logArchetypeTest("HARD-BOILED EGG", this.getContainer().getActor(), _attacker.getName() + " hit; personal hit-chance penalty advanced to -" + ((stacks + 1) * 10) + "% for their next attack.");
	}

	function recordMiss( _attacker )
	{
		local id = this.getAttackerID(_attacker);
		if (id == null) return;
		if (id in this.m.StacksByAttacker) delete this.m.StacksByAttacker[id];
		::Brotherhood.logArchetypeTest("HARD-BOILED EGG", this.getContainer().getActor(), _attacker.getName() + " missed; their personal stacks reset.");
	}
});
