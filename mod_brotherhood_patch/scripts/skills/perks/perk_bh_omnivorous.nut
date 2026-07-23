this.perk_bh_omnivorous <- this.inherit("scripts/skills/skill", {
	m = { Next = 0, ProcPending = false },
	function create(){this.m.ID="perk.bh_omnivorous";this.m.Name="Omnivorous";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applyCustomPerkIcon(this);this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isHidden(){return this.m.Next==0;}
	function getTooltip(){local next=this.m.Next==1?"Melee":this.m.Next==2?"Ranged":"alternating";return [{id=1,type="title",text=this.getName()},{id=2,type="description",text="Alternating between melee and ranged attacks keeps your offense unpredictable."},{id=10,type="text",icon="ui/icons/damage_dealt.png",text="Next "+::MSU.Text.colorPositive(next)+" attack deals "+::MSU.Text.colorPositive("+25%")+" damage"}];}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill == null || !_skill.isAttack()) return;
		local kind = _skill.isRanged() ? 2 : 1;
		this.m.ProcPending = this.m.Next == kind;
		if (this.m.ProcPending) _properties.DamageTotalMult *= 1.25;
	}
	function onAnySkillExecutedFully( _skill, _tile, _target, _forFree )
	{
		if (_skill == null || !_skill.isAttack()) return;
		local actor = this.getContainer().getActor();
		if (this.m.ProcPending)
		{
			if (actor.isPlacedOnMap()) this.spawnIcon("bh_omnivorous", actor.getTile());
			::Brotherhood.logFleshcraftMechanic("OMNIVOROUS", actor, "Triggered +25% damage on the alternating attack.");
		}
		this.m.ProcPending = false;
		this.m.Next = _skill.isRanged() ? 1 : 2;
		this.getContainer().update();
		actor.setDirty(true);
	}
	function onCombatFinished(){this.m.Next=0;this.m.ProcPending=false;this.skill.onCombatFinished();}
});
