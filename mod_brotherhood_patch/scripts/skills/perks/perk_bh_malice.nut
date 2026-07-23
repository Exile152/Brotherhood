this.perk_bh_malice <- this.inherit("scripts/skills/skill", {
	m = { Stacks = 0, ArmedKind = 0 },
	function create(){this.m.ID="perk.bh_malice";this.m.Name="Malice";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applyCustomPerkIcon(this);this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isHidden(){return this.m.Stacks==0;}
	function getTooltip()
	{
		local trigger = this.m.ArmedKind == 1 ? "Ranged" : this.m.ArmedKind == 2 ? "Melee" : "opposite weapon type";
		return [
			{id=1,type="title",text=this.getName()},
			{id=2,type="description",text="Enemies that survive your attacks strengthen your Malice for the next kill with a different weapon type:"},
			{id=10,type="text",icon="ui/icons/special.png",text="Current stacks: "+::MSU.Text.colorPositive(this.m.Stacks)+" / 5"},
			{id=11,type="text",icon="ui/icons/fatigue.png",text="Stored recovery: "+::MSU.Text.colorPositive(5*this.m.Stacks)+" Fatigue"},
			{id=12,type="text",icon="ui/icons/damage_dealt.png",text=this.m.ArmedKind == 0 ? "First hit sets the required opposite weapon type" : "Next "+::MSU.Text.colorPositive(trigger)+" kill consumes all stacks"}
		];
	}
	function onTargetHit(_skill,_target,_bodyPart,_damageHitpoints,_damageArmor)
	{
		if(_skill==null||!_skill.isAttack()||_target==null)return;
		local kind=_skill.isRanged()?2:1;
		if(this.m.ArmedKind==0)
		{
			this.m.ArmedKind=kind;
			::Brotherhood.logFleshcraftMechanic("MALICE",this.getContainer().getActor(),"Armed on first "+(kind==1?"melee":"ranged")+" hit; the opposite weapon type will consume accumulated stacks on a kill.");
		}
		if(_target.isAlive()&&!_target.isDying())this.m.Stacks=::Math.min(5,this.m.Stacks+1);
		this.getContainer().update();
		this.getContainer().getActor().setDirty(true);
	}
	function onTargetKilled(_target,_skill)
	{
		if(_skill==null||!_skill.isAttack())return;
		local kind=_skill.isRanged()?2:1;
		if(this.m.ArmedKind!=0&&this.m.ArmedKind!=kind&&this.m.Stacks>0)
		{
			local actor=this.getContainer().getActor();
			if(actor.isPlacedOnMap())this.spawnIcon("bh_malice",actor.getTile());
			::Brotherhood.logFleshcraftMechanic("MALICE",actor,"Consumed "+this.m.Stacks+" stack(s) and restored "+(5*this.m.Stacks)+" Fatigue.");
			actor.setFatigue(::Math.max(0,actor.getFatigue()-5*this.m.Stacks));
			this.m.Stacks=0;
			this.m.ArmedKind=0;
			actor.setDirty(true);
		}
		this.getContainer().update();
	}
	function onCombatFinished(){this.m.Stacks=0;this.m.ArmedKind=0;this.skill.onCombatFinished();}
});
