this.perk_bh_distracted <- this.inherit("scripts/skills/skill", {
	m = {},
	function create(){this.m.ID="perk.bh_distracted";this.m.Name="Distracted";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.overwhelm","ui/perks/perk_27.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onAnySkillUsed(_s,_target,_p){if(_s==null||!_s.isAttack()||_target==null)return;if(_target.getSkills().hasSkill("effects.bh_distracted."+this.getContainer().getActor().getID()))_p.DamageDirectAdd+=0.20;}
});
