this.bh_swords_and_sandals_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.bh_swords_and_sandals";
		this.m.Name = "Swords and Sandals";
		this.m.Description = "Give a gladiatorial flourish to an ally's next attack.";
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
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 20;
		this.m.MinRange = 0;
		this.m.MaxRange = 4;
	}
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({ id = 10, type = "text", icon = "ui/icons/damage_dealt.png", text = "The target's next attack deals " + ::MSU.Text.colorPositive("+5%") + " damage per enemy currently adjacent to them" });
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
	function onUse(_u,_t){local target=_t.getEntity();local adjacent=::Brotherhood.getAdjacentEnemies(target).len();local bonus=adjacent*5;target.getSkills().removeByID("effects.bh_swords_and_sandals");local e=this.new("scripts/skills/effects/bh_swords_and_sandals_effect");e.setBonus(bonus);target.getSkills().add(e);::Brotherhood.logObsidianTest("SWORDS AND SANDALS",_u,"Applied +"+bonus+"% next-attack damage to "+target.getName()+" from "+adjacent+" adjacent enemies.");return true;}
});
