this.perk_bh_splitter <- this.inherit("scripts/skills/skill", {
	m = {
		GrantedSkill = null,
		GrantedWeapon = null,
		OriginalShieldDamage = 0,
		OriginalFatigueCost = 0,
		OriginalSkillOrder = 0,
		IsGrantedSkill = false
	},

	function create()
	{
		this.m.ID = "perk.bh_splitter";
		this.m.Name = "Splitter";
		this.m.Description = ::Brotherhood.getBruteLaborerTooltip(this.m.ID);
		this.m.Icon = "ui/perks/perk_21.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function getWeapon()
	{
		return this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
	}

	function isEligible( _weapon )
	{
		return _weapon != null
			&& _weapon.isItemType(this.Const.Items.ItemType.Weapon)
			&& !_weapon.isItemType(this.Const.Items.ItemType.RangedWeapon)
			&& _weapon.getRangeMax() <= 1;
	}

	function getFirstAttackSkill( _weapon )
	{
		if (_weapon == null) return null;
		if ("SkillPtrs" in _weapon.m) foreach (skill in _weapon.m.SkillPtrs)
		{
			if (skill != null && skill.getID() != "actives.split_shield" && skill.isAttack()) return skill;
		}
		foreach (skill in this.getContainer().m.Skills)
		{
			if (skill != null && skill.getID() != "actives.split_shield" && skill.isAttack() && skill.getItem() == _weapon) return skill;
		}
		return null;
	}

	function calculateShieldDamage( _weapon, _attack )
	{
		local damage = 0;
		if (_attack == null)
		{
			local actorProperties = this.getContainer().getActor().getCurrentProperties();
			damage = ::Math.max(1, ::Math.round((_weapon.m.RegularDamage + _weapon.m.RegularDamageMax) * 0.5 * actorProperties.MeleeDamageMult));
		}
		else
		{
			local properties = this.getContainer().buildPropertiesForUse(_attack, null);
			local average = (properties.DamageRegularMin + properties.DamageRegularMax) * 0.5;
			average *= properties.DamageTotalMult * properties.MeleeDamageMult;
			damage = ::Math.max(1, ::Math.round(average));
		}
		damage = ::Math.max(1, ::Math.round(damage * 0.8));
		return damage;
	}

	function removeGrantedSkill()
	{
		if (this.m.GrantedWeapon != null)
		{
			this.m.GrantedWeapon.m.ShieldDamage = this.m.OriginalShieldDamage;
			if (this.m.GrantedSkill != null)
			{
				if (this.m.IsGrantedSkill)
				{
					this.getContainer().remove(this.m.GrantedSkill);
					this.m.GrantedSkill.setItem(null);
				}
				else
				{
					this.m.GrantedSkill.setFatigueCost(this.m.OriginalFatigueCost);
					this.m.GrantedSkill.setOrder(this.m.OriginalSkillOrder);
				}
			}
		}
		this.m.GrantedSkill = null;
		this.m.GrantedWeapon = null;
		this.m.IsGrantedSkill = false;
	}

	function findWeaponSmashShield( _weapon )
	{
		if (_weapon == null || !("SkillPtrs" in _weapon.m)) return null;
		foreach (skill in _weapon.m.SkillPtrs)
		{
			if (skill != null && skill.getID() == "actives.split_shield") return skill;
		}
		return null;
	}

	function configureSmashShield( _weapon, _smash, _isGranted )
	{
		local attack = this.getFirstAttackSkill(_weapon);
		local shieldDamage = this.calculateShieldDamage(_weapon, attack);
		local rawFatigue = attack == null ? 15 : attack.getFatigueCostRaw();

		this.m.GrantedWeapon = _weapon;
		this.m.GrantedSkill = _smash;
		this.m.OriginalShieldDamage = _weapon.m.ShieldDamage;
		this.m.OriginalFatigueCost = _smash.getFatigueCostRaw();
		this.m.OriginalSkillOrder = _smash.getOrder();
		this.m.IsGrantedSkill = _isGranted;
		_weapon.m.ShieldDamage = shieldDamage;
		_smash.setFatigueCost(rawFatigue);
		if (_isGranted) _smash.setOrder(this.Const.SkillOrder.Any - 1);

		local sourceName = attack == null ? "weapon-stat fallback" : attack.getName();
		local mode = _isGranted ? "Granted" : "Buffed native";
		::Brotherhood.logArchetypeTest("SPLITTER", this.getContainer().getActor(), mode + " weapon-bound Smash Shield using " + sourceName + ": shield damage=" + shieldDamage + ", raw Fatigue=" + rawFatigue + ".");
	}

	function grantForWeapon( _weapon )
	{
		local smash = this.new("scripts/skills/actives/split_shield");
		smash.m.BH_FromSplitter <- true;
		smash.setOrder(this.Const.SkillOrder.Any - 1);
		// Bind calculations to the weapon without inserting into SkillPtrs.
		// Weapon-owned insertion causes item clearSkills() to corrupt its normal
		// attack list during equip/unequip transitions.
		smash.setItem(_weapon);
		this.getContainer().add(smash);
		this.configureSmashShield(_weapon, smash, true);
	}

	function onUpdate( _properties )
	{
		local weapon = this.getWeapon();
		if (this.m.GrantedWeapon != null && (weapon != this.m.GrantedWeapon || !this.isEligible(weapon))) this.removeGrantedSkill();
		if (!this.isEligible(weapon) || this.m.GrantedWeapon != null) return;
		local nativeSmash = this.findWeaponSmashShield(weapon);
		if (nativeSmash != null) this.configureSmashShield(weapon, nativeSmash, false);
		else this.grantForWeapon(weapon);
	}

	function onRemoved()
	{
		this.removeGrantedSkill();
	}

	function onTargetHit( _skill, _target, _part, _hp, _armor )
	{
		if (_skill == null || _target == null || _skill.getID() != "actives.split_shield" || _target.isArmedWithShield()) return;
		local turns = ::Math.max(1, ::Math.floor(this.getContainer().getActor().getCurrentProperties().MeleeSkill * 0.03));
		local effect = this.new("scripts/skills/effects/bh_splitter_no_double_grip_effect");
		effect.setTurns(turns);
		_target.getSkills().add(effect);
		::Brotherhood.logArchetypeTest("SPLITTER", this.getContainer().getActor(), "Destroyed " + _target.getName() + "'s shield; denied Double Grip for " + turns + " turns.");
	}
});
