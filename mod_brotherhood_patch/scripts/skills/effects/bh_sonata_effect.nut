this.bh_sonata_effect <- this.inherit("scripts/skills/skill", {
	m = { Bonus = 0 },
	function create()
	{
		this.m.ID = "effects.bh_sonata";
		this.m.Name = "Sonata";
		this.m.Description = "The next attack gains accuracy and builds half as much Fatigue.";
		this.m.Icon = "ui/perks/perk_28.png";
		this.m.IconMini = "perk_28_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function setBonus(_value){this.m.Bonus=_value;}
	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({ id = 10, type = "text", icon = "ui/icons/hitchance.png", text = "The next attack gains " + ::MSU.Text.colorPositive("+" + this.m.Bonus) + " chance to hit" });
		ret.push({ id = 11, type = "text", icon = "ui/icons/fatigue.png", text = ::Reforged.Mod.Tooltips.parseString("The next attack builds " + ::MSU.Text.colorPositive("50%") + " less [Fatigue|Concept.Fatigue]") });
		return ret;
	}
	function onAnySkillUsed(_skill,_target,_properties){if(_skill!=null&&_skill.isAttack()){_properties.MeleeSkill+=this.m.Bonus;_properties.RangedSkill+=this.m.Bonus;}}
});
