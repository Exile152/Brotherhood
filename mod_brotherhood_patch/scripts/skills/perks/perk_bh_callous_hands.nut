this.perk_bh_callous_hands <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_callous_hands";
		this.m.Name = "Callous Hands";
		this.m.Description = ::Brotherhood.getObsidianArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_41.png";
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		local actor = this.getContainer().getActor();
		if (!::Brotherhood.isUnarmedSkill(_skill, actor)) return;
		local mainhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (_skill.getID() == "actives.hand_to_hand" && (mainhand == null || actor.getSkills().hasSkill("effects.disarmed")))
		{
			if (_target != null) ::Brotherhood.logObsidianTest("CALLOUS HANDS", actor, "Hand-to-Hand used the +25% hand-damage multiplier already shown on the character sheet.");
			return;
		}
		_properties.DamageTotalMult *= 1.25;
		if (_target != null) ::Brotherhood.logObsidianTest("CALLOUS HANDS", actor, "Applied +25% damage to " + _skill.getName() + (_skill.getItem() == null ? " (unarmed)." : " (dagger counted as unarmed)."));
	}
});
