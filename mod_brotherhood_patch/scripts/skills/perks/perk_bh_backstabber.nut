this.perk_bh_backstabber <- this.inherit("scripts/skills/skill", {
	m={},
	function create(){this.m.ID="perk.bh_backstabber";this.m.Name="Backstabber";this.m.Description=::Brotherhood.getNewArchetypeTooltip(this.m.ID);local p=::Const.Perks.findById("perk.backstabber");this.m.Icon=p==null?"ui/perks/perk_59.png":p.Icon;this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onAnySkillUsed(_skill,_target,_properties)
	{
		local actor=this.getContainer().getActor();
		if(_target==null||_skill==null||!_skill.isAttack()||_skill.isRanged()){::Brotherhood.logArchetypeTest("BACKSTABBER",actor,"Rejected skill: requires a targeted melee attack.");return;}
		local old=_properties.SurroundedBonus;_properties.SurroundedBonus*=2;
		::Brotherhood.logArchetypeTest("BACKSTABBER",actor,"Applied to "+_skill.getID()+" against "+_target.getName()+"; SurroundedBonus "+old+" -> "+_properties.SurroundedBonus+".");
	}
});
