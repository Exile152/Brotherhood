this.perk_bh_fearsome <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_fearsome";
		this.m.Name = "Fearsome";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_27.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return ret;
		local penalty = ::Math.floor(actor.getCurrentProperties().getBravery() * 0.15) - 10;
		foreach (entry in ret)
			if (("text" in entry) && typeof entry.text == "string")
				entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, "{X}", penalty.tostring());
		return ret;
	}
	function onTargetHit( _skill, _target, _body, _hp, _armor )
	{
		local actor = this.getContainer().getActor();
		if (_target == null || !_target.isAlive()) return;
		if (_hp < 1) { ::Brotherhood.logObsidianTest("FEARSOME", actor, "Hit " + _target.getName() + " for 0 Hitpoint damage; no morale check."); return; }
		if (_target.getMoraleState() == this.Const.MoraleState.Ignore) { ::Brotherhood.logObsidianTest("FEARSOME", actor, "Hit " + _target.getName() + ", but target ignores morale."); return; }
		local penalty = ::Math.floor(actor.getCurrentProperties().getBravery() * 0.15) - 10;
		local before = _target.getMoraleState();
		local result = _target.checkMorale(-1, -penalty);
		::Brotherhood.logObsidianTest("FEARSOME", actor, "Hit " + _target.getName() + " for " + _hp + " HP; Resolve penalty " + penalty + ", morale " + before + " -> " + _target.getMoraleState() + ", result=" + (result ? "true" : "false") + ".");
	}
});
