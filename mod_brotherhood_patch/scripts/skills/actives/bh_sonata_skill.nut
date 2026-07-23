this.bh_sonata_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.bh_sonata";
		this.m.Name = "Sonata";
		this.m.Description = "Prepare an ally's next attack with a rousing melody.";
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
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
	}
	function getTooltip()
	{
		local bonus = ::Math.floor(this.getContainer().getActor().getCurrentProperties().getBravery() * 0.20);
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = ::Reforged.Mod.Tooltips.parseString(
				"The target's next attack gains " + ::MSU.Text.colorPositive(bonus + "%")
				+ " chance to hit (" + ::MSU.Text.colorPositive("20%") + " of the user's [Resolve|Concept.Bravery])"
			)
		});
		ret.push({ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = ::Reforged.Mod.Tooltips.parseString("The target's next attack builds " + ::MSU.Text.colorPositive("50%") + " less [Fatigue|Concept.Fatigue]") });
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
	function onUse(_u,_t){local target=_t.getEntity();local bonus=::Math.floor(_u.getCurrentProperties().getBravery()*0.20);target.getSkills().removeByID("effects.bh_sonata");local e=this.new("scripts/skills/effects/bh_sonata_effect");e.setBonus(bonus);target.getSkills().add(e);::Brotherhood.logObsidianTest("SONATA",_u,"Applied +"+bonus+" hit chance and 50% Fatigue reduction to "+target.getName()+"'s next attack.");return true;}
});
