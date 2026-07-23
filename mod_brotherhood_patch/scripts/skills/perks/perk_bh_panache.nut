this.perk_bh_panache <- this.inherit("scripts/skills/skill", {
	m = { WasConfident = false },
	function create()
	{
		this.m.ID = "perk.bh_panache";
		this.m.Name = "Panache";
		this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_21.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}
	function isHidden() { return this.getContainer().getActor().getMoraleState() != this.Const.MoraleState.Confident; }
	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = "This character's confidence is enhanced by Panache."
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::MSU.Text.colorPositive("+20%") + " Melee Defense"
			}
		];
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local confident = actor.getMoraleState() == this.Const.MoraleState.Confident;
		if (confident) _properties.MeleeDefenseMult *= 1.20;
		if (confident != this.m.WasConfident) ::Brotherhood.logDuelistTest(actor, "Panache Confident defense bonus " + (confident ? "activated (+20% Melee Defense)." : "deactivated."));
		this.m.WasConfident = confident;
	}
	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill.isAttack() && _targetEntity != null && this.Math.rand(1, 100) <= 33)
		{
			local actor = this.getContainer().getActor();
			local succeeded = actor.checkMorale(1, 20);
			::Brotherhood.logDuelistTest(actor, "Panache positive morale roll " + (succeeded ? "succeeded." : "failed."));
		}
	}
});
