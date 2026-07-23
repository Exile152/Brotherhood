this.perk_bh_fuck_off <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_fuck_off";
		this.m.Name = "Fuck Off";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_27.png";
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onTargetHit( _skill, _target, _body, _hp, _armor )
	{
		local actor = this.getContainer().getActor();
		if (_target == null || !_target.isAlive() || !::Brotherhood.isLuteSkill(_skill)) return;
		if (!::MSU.isKindOf(_target, "human") && !::MSU.isKindOf(_target, "player"))
		{
			::Brotherhood.logObsidianTest("FUCK OFF", actor, "Rejected " + _target.getName() + ": target is not human.");
			return;
		}
		local roll = ::Math.rand(1, 100);
		if (roll > 10)
		{
			::Brotherhood.logObsidianTest("FUCK OFF", actor, "Lute hit " + _target.getName() + "; roll " + roll + " > 10, no humiliation.");
			return;
		}
		local moraleHeld = _target.checkMorale(0, 0);
		if (!moraleHeld)
		{
			_target.setMoraleState(this.Const.MoraleState.Fleeing);
			this.spawnIcon("perk_27", _target.getTile());
			::Brotherhood.logObsidianTest("FUCK OFF", actor, "Roll " + roll + " succeeded and " + _target.getName() + " failed morale; forced Fleeing.");
		}
		else ::Brotherhood.logObsidianTest("FUCK OFF", actor, "Roll " + roll + " succeeded, but " + _target.getName() + " passed the morale check.");
	}
});
