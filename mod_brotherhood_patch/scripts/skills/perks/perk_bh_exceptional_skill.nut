this.perk_bh_exceptional_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create(){this.m.ID="perk.bh_exceptional_skill";this.m.Name="Exceptional Skill";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.bullseye","ui/perks/perk_17.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onUpdate(_p){_p.RangedSkill+=::Math.floor(_p.RangedDefense*0.33);}
	function onAnySkillUsed(_s,_t,_p){if(_s!=null&&_s.isAttack()&&_s.isRanged())_p.DamageTotalMult*=1.0+0.0025*_p.RangedDefense;}
});
