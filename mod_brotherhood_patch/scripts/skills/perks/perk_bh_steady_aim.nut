this.perk_bh_steady_aim <- this.inherit("scripts/skills/skill", {
	m = { WeaponID = null },
	function create(){this.m.ID="perk.bh_steady_aim";this.m.Name="Steady Aim";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.bullseye","ui/perks/perk_17.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isHidden(){return this.m.WeaponID==null;}
	function onAnySkillUsed(_s,_t,_p){local w=_s==null?null:_s.getItem();if(w!=null&&this.m.WeaponID==w.getInstanceID()){_p.DamageDirectAdd+=0.35;this.m.WeaponID=null;}}
	function onTargetHit(_s,_t,_part,_hp,_armor){local w=_s==null?null:_s.getItem();if(_s!=null&&_s.isAttack()&&_s.isRanged()&&w!=null&&_hp==0){this.m.WeaponID=w.getInstanceID();this.getContainer().update();}}
	function onCombatFinished(){this.m.WeaponID=null;this.skill.onCombatFinished();}
});
