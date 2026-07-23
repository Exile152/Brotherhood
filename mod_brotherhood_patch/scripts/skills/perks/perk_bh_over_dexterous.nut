this.perk_bh_over_dexterous <- this.inherit("scripts/skills/skill", {
	m = {},
	function create(){this.m.ID="perk.bh_over_dexterous";this.m.Name="Over-Dexterous";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applyCustomPerkIcon(this);this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onUpdate(_p){local excess=::Math.max(0,_p.MeleeSkill-94);_p.RangedSkill+=::Math.floor(_p.MeleeSkill*0.05)+excess;}
	function onAnySkillUsed(_s,_t,_p){if(_s!=null&&_s.isAttack()&&_s.isRanged())_p.DamageTotalMult*=1.0+::Math.max(0,_p.MeleeSkill-94)*0.01;}
});
