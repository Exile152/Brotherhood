this.perk_bh_stolen <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "perk.bh_stolen"; this.m.Name = "Stolen!"; this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID); this.m.Icon = "ui/perks/perk_17.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; this.m.IsActive = false; }
	function onTargetHit( _skill, _target, _bodyPart, _hp, _armor )
	{
		local actor=this.getContainer().getActor();
		if (_target == null || !_skill.isAttack() || _skill.isRanged()){::Brotherhood.logArchetypeTest("STOLEN",actor,"Rejected trigger: requires a successful melee attack.");return;}
		local roll=this.Math.rand(1,100);
		if(roll>5){::Brotherhood.logArchetypeTest("STOLEN",actor,"Disarm roll "+roll+" > 5 against "+_target.getName()+"; no trigger.");return;}
		local weapon = _target.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if(weapon==null){::Brotherhood.logArchetypeTest("STOLEN",actor,"Successful 5% roll, but "+_target.getName()+" has no main-hand weapon.");return;}
		if(_target.getCurrentProperties().IsImmuneToDisarm){::Brotherhood.logArchetypeTest("STOLEN",actor,"Successful 5% roll, but "+_target.getName()+" is immune to disarm.");return;}
		if(!("World" in getroottable())||::MSU.isNull(::World.Assets)){::Brotherhood.logArchetypeTest("STOLEN",actor,"Successful 5% roll, but company inventory is unavailable.");return;}
		_target.getItems().unequip(weapon);
		::World.Assets.getStash().makeEmptySlots(1);
		::World.Assets.getStash().add(weapon);
		::Brotherhood.logArchetypeTest("STOLEN",actor,"Disarmed "+_target.getName()+" and moved "+weapon.getName()+" to company inventory.");
	}
});
