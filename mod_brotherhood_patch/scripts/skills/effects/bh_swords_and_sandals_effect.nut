this.bh_swords_and_sandals_effect <- this.inherit("scripts/skills/skill", {
	m = { Bonus = 0 },
	function create()
	{
		this.m.ID = "effects.bh_swords_and_sandals";
		this.m.Name = "Swords and Sandals";
		this.m.Description = "The next attack deals additional damage based on the enemies who were surrounding this character.";
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
		ret.push({ id = 10, type = "text", icon = "ui/icons/damage_dealt.png", text = "The next attack deals " + ::MSU.Text.colorPositive("+" + this.m.Bonus + "%") + " damage" });
		return ret;
	}
	function onAnySkillUsed(_skill,_target,_properties){if(_skill!=null&&_skill.isAttack())_properties.DamageTotalMult*=1.0+this.m.Bonus*0.01;}
});
