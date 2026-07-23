// Brotherhood-scoped copy of vanilla Battle Forged. Reforged adds an
// offensive Reach effect to the original perk, so this separate ID preserves
// vanilla behavior without changing Reforged elsewhere.
this.perk_bh_battle_forged <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bh_battle_forged";
		this.m.Name = "Battle Forged";
		this.m.Description = ::Brotherhood.getVanillaBattleForgedTooltip();
		this.m.Icon = "ui/perks/perk_03.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getArmorDamageReceived()
	{
		local actor = this.getContainer().getActor();
		local armor = actor.getArmor(this.Const.BodyPart.Head) + actor.getArmor(this.Const.BodyPart.Body);
		return 1.0 - armor * 0.05 * 0.01;
	}

	function isHidden()
	{
		return this.Math.floor(this.getArmorDamageReceived() * 100) >= 100;
	}

	function getDescription()
	{
		return "Specialize in heavy armor! By making your armor even more resilient, you can take more blows and hit back. Armor damage taken is reduced by a percentage equal to [color=" + this.Const.UI.Color.PositiveValue + "]5%[/color] of the current total armor value of both body and head armor.";
	}

	function getTooltip()
	{
		local damageReceived = this.Math.floor(this.getArmorDamageReceived() * 100);
		local ret = this.skill.getTooltip();

		if (damageReceived < 100)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Only receive [color=" + this.Const.UI.Color.PositiveValue + "]" + damageReceived + "%[/color] of any damage to armor from attacks"
			});
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]This character's armor isn't protective enough to grant any benefit from having the Battle Forged perk[/color]"
			});
		}

		return ret;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_attacker != null && _attacker.getID() == this.getContainer().getActor().getID()
			|| _skill != null && !_skill.isAttack())
		{
			return;
		}

		_properties.DamageReceivedArmorMult *= this.getArmorDamageReceived();
	}
});
