this.perk_bh_gifted <- this.inherit("scripts/skills/skill", {
	m = { IsApplied = false },
	function create()
	{
		this.m.ID = "perk.bh_gifted";
		this.m.Name = "Gifted";
		this.m.Description = ::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.gifted", "ui/perks/perk_21.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function onAdded()
	{
		if (this.m.IsApplied) return;
		this.m.IsApplied = true;
		local actor = this.getContainer().getActor();
		local flags = actor.getFlags();
		flags.set("BH_GiftedPendingSelections", flags.has("BH_GiftedPendingSelections") ? flags.get("BH_GiftedPendingSelections") + 1 : 1);
		++actor.m.LevelUps;
		actor.fillAttributeLevelUpValues(1, true);
		actor.setDirty(true);
		::Brotherhood.logArchetypeTest("GIFTED", actor, "Granted one three-attribute selection with maximum base rolls and no XP or level change.");
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeBool(this.m.IsApplied); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.IsApplied = _in.readBool(); }
});
