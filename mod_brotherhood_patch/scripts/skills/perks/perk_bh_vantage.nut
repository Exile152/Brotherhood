this.perk_bh_vantage <- this.inherit("scripts/skills/skill", {
	m = {
		HasMovedUphill = false,
		HasUsedFollowupMove = false,
		HasLowerGroundAttackBonus = false
	},
	function create()
	{
		this.m.ID = "perk.bh_vantage";
		this.m.Name = "Vantage";
		this.m.Description = ::Brotherhood.getMobilityPerkTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_05.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.m.HasLowerGroundAttackBonus;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HasLowerGroundAttackBonus)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString("The next attack against an enemy on lower ground gains " + ::MSU.Text.colorPositive("+10%") + " chance to hit.")
			});
		}

		return ret;
	}

	function onCostsPreview( _costsPreview )
	{
		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPreviewing()) return;

		::Brotherhood.applyMovementPreviewCostsToCostsPreview(actor, _costsPreview);
	}

	function hasLowerGroundAttackBonusFor( _skill, _targetEntity )
	{
		if (!this.m.HasLowerGroundAttackBonus || _skill == null || !_skill.isAttack() || _targetEntity == null) return false;

		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap() || !_targetEntity.isPlacedOnMap()) return false;

		return _targetEntity.getTile().Level < actor.getTile().Level;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (!this.hasLowerGroundAttackBonusFor(_skill, _targetEntity)) return;

		if (_skill.isRanged()) _properties.RangedSkill += 10;
		else _properties.MeleeSkill += 10;

		this.m.HasLowerGroundAttackBonus = false;
	}

	function onGetHitFactors( _skill, _targetTile, _tooltip )
	{
		if (!this.m.HasLowerGroundAttackBonus || _skill == null || !_skill.isAttack()) return;
		if (_targetTile == null || !_targetTile.IsOccupiedByActor) return;

		local actor = this.getContainer().getActor();
		if (actor == null || !actor.isPlacedOnMap()) return;
		if (_targetTile.Level >= actor.getTile().Level) return;

		_tooltip.push({
			icon = "ui/tooltips/positive.png",
			text = ::MSU.Text.colorPositive("10% ") + this.getName()
		});
	}

	function onTurnStart()
	{
		this.m.HasMovedUphill = false;
		this.m.HasUsedFollowupMove = false;
		this.m.HasLowerGroundAttackBonus = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.HasMovedUphill = false;
		this.m.HasUsedFollowupMove = false;
		this.m.HasLowerGroundAttackBonus = false;
	}
});
