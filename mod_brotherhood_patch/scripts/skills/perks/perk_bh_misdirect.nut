this.perk_bh_misdirect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create(){this.m.ID="perk.bh_misdirect";this.m.Name="Misdirect";this.m.Description=::Brotherhood.getNewArchetypeTooltip(this.m.ID);this.m.Icon="ui/perks/bh_misdirect.png";this.m.IconDisabled="ui/perks/bh_misdirect_sw.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onTargetHit( _skill, _target, _bodyPart, _damageHitpoints, _damageArmor )
	{
		if(_target==null||_skill==null||!_skill.isAttack())return;
		local effect=_target.getSkills().getSkillByID("effects.bh_misdirect");
		if(effect==null){effect=this.new("scripts/skills/effects/bh_misdirect_effect");_target.getSkills().add(effect);}
		effect.setSource(this.getContainer().getActor(), _skill.isRanged());
		_target.setDirty(true);
		::Brotherhood.logArchetypeTest("MISDIRECT",this.getContainer().getActor(),"Marked "+_target.getName()+" for the next allied "+(_skill.isRanged()?"ranged":"melee")+" attack.");
	}
});
