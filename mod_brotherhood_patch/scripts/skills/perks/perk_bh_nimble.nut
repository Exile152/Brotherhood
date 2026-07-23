// Brotherhood-scoped copy of vanilla Nimble. Reforged replaces the original
// perk's formula and adds armor mitigation plus a Reach interaction, so this
// separate ID preserves vanilla behavior without changing Reforged elsewhere.
this.perk_bh_nimble <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_nimble";
		this.m.Name = "Nimble";
		this.m.Description = ::Brotherhood.getVanillaNimbleTooltip();
		this.m.Icon = "ui/perks/perk_29.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function isHidden()
	{
		return this.Math.floor(this.getChance() * 100) >= 100;
	}

	function getDescription()
	{
		return "Nimble like a cat! This character is able to partially evade or deflect attacks at the last moment, turning them into glancing hits. The lighter the armor, the more you benefit.";
	}

	function getTooltip()
	{
		local damageReceived = this.Math.round(this.getChance() * 100);
		local ret = this.skill.getTooltip();

		if (damageReceived < 100)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive [color=" + this.Const.UI.Color.PositiveValue + "]" + damageReceived + "%[/color] of any damage to hitpoints from attacks"
			});
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]This character's body and head armor are too heavy as to gain any benefit from being nimble[/color]"
			});
		}

		return ret;
	}

	function getChance()
	{
		local fatiguePenalty = 0;
		local items = this.getContainer().getActor().getItems();
		local body = items.getItemAtSlot(this.Const.ItemSlot.Body);
		local head = items.getItemAtSlot(this.Const.ItemSlot.Head);
		if (body != null) fatiguePenalty += body.getStaminaModifier();
		if (head != null) fatiguePenalty += head.getStaminaModifier();

		fatiguePenalty = this.Math.min(0, fatiguePenalty + 15);
		return this.Math.minf(1.0, 0.40 + this.Math.pow(this.Math.abs(fatiguePenalty), 1.23) * 0.01);
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID()
			|| _skill == null || !_skill.isAttack() || !_skill.isUsingHitchance())
		{
			return;
		}

		_properties.DamageReceivedRegularMult *= this.getChance();
	}
});
