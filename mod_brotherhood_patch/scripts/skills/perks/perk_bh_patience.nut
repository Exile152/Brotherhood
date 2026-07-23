this.perk_bh_patience <- this.inherit("scripts/skills/skill", {
	m={Stacks=0,LastCountedSkillCounter=0},
	function create(){this.m.ID="perk.bh_patience";this.m.Name="Patience";this.m.Description=::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.berserk","ui/perks/perk_35.png");this.m.Type=this.Const.SkillType.Perk|this.Const.SkillType.StatusEffect;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;this.m.IsHidden=true;}
	function getDescription(){return "The next attack deals "+::MSU.Text.colorPositive("+"+(this.m.Stacks*10)+"%")+" damage.";}
	function onUpdate(_properties){this.m.IsHidden=this.m.Stacks==0;}
	function recordNonDamagingSkill( _skill )
	{
		if (_skill == null || _skill.isAttack() || this.m.LastCountedSkillCounter == this.Const.SkillCounter) return;
		this.m.LastCountedSkillCounter = this.Const.SkillCounter;
		++this.m.Stacks;
		this.m.IsHidden = false;
		this.getContainer().getActor().setDirty(true);
		::Brotherhood.logArchetypeTest("PATIENCE", this.getContainer().getActor(), "Used non-damaging " + _skill.getName() + "; stacks=" + this.m.Stacks + ".");
	}
	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (_skill != null && _skill.isAttack() && this.m.Stacks > 0)
		{
			_properties.DamageTotalMult *= 1.0 + this.m.Stacks * 0.10;
		}
	}
	function onAnySkillExecutedFully( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (_skill == null || !_skill.isAttack() || this.m.Stacks == 0) return;
		local consumed = this.m.Stacks;
		::Brotherhood.logArchetypeTest("PATIENCE", this.getContainer().getActor(), "Applied and consumed " + consumed + " stack(s) for +" + (consumed * 10) + "% damage on " + _skill.getName() + ".");
		this.reset();
		this.getContainer().getActor().setDirty(true);
	}
	function reset(){this.m.Stacks=0;this.m.LastCountedSkillCounter=0;this.m.IsHidden=true;}
	function onTurnStart(){this.reset();}function onTurnEnd(){this.reset();}function onCombatStarted(){this.reset();}function onCombatFinished(){this.reset();this.skill.onCombatFinished();}
});
