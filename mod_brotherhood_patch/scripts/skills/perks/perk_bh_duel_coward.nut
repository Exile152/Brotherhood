this.perk_bh_duel_coward <- this.inherit("scripts/skills/skill", {
	m = { TargetID = 0 },
	function create(){this.m.ID="perk.bh_duel_coward";this.m.Name="Duel, Coward";this.m.Description=::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.taunt","ui/perks/perk_41.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function ensureActive(){if(this.getContainer()!=null&&!this.getContainer().hasSkill("actives.bh_duel"))this.getContainer().add(this.new("scripts/skills/actives/bh_duel_skill"));}
	function onAdded(){this.ensureActive();}
	function onRemoved(){if(this.getContainer()!=null)this.getContainer().removeByID("actives.bh_duel");}
	function getDuelTarget(){if(this.m.TargetID==0||!::Tactical.isActive())return null;return ::Tactical.getEntityByID(this.m.TargetID);}
	function isTargetBroken(_target){return _target!=null&&_target.getMoraleState()!=this.Const.MoraleState.Ignore&&_target.getMoraleState()<=this.Const.MoraleState.Breaking;}
	function validateTarget()
	{
		local target = this.getDuelTarget();
		if (target == null || !target.isAlive() || target.isDying() || this.isTargetBroken(target))
		{
			if (this.m.TargetID != 0)
			{
				local reason = "the target died";
				if (target == null) reason = "the target is gone";
				else if (this.isTargetBroken(target)) reason = "the target's morale broke";
				this.clearDuel(reason);
			}
			return null;
		}
		return target;
	}
	function setDuelTarget(_target){this.clearDuel("a new duel began");this.m.TargetID=_target.getID();local mark=this.new("scripts/skills/effects/bh_duel_mark_effect");mark.setOwner(this.getContainer().getActor().getID());_target.getSkills().add(mark);this.getContainer().getActor().setDirty(true);::Brotherhood.logArchetypeTest("DUEL",this.getContainer().getActor(),"Challenged "+_target.getName()+" to a duel.");}
	function clearDuel( _reason = "the duel ended" )
	{
		local old = this.getDuelTarget();
		local ownerID = 0;
		if (this.getContainer() != null) ownerID = this.getContainer().getActor().getID();
		if (old != null)
		{
			foreach (mark in old.getSkills().m.Skills)
			{
				if (mark != null && mark.getID() == "effects.bh_duel_mark" && mark.m.OwnerID == ownerID) mark.removeSelf();
			}
		}
		if (this.m.TargetID != 0 && this.getContainer() != null) ::Brotherhood.logArchetypeTest("DUEL", this.getContainer().getActor(), "Cleared duel because " + _reason + ".");
		this.m.TargetID = 0;
	}
	function onAnySkillUsed(_skill,_target,_properties){if(_skill==null||!_skill.isAttack())return;local duel=this.validateTarget();if(duel==null)return;if(_target!=null&&_target.getID()==duel.getID()){_properties.MeleeSkill+=10;_properties.RangedSkill+=10;}else{_properties.MeleeSkill-=20;_properties.RangedSkill-=20;}}
	function onGetHitFactors(_skill,_targetTile,_tooltip){local duel=this.validateTarget();if(duel==null||!_targetTile.IsOccupiedByActor)return;if(_targetTile.getEntity().getID()==duel.getID())_tooltip.push({icon="ui/tooltips/positive.png",text=::MSU.Text.colorPositive("+10% ")+"Duel"});else _tooltip.push({icon="ui/tooltips/negative.png",text=::MSU.Text.colorNegative("-20% ")+"Duel"});}
	function onTargetKilled(_target,_skill){if(_target!=null&&_target.getID()==this.m.TargetID)this.clearDuel("the challenged enemy died");}
	function onDeath(_fatalityType){this.clearDuel("the challenger died");}
	function onTurnStart(){this.validateTarget();this.ensureActive();}
	function onCombatFinished(){this.clearDuel("combat finished");this.skill.onCombatFinished();}
	function onSerialize(_out){this.skill.onSerialize(_out);_out.writeU32(this.m.TargetID);}
	function onDeserialize(_in){this.skill.onDeserialize(_in);this.m.TargetID=_in.readU32();}
});
