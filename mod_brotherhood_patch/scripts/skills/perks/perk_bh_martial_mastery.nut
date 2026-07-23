this.perk_bh_martial_mastery <- this.inherit("scripts/skills/skill", {
	m = { EmptyHandsActive = null },
	function create()
	{
		this.m.ID = "perk.bh_martial_mastery";
		this.m.Name = "Martial Mastery";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_52.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local active = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null && actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null;
		if (active)
		{
			_properties.MeleeDefense += 10;
			_properties.Initiative += 10;
		}
		if (this.m.EmptyHandsActive != active)
		{
			::Brotherhood.logObsidianTest("MARTIAL MASTERY", actor, active ? "Both hands free: +10 Melee Defense and +10 Initiative active." : "Both-hands-free defense and Initiative bonus inactive.");
			this.m.EmptyHandsActive = active;
		}
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		local actor = this.getContainer().getActor();
		if (!::Brotherhood.isUnarmedSkill(_skill, actor)) return;
		_properties.DamageDirectAdd += 0.30;
		if (_target != null) ::Brotherhood.logObsidianTest("MARTIAL MASTERY", actor, "Applied +30% armor penetration to " + _skill.getName() + ".");
	}
});
