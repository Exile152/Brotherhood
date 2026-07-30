this.perk_bh_evasive <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_evasive";
		this.m.Name = "Evasive";
		this.m.Description = ::Brotherhood.getEvasiveTooltip();
		this.m.Icon = "ui/perks/bh_evasive.png";
		this.m.IconDisabled = "ui/perks/bh_evasive_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function getArmorFatiguePenalty()
	{
		local items = this.getContainer().getActor().getItems();
		local modifier = 0;
		foreach (slot in [this.Const.ItemSlot.Body, this.Const.ItemSlot.Head])
		{
			local item = items.getItemAtSlot(slot);
			if (item != null) modifier += item.getStaminaModifier();
		}

		return this.Math.max(0, -modifier);
	}

	function gainElusive( _reason )
	{
		if (this.getContainer().hasSkill("effects.bh_elusive")) return;

		this.getContainer().add(this.new("scripts/skills/effects/bh_elusive_effect"));
		::Brotherhood.logArmorDoctrineTest(this.getContainer().getActor(), "Gained Evasive: " + _reason + ".");
	}

	function onCombatStarted()
	{
		this.skill.onCombatStarted();
		local penalty = this.getArmorFatiguePenalty();
		if (penalty <= 5)
		{
			this.gainElusive("combat began with combined armor Fatigue penalty " + penalty.tostring());
		}
		else
		{
			::Brotherhood.logArmorDoctrineTest(this.getContainer().getActor(), "Did not begin combat Evasive; combined armor Fatigue penalty is " + penalty.tostring() + ".");
		}
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (!::Brotherhood.hasEnemyWithinDistance(actor, 1))
		{
			this.gainElusive("turn began without an adjacent enemy");
		}
	}

	function onCombatFinished()
	{
		this.getContainer().removeByID("effects.bh_elusive");
		this.skill.onCombatFinished();
	}
});
