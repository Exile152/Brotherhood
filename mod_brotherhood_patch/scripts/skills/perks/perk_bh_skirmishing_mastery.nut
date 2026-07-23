this.perk_bh_skirmishing_mastery <- this.inherit("scripts/skills/skill", {
	m = {},
	function create(){this.m.ID="perk.bh_skirmishing_mastery";this.m.Name="Skirmishing Mastery";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.mastery.throwing","ui/perks/perk_10.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function valid(_s){local i=_s==null?null:_s.getItem();return _s!=null&&_s.isAttack()&&_s.isRanged()&&i!=null&&i.isItemType(this.Const.Items.ItemType.Weapon)&&i.isWeaponType(this.Const.Items.WeaponType.Throwing);}
	function onAfterUpdate(_p){foreach(s in this.getContainer().getAllSkillsOfType(this.Const.SkillType.Active))if(this.valid(s))s.m.FatigueCostMult*=0.75;}
	function onAnySkillUsed(_s,_t,_p){if(_t==null||!this.valid(_s))return;local d=this.getContainer().getActor().getTile().getDistanceTo(_t.getTile());if(d==2)_p.DamageTotalMult*=1.20;else if(d==3)_p.DamageTotalMult*=1.15;}
});
