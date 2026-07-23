this.bh_fabula_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.bh_fabula";
		this.m.Name = "Fabula";
		this.m.Description = "Tell a fable that rallies an ally using the Bard's Resolve.";
		this.m.Icon = "skills/active_56.png";
		this.m.IconDisabled = "skills/active_56_sw.png";
		this.m.Overlay = "active_56";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any - 1;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
	}
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({ id = 10, type = "text", icon = "ui/icons/morale.png", text = ::Reforged.Mod.Tooltips.parseString("Triggers a positive [morale check|Concept.Morale] using the Bard's [Resolve|Concept.Bravery] instead of the target's") });
		return ret;
	}
	function isHidden()
	{
		if (this.skill.isHidden()) return true;
		local container = this.getContainer();
		return container == null || !::Brotherhood.canUseLuteSkills(container.getActor());
	}
	function isUsable(){return ::Brotherhood.canUseLuteSkills(this.getContainer().getActor())&&this.skill.isUsable();}
	function onVerifyTarget(_o,_t){return _t.IsOccupiedByActor&&_o.getDistanceTo(_t)<=4&&_t.getEntity().isAlliedWith(this.getContainer().getActor());}
	function onUse(_u,_t){local target=_t.getEntity();local difficulty=_u.getCurrentProperties().getBravery()-target.getCurrentProperties().getBravery();local before=target.getMoraleState();local result=target.checkMorale(1,difficulty);::Brotherhood.logObsidianTest("FABULA",_u,"Positive morale check for "+target.getName()+" used Bard Resolve; difficulty adjustment "+difficulty+", morale "+before+" -> "+target.getMoraleState()+", result="+(result?"true":"false")+".");return true;}
});
