this.perk_bh_mace_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create(){this.m.ID="perk.bh_mace_mastery";this.m.Name="Mace Mastery";this.m.Description=::Brotherhood.getBruteLaborerTooltip(this.m.ID);this.m.Icon="ui/perks/perk_10.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onTargetHit(_s,_t,_part,_hp,_armor){local w=_s==null?null:_s.getItem();if(_t!=null&&w!=null&&w.isWeaponType(this.Const.Items.WeaponType.Mace)&&::Math.rand(1,100)<=33){_t.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));::Brotherhood.logArchetypeTest("MACE MASTERY",this.getContainer().getActor(),"Applied Dazed to "+_t.getName()+".");}}
});
