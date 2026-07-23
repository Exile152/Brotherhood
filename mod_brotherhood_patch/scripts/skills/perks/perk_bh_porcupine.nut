this.perk_bh_porcupine <- this.inherit("scripts/skills/skill", {
	m = { TargetID = null, Count = 0 },
	function create(){this.m.ID="perk.bh_porcupine";this.m.Name="Point Blank";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.bullseye","ui/perks/perk_17.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function isHidden(){return this.m.TargetID==null;}
	function onAnySkillUsed(_s,_t,_p){if(_s!=null&&_s.isAttack()&&_s.isRanged()&&_t!=null&&this.m.TargetID==_t.getID()&&this.m.Count>0)_p.DamageTotalMult*=1.15;}
	function onAnySkillExecutedFully(_s,_tile,_target,_free)
	{
		if(_s==null||!_s.isAttack()||!_s.isRanged()||_target==null)return;
		if(this.m.TargetID==_target.getID())++this.m.Count;
		else
		{
			this.m.TargetID=_target.getID();
			this.m.Count=1;
		}
		this.getContainer().update();
	}
	function reset(){this.m.TargetID=null;this.m.Count=0;}
	function onTurnStart(){this.reset();}
	function onTurnEnd(){this.reset();}
	function onCombatFinished(){this.reset();this.skill.onCombatFinished();}
});
