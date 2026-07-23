this.bh_elusive_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.bh_elusive";
		this.m.Name = "Elusive";
		this.m.Description = "The next direct attack that would hit this character misses instead.";
		this.m.Icon = "ui/perks/bh_evasive.png";
		this.m.IconDisabled = "ui/perks/bh_evasive_sw.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "The next direct attack that would hit misses instead, then Elusive is removed"
		});
		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Natural misses do not remove Elusive"
		});
		return ret;
	}

	function setElusiveVisual( _isActive )
	{
		if (this.getContainer() == null) return;

		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap()) return;

		if (_isActive)
		{
			actor.fadeTo(this.createColor("ffffffb3"), 150);
			::Brotherhood.logArmorDoctrineTest(actor, "Elusive visual applied at 70% opacity.");
		}
		else
		{
			actor.fadeToStoredColors(150);
			::Brotherhood.logArmorDoctrineTest(actor, "Elusive visual removed and normal opacity restored.");
		}
	}

	function onAdded()
	{
		this.setElusiveVisual(true);
	}

	function onMovementFinished()
	{
		this.setElusiveVisual(true);
	}

	function onRemoved()
	{
		this.setElusiveVisual(false);
	}

	function onDeath( _fatalityType )
	{
		this.setElusiveVisual(false);
	}

	function consumeElusive( _skill, _attacker )
	{
		local actor = this.getContainer().getActor();
		this.spawnIcon("perk_01", actor.getTile());
		::Brotherhood.logArmorDoctrineTest(actor, "Elusive converted a hit from " + _skill.getName() + " into a miss and was removed.");
		this.removeSelf();
		return true;
	}
});
