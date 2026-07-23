this.perk_bh_versatile_defense <- this.inherit("scripts/skills/skill", {
	m = { MeleeDefenseBonus = 0, RangedDefenseBonus = 0, Attacks = 0 },
	function create(){this.m.ID="perk.bh_versatile_defense";this.m.Name="Versatile Defense";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applyCustomPerkIcon(this);this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isHidden(){return this.m.MeleeDefenseBonus==0&&this.m.RangedDefenseBonus==0;}
	function getTooltip()
	{
		local ret=[
			{id=1,type="title",text=this.getName()},
			{id=2,type="description",text="Each attack this turn prepares you against the opposite attack style."}
		];
		if(this.m.MeleeDefenseBonus>0)ret.push({id=10,type="text",icon="ui/icons/melee_defense.png",text=::MSU.Text.colorPositive("+"+this.m.MeleeDefenseBonus)+" Melee Defense"});
		if(this.m.RangedDefenseBonus>0)ret.push({id=11,type="text",icon="ui/icons/ranged_defense.png",text=::MSU.Text.colorPositive("+"+this.m.RangedDefenseBonus)+" Ranged Defense"});
		ret.push({id=12,type="text",icon="ui/icons/special.png",text="Attacks made this turn: "+::MSU.Text.colorPositive(this.m.Attacks)});
		return ret;
	}
	function onUpdate(_properties)
	{
		_properties.MeleeDefense+=this.m.MeleeDefenseBonus;
		_properties.RangedDefense+=this.m.RangedDefenseBonus;
	}
	function onAnySkillExecutedFully(_skill,_tile,_target,_free)
	{
		if(_skill==null||!_skill.isAttack())return;
		local gain=this.m.Attacks==0?10:5;
		++this.m.Attacks;
		if(_skill.isRanged())this.m.MeleeDefenseBonus+=gain;
		else this.m.RangedDefenseBonus+=gain;
		this.getContainer().update();
		this.getContainer().getActor().setDirty(true);
	}
	function reset(){this.m.MeleeDefenseBonus=0;this.m.RangedDefenseBonus=0;this.m.Attacks=0;}
	function onTurnStart(){this.reset();this.getContainer().update();}
	function onCombatFinished(){this.reset();this.skill.onCombatFinished();}
});
