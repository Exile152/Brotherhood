this.perk_bh_learning_devil <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_learning_devil";
		this.m.Name = "Learning Devil";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_21.png";
		::Brotherhood.applyCustomPerkIcon(this);
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function ensureProgressEffect()
	{
		if (!this.getContainer().hasSkill("effects.bh_learning_devil_permanent_changes"))
		{
			this.getContainer().add(this.new("scripts/skills/effects/bh_learning_devil_permanent_changes_effect"));
		}
	}

	function recordPermanentChange( _flag, _delta )
	{
		local flags = this.getContainer().getActor().getFlags();
		local prefix = _delta > 0 ? "BH_LearningDevilGain_" : "BH_LearningDevilLoss_";
		local key = prefix + _flag;
		local amount = ::Math.abs(_delta);
		flags.set(key, flags.has(key) ? flags.get(key) + amount : amount);
	}

	function onAdded() { this.ensureProgressEffect(); }
	function onUpdate( _properties ) { this.ensureProgressEffect(); }
	function onRemoved() { this.getContainer().removeByID("effects.bh_learning_devil_permanent_changes"); }

	function onLevelGained( _level )
	{
		local actor = this.getContainer().getActor();
		if (_level > 11)
		{
			::Brotherhood.logLatestObsidianTest("LEARNING DEVIL", actor, "Skipped Level " + _level + " because Learning Devil stops after Level 11.");
			return;
		}
		local b = actor.getBaseProperties();
		local attribute = ::Math.rand(0, this.Const.Attributes.COUNT - 1);
		local roll = ::Math.rand(1, 100);
		local delta = roll <= 10 ? -2 : 2;
		local name = "";
		local flag = "";

		switch (attribute)
		{
			case this.Const.Attributes.Hitpoints:
				b.Hitpoints += delta;
				actor.setHitpoints(::Math.max(1, actor.getHitpoints() + delta));
				name = "Hitpoints";
				flag = "Hitpoints";
				break;
			case this.Const.Attributes.Bravery:
				b.Bravery += delta;
				name = "Resolve";
				flag = "Resolve";
				break;
			case this.Const.Attributes.Fatigue:
				b.Stamina += delta;
				name = "Fatigue";
				flag = "Fatigue";
				break;
			case this.Const.Attributes.Initiative:
				b.Initiative += delta;
				name = "Initiative";
				flag = "Initiative";
				break;
			case this.Const.Attributes.MeleeSkill:
				b.MeleeSkill += delta;
				name = "Melee Attack";
				flag = "MeleeAttack";
				break;
			case this.Const.Attributes.RangedSkill:
				b.RangedSkill += delta;
				name = "Ranged Attack";
				flag = "RangedAttack";
				break;
			case this.Const.Attributes.MeleeDefense:
				b.MeleeDefense += delta;
				name = "Melee Defense";
				flag = "MeleeDefense";
				break;
			case this.Const.Attributes.RangedDefense:
				b.RangedDefense += delta;
				name = "Ranged Defense";
				flag = "RangedDefense";
				break;
		}

		this.recordPermanentChange(flag, delta);
		this.ensureProgressEffect();
		actor.getSkills().update();
		actor.setDirty(true);
		::Brotherhood.logLatestObsidianTest("LEARNING DEVIL", actor, "Reached Level " + _level + "; roll=" + roll + "; applied " + (delta > 0 ? "+" : "") + delta + " " + name + ".");
	}
});
