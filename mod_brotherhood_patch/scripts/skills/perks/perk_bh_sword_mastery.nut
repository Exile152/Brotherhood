this.perk_bh_sword_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "perk.bh_sword_mastery"; this.m.Name = "Sword Mastery"; this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID); this.m.Icon = "ui/perks/perk_46.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; }
	function onUpdate( _properties ) { _properties.IsSpecializedInSwords = true; }
	function onAdded() { ::Brotherhood.logDuelistTest(this.getContainer().getActor(), "Sword Mastery active; sword skill modifiers enabled."); }
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local item = _skill.getItem();
		if (item != null && item.isWeaponType(this.Const.Items.WeaponType.Sword)) ::Brotherhood.logDuelistTest(this.getContainer().getActor(), "Sword Mastery applied to " + _skill.getName() + ".");
	}
});
