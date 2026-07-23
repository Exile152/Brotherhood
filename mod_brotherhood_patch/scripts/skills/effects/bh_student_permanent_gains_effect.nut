this.bh_student_permanent_gains_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.bh_student_permanent_gains";
		this.m.Name = "Lessons Learned";
		this.m.Description = "Let's see which:";
		local perk = ::Const.Perks.findById("perk.bh_student");
		this.m.Icon = perk == null ? "ui/perks/perk_21.png" : perk.Icon;
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = false;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		local actor = this.getContainer().getActor();

		local gains = [
			["Hitpoints", "Hitpoints", "ui/icons/health.png"],
			["Resolve", "Resolve", "ui/icons/bravery.png"],
			["Fatigue", "Fatigue", "ui/icons/fatigue.png"],
			["Initiative", "Initiative", "ui/icons/initiative.png"],
			["MeleeAttack", "Melee Attack", "ui/icons/melee_skill.png"],
			["RangedAttack", "Ranged Attack", "ui/icons/ranged_skill.png"],
			["MeleeDefense", "Melee Defense", "ui/icons/melee_defense.png"],
			["RangedDefense", "Ranged Defense", "ui/icons/ranged_defense.png"]
		];
		local recorded = 0;
		foreach (gain in gains)
		{
			local key = "BH_StudentPermanentGain_" + gain[0];
			if (!actor.getFlags().has(key)) continue;
			local amount = actor.getFlags().get(key);
			if (amount <= 0) continue;
			recorded += amount;
			ret.push({ id = 20 + recorded, type = "text", icon = gain[2], text = ::MSU.Text.colorPositive("+" + amount) + " " + gain[1] + " learned through battle" });
		}
		if (recorded == 0)
		{
			ret.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "None yet." });
		}
		return ret;
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().hasSkill("perk.bh_student")) this.removeSelf();
	}
});
