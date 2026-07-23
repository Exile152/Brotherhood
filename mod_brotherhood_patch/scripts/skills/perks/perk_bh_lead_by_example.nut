this.perk_bh_lead_by_example <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_lead_by_example";
		this.m.Name = "Lead by Example";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.rally_the_troops", "ui/perks/perk_21.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function isBannerAttack( _skill )
	{
		if (_skill == null || !_skill.isAttack()) return false;
		local item = _skill.getItem();
		return item != null && item.isItemType(this.Const.Items.ItemType.Tool) && item.isItemType(this.Const.Items.ItemType.Banner);
	}
	function rallyLowestMoraleAlly( _forceSuccess = false )
	{
		local actor = this.getContainer().getActor();
		local lowest = null;
		foreach (entity in this.Tactical.Entities.getAllInstancesAsArray())
		{
			if (entity == null || !entity.isAlive() || entity.isDying() || !entity.isAlliedWith(actor) || entity == actor) continue;
			if (lowest == null || entity.getMoraleState() < lowest.getMoraleState()) lowest = entity;
		}
		if (lowest == null) return;
		if (_forceSuccess) lowest.setMoraleState(this.Const.MoraleState.Steady);
		else lowest.checkMorale(this.Const.MoraleCheckType.Positive, 1, "Inspired by " + actor.getName());
		::Brotherhood.logFleshcraftMechanic("LEAD BY EXAMPLE", actor, (_forceSuccess ? "Automatically raised" : "Prompted a morale check for") + " " + lowest.getName() + ".");
	}
	function onTargetHit( _skill, _target, _bodyPart, _damage, _armorDamage )
	{
		if (!this.isBannerAttack(_skill)) return;
		this.rallyLowestMoraleAlly(false);
	}
	function onTargetKilled( _target, _skill )
	{
		if (!this.isBannerAttack(_skill)) return;
		this.rallyLowestMoraleAlly(true);
	}
});
