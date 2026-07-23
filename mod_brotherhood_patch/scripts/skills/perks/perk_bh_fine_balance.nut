this.perk_bh_fine_balance <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "perk.bh_fine_balance";
		this.m.Name = "Fine Balance";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAdded()
	{
		this.reconcileQualifiedLevels();
	}
	function reconcileQualifiedLevels()
	{
		local actor = this.getContainer().getActor();
		local flags = actor.getFlags();
		for (local level = 1; level <= ::Math.min(11, actor.getLevel()); ++level)
			if (flags.has("BH_FineBalanceQualified_" + level) && flags.get("BH_FineBalanceQualified_" + level)) this.processLevel(level);
	}
	function onUpdate( _properties )
	{
		// On saved actors, skill onAdded can run before actor flags finish loading.
		this.reconcileQualifiedLevels();
	}
	function processLevel( _level )
	{
		if (_level < 1 || _level > 11) return false;
		local actor = this.getContainer().getActor();
		local flags = actor.getFlags();
		local processedKey = "BH_FineBalanceProcessed_" + _level;
		if (flags.has(processedKey) && flags.get(processedKey)) return false;
		flags.set(processedKey, true);
		local baseProperties = actor.getBaseProperties();
		if (_level % 2 == 0)
		{
			baseProperties.Hitpoints += 1;
			baseProperties.Stamina += 1;
			actor.setHitpoints(actor.getHitpoints() + 1);
		}
		else
		{
			baseProperties.Initiative += 1;
			baseProperties.Bravery += 1;
		}
		actor.getSkills().update();
		actor.setDirty(true);
		::Brotherhood.logFleshcraftMechanic("FINE BALANCE", actor, "Applied the Level " + _level + " permanent bonus.");
		return true;
	}
});
