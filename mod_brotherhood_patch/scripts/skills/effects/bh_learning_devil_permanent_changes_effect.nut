this.bh_learning_devil_permanent_changes_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.bh_learning_devil_permanent_changes";
		this.m.Name = "Devilish Lessons";
		this.m.Description = "Every level leaves a permanent mark, for better or worse.";
		local perk = ::Const.Perks.findById("perk.bh_learning_devil");
		this.m.Icon = perk == null ? "ui/perks/bh_learning_devil.png" : perk.Icon;
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
		local attributes = [
			["Hitpoints", "Hitpoints", "ui/icons/health.png"],
			["Resolve", "Resolve", "ui/icons/bravery.png"],
			["Fatigue", "Fatigue", "ui/icons/fatigue.png"],
			["Initiative", "Initiative", "ui/icons/initiative.png"],
			["MeleeAttack", "Melee Attack", "ui/icons/melee_skill.png"],
			["RangedAttack", "Ranged Attack", "ui/icons/ranged_skill.png"],
			["MeleeDefense", "Melee Defense", "ui/icons/melee_defense.png"],
			["RangedDefense", "Ranged Defense", "ui/icons/ranged_defense.png"]
		];
		local entries = 0;
		foreach (attribute in attributes)
		{
			local gainKey = "BH_LearningDevilGain_" + attribute[0];
			if (actor.getFlags().has(gainKey))
			{
				local gain = actor.getFlags().get(gainKey);
				if (gain > 0)
				{
					++entries;
					ret.push({ id = 20 + entries, type = "text", icon = attribute[2], text = ::MSU.Text.colorPositive("+" + gain) + " " + attribute[1] + " from Learning Devil" });
				}
			}

			local lossKey = "BH_LearningDevilLoss_" + attribute[0];
			if (actor.getFlags().has(lossKey))
			{
				local loss = actor.getFlags().get(lossKey);
				if (loss > 0)
				{
					++entries;
					ret.push({ id = 20 + entries, type = "text", icon = attribute[2], text = ::MSU.Text.colorNegative("-" + loss) + " " + attribute[1] + " from Learning Devil" });
				}
			}
		}
		if (entries == 0)
		{
			ret.push({ id = 20, type = "hint", icon = "ui/icons/special.png", text = "No level has left a mark yet." });
		}
		return ret;
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().hasSkill("perk.bh_learning_devil")) this.removeSelf();
	}
});
