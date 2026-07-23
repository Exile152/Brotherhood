this.perk_bh_volley_mastery <- this.inherit("scripts/skills/skill", {
	m = { SecondarySkill = null, SecondaryInFlight = false },
	function create(){this.m.ID="perk.bh_volley_mastery";this.m.Name="Volley Mastery";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.mastery.throwing","ui/perks/perk_10.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function valid(_s){local w=_s==null?null:_s.getItem();return _s!=null&&_s.isAttack()&&_s.isRanged()&&::Brotherhood.isFleshcraftThrowingWeapon(w);}
	function getPairedSkill(_used)
	{
		local actor=this.getContainer().getActor();
		local usedItem=_used==null?null:_used.getItem();
		if(usedItem==null)return null;
		local otherSlot=usedItem.getCurrentSlotType()==this.Const.ItemSlot.Offhand?this.Const.ItemSlot.Mainhand:this.Const.ItemSlot.Offhand;
		local other=actor.getItems().getItemAtSlot(otherSlot);
		if(!::Brotherhood.isFleshcraftThrowingWeapon(other))return null;
		// Visibility-filtered skill queries can omit an offhand clone while the
		// character screen is refreshing. Resolve the live item-bound attack
		// directly from the container instead.
		foreach(s in this.getContainer().m.Skills)
		{
			if(s==null||s==_used||s.isGarbage()||!this.valid(s))continue;
			local skillItem=s.getItem();
			if(::MSU.isNull(skillItem))continue;
			if(skillItem.getCurrentSlotType()==otherSlot||skillItem.getInstanceID()==other.getInstanceID())return s;
		}
		return null;
	}
	function onAfterUpdate(_p){foreach(s in this.getContainer().getAllSkillsOfType(this.Const.SkillType.Active))if(this.valid(s))s.m.FatigueCostMult*=0.75;}
	function onAnySkillUsed(_s,_t,_p){if(this.valid(_s)&&(this.m.SecondarySkill==_s||this.getPairedSkill(_s)!=null))_p.DamageTotalMult*=0.70;}
	function onAnySkillExecutedFully(_s,_tile,_target,_free)
	{
		// Reforged can report a rejected useForFree attempt after that call has
		// already returned. Keep an explicit chain guard so that delayed report
		// can never be mistaken for a new player-initiated first throw.
		if(this.m.SecondaryInFlight&&this.valid(_s))
		{
			::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",this.getContainer().getActor(),"Consumed the sequential follow-up completion for "+_s.getName()+" without starting another Volley chain.");
			this.m.SecondaryInFlight=false;
			this.m.SecondarySkill=null;
			return;
		}
		if(this.m.SecondarySkill==_s)
		{
			::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",this.getContainer().getActor(),"Completed the sequential off-hand throw with "+_s.getName()+".");
			this.m.SecondarySkill=null;
			return;
		}
		if(this.m.SecondarySkill!=null||!this.valid(_s)||_target==null)return;
		local second=this.getPairedSkill(_s);
		if(second==null)
		{
			local actor=this.getContainer().getActor();
			local main=actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			local off=actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
			::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",actor,"No paired throwing skill after "+_s.getName()+" (main="+(main==null?"empty":main.getName())+", off="+(off==null?"empty":off.getName())+").");
			return;
		}
		this.m.SecondarySkill=second;
		::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",this.getContainer().getActor(),"Scheduled "+second.getName()+" after "+_s.getName()+" finished.");
		// Leave a short readable beat after the first projectile resolves.
		this.Time.scheduleEvent(this.TimeUnit.Virtual,150,this.resolveSecondaryThrow.bindenv(this),{TargetID=_target.getID()});
	}
	function resolveSecondaryThrow(_data)
	{
		local actor=this.getContainer()==null?null:this.getContainer().getActor();
		local second=this.m.SecondarySkill;
		local target = actor == null ? null : ::Tactical.getEntityByID(_data.TargetID);
		if(actor==null||second==null||target==null||!target.isAlive()||target.isDying()||!target.isPlacedOnMap())
		{
			if(actor!=null)::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",actor,"Canceled the sequential off-hand throw because its skill or target was no longer available.");
			this.m.SecondarySkill=null;
			return;
		}
		this.m.SecondaryInFlight=true;
		local started = second.useForFree(target.getTile());
		local completedSynchronously = !this.m.SecondaryInFlight;
		if(started || completedSynchronously)
		{
			actor.setFatigue(actor.getFatigue()+second.getFatigueCost());
			actor.setDirty(true);
			if (!completedSynchronously) ::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",actor,"Started the sequential off-hand throw with "+second.getName()+".");
		}
		else
		{
			::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",actor,"The sequential off-hand throw was rejected by "+second.getName()+"; retaining the chain guard for its delayed completion callback.");
			this.Time.scheduleEvent(this.TimeUnit.Virtual,500,this.clearRejectedSecondaryGuard.bindenv(this),null);
		}
	}
	function clearRejectedSecondaryGuard(_data)
	{
		if(!this.m.SecondaryInFlight)return;
		local actor=this.getContainer()==null?null:this.getContainer().getActor();
		if(actor!=null)::Brotherhood.logFleshcraftMechanic("VOLLEY MASTERY",actor,"Cleared a stale rejected follow-up guard after no completion callback arrived.");
		this.m.SecondaryInFlight=false;
		this.m.SecondarySkill=null;
	}
	function onCombatFinished(){this.m.SecondarySkill=null;this.m.SecondaryInFlight=false;this.skill.onCombatFinished();}
});
