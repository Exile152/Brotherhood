this.perk_bh_ambition <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_ambition";
		this.m.Name = "Ambition";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_ambition.png";
		this.m.IconDisabled = "ui/perks/bh_ambition_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local flags = actor.getFlags();
		if (flags.has("BH_AmbitionGranted")) return;

		local zeroStarAttributes = [];
		for (local i = 0; i < this.Const.Attributes.COUNT; ++i)
		{
			if (actor.m.Talents[i] == 0) zeroStarAttributes.push(i);
		}

		local properties = actor.getBaseProperties();
		foreach (attribute in zeroStarAttributes)
		{
			switch (attribute)
			{
				case this.Const.Attributes.Hitpoints:
					properties.Hitpoints += 1;
					actor.setHitpoints(actor.getHitpoints() + 1);
					break;
				case this.Const.Attributes.Bravery: properties.Bravery += 1; break;
				case this.Const.Attributes.Fatigue: properties.Stamina += 1; break;
				case this.Const.Attributes.Initiative: properties.Initiative += 1; break;
				case this.Const.Attributes.MeleeSkill: properties.MeleeSkill += 1; break;
				case this.Const.Attributes.RangedSkill: properties.RangedSkill += 1; break;
				case this.Const.Attributes.MeleeDefense: properties.MeleeDefense += 1; break;
				case this.Const.Attributes.RangedDefense: properties.RangedDefense += 1; break;
			}
			actor.m.Talents[attribute] = 1;
		}

		flags.set("BH_AmbitionGranted", zeroStarAttributes.len());
		actor.getSkills().update();
		actor.setDirty(true);
		if (zeroStarAttributes.len() == 0)
		{
			::Brotherhood.logLatestObsidianTest("AMBITION", actor, "No zero-star attributes were eligible for a permanent gain.");
		}
		else
		{
			::Brotherhood.logLatestObsidianTest("AMBITION", actor, "Granted +1 and one talent star to " + zeroStarAttributes.len() + " zero-star attribute(s).");
		}
	}
});
