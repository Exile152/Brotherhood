this.bh_perfect_thrust_skill <- this.inherit("scripts/skills/skill", {
	m = { ConsumedActionPoints = 0, IsExecuting = false, SourceSkill = null },
	function create()
	{
		this.m.ID = "actives.bh_perfect_thrust";
		this.m.Name = "Perfect Thrust";
		this.m.Description = "Use your equipped melee weapon's first piercing attack against a Dazed, Stunned, or Netted enemy.";
		this.m.Icon = "skills/active_04.png";
		this.m.IconDisabled = "skills/active_04_sw.png";
		this.m.Overlay = "active_04";
		// Match vanilla Thrust: the use sound is heard on every attempt, while
		// the impact sound is added only when the attack connects.
		this.m.SoundOnUse = [
			"sounds/combat/thrust_01.wav",
			"sounds/combat/thrust_02.wav",
			"sounds/combat/thrust_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/thrust_hit_01.wav",
			"sounds/combat/thrust_hit_02.wav",
			"sounds/combat/thrust_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any - 1;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}
	function hasMeleeWeapon()
	{
		return this.getSourceSkill() != null;
	}
	function isPiercingSourceSkill( _source )
	{
		if (_source == null || _source.isRanged() || _source.m.InjuriesOnBody == null) return false;
		local injuries = _source.m.InjuriesOnBody;
		return injuries == this.Const.Injury.PiercingBody
			|| injuries == this.Const.Injury.CuttingAndPiercingBody
			|| injuries == this.Const.Injury.BluntAndPiercingBody
			|| injuries == this.Const.Injury.BurningAndPiercingBody;
	}
	function isHidden()
	{
		// Keep the granted active visible. A temporarily invalid equipment setup
		// disables it through isUsable() instead of making it disappear entirely.
		return this.skill.isHidden();
	}
	function isUsable()
	{
		local source = this.getSourceSkill();
		local hasMelee = source != null && !source.isRanged();
		local hasPiercing = this.isPiercingSourceSkill(source);
		local baseUsable = this.skill.isUsable();
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null) ::Brotherhood.logArchetypeTest("PERFECT THRUST", actor, "isUsable source=" + (source == null ? "null" : source.getID()) + " melee=" + hasMelee + " piercing=" + hasPiercing + " base=" + baseUsable + " AP=" + actor.getActionPoints() + "/" + this.getActionPointCost() + " fatigue=" + actor.getFatigue() + "/" + actor.getFatigueMax() + ".");
		return hasPiercing && baseUsable;
	}
	function isUsableOn( _targetTile, _userTile = null )
	{
		local ret = this.skill.isUsableOn(_targetTile, _userTile);
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null)
		{
			local targetName = _targetTile == null || !_targetTile.IsOccupiedByActor ? "empty" : _targetTile.getEntity().getName();
			local origin = _userTile == null ? actor.getTile() : _userTile;
			local distance = _targetTile == null || origin == null ? -1 : origin.getDistanceTo(_targetTile);
			::Brotherhood.logArchetypeTest("PERFECT THRUST", actor, "isUsableOn target=" + targetName + " result=" + ret + " distance=" + distance + " visible=" + (_targetTile == null ? false : _targetTile.IsVisibleForEntity) + " affordable=" + this.isAffordable() + ".");
		}
		return ret;
	}
	function getSourceSkill()
	{
		// Resolve from the live main hand every time. A granted active can retain a
		// stale/null item pointer when equipment changes after skill-container update.
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local item = actor == null ? null : actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (!::MSU.isNull(item))
		{
			if (this.getItem() != item) this.setItem(item);
			if ("SkillPtrs" in item.m)
			{
				foreach (skill in item.m.SkillPtrs)
					if (skill != null && skill != this && skill.isAttack() && this.isPiercingSourceSkill(skill) && skill.getID() != "actives.split_shield") return skill;
			}
		}
		if (this.getContainer() != null)
		{
			// getAllSkillsOfType evaluates isHidden() on this skill again, causing
			// infinite recursion during character-screen equipment refresh.
			foreach (skill in this.getContainer().m.Skills)
			{
				if (skill == null || skill == this || skill.isGarbage() || !skill.isType(this.Const.SkillType.Active) || !skill.isAttack() || !this.isPiercingSourceSkill(skill) || skill.getID() == "actives.split_shield") continue;
				local skillItem = skill.getItem();
				if (::MSU.isNull(skillItem) || skillItem.getCurrentSlotType() != this.Const.ItemSlot.Mainhand) continue;
				if (::MSU.isNull(item))
				{
					item = skillItem;
					this.setItem(item);
				}
				::Brotherhood.logArchetypeTest("PERFECT THRUST", actor, "Resolved source " + skill.getID() + " from its live main-hand slot.");
				return skill;
			}
		}
		return null;
	}
	function syncSourceSkill()
	{
		local source = this.getSourceSkill();
		this.m.SourceSkill = source;
		if (source == null) return;
		this.m.DirectDamageMult = source.m.DirectDamageMult;
		this.m.InjuriesOnBody = source.m.InjuriesOnBody;
		this.m.InjuriesOnHead = source.m.InjuriesOnHead;
		this.m.KilledString = source.m.KilledString;
		this.m.ChanceDecapitate = source.m.ChanceDecapitate;
		this.m.ChanceDisembowel = source.m.ChanceDisembowel;
		this.m.ChanceSmash = source.m.ChanceSmash;
		if ("DamageType" in source.m) this.m.DamageType = source.m.DamageType;
	}
	function getTooltip()
	{
		this.syncSourceSkill();
		local ret = this.getDefaultTooltip();
		foreach (entry in ret)
		{
			if (!("text" in entry)) continue;
			entry.text = ::Brotherhood.replaceFleshcraftTooltipText(entry.text, " damage to hitpoints[/color]", "[/color] damage to hitpoints");
		}
		local sourceName = this.m.SourceSkill == null ? "the weapon's first attack" : this.m.SourceSkill.getName();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inherits the damage and damage type of " + sourceName
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = "Consumes all remaining Action Points and deals " + ::MSU.Text.colorPositive("+30%") + " damage for each one consumed"
		});
		return ret;
	}
	function use( _targetTile, _forFree = false )
	{
		// The base use path plays SoundOnUse before onUse. Synchronize first so
		// Perfect Thrust inherits the equipped thrust/weapon sound in time.
		this.syncSourceSkill();
		return this.skill.use(_targetTile, _forFree);
	}
	function onVerifyTarget( _originTile, _targetTile )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local baseValid = this.skill.onVerifyTarget(_originTile, _targetTile);
		if (!baseValid || !_targetTile.IsOccupiedByActor)
		{
			if (actor != null) ::Brotherhood.logArchetypeTest("PERFECT THRUST", actor, "onVerifyTarget rejected before status check: base=" + baseValid + " occupied=" + _targetTile.IsOccupiedByActor + ".");
			return false;
		}
		local target = _targetTile.getEntity();
		local dazed = target.getSkills().hasSkill("effects.dazed");
		local stunned = target.getSkills().hasSkill("effects.stunned");
		local net = target.getSkills().hasSkill("effects.net");
		local propStunned = target.getCurrentProperties().IsStunned;
		local rooted = target.getCurrentProperties().IsRooted;
		local result = dazed
			|| stunned
			|| net
			|| propStunned
			|| rooted;
		if (actor != null) ::Brotherhood.logArchetypeTest("PERFECT THRUST", actor, "onVerifyTarget " + target.getName() + ": dazed=" + dazed + " stunnedEffect=" + stunned + " net=" + net + " stunnedProperty=" + propStunned + " rooted=" + rooted + " result=" + result + ".");
		return result;
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this) return;
		this.syncSourceSkill();
		if (this.m.SourceSkill != null)
		{
			local oldHitChanceBonus = this.m.SourceSkill.m.HitChanceBonus;
			this.m.SourceSkill.onAnySkillUsed(this.m.SourceSkill, _targetEntity, _properties);
			this.m.SourceSkill.m.HitChanceBonus = oldHitChanceBonus;
		}
		local actor = this.getContainer().getActor();
		local consumed = this.m.IsExecuting
			? this.m.ConsumedActionPoints
			: ::Math.max(0, actor.getActionPoints() - this.getActionPointCost() - actor.getCurrentProperties().AdditionalActionPointCost);
		_properties.DamageTotalMult *= 1.0 + 0.30 * consumed;
	}
	function onUse( _user, _targetTile )
	{
		this.syncSourceSkill();
		this.m.ConsumedActionPoints = _user.getActionPoints();
		this.m.IsExecuting = true;
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
		local ret = this.attackEntity(_user, _targetTile.getEntity());
		this.m.IsExecuting = false;
		_user.setActionPoints(0);
		::Brotherhood.logFleshcraftMechanic("PERFECT THRUST", _user, "Used " + this.m.ConsumedActionPoints + " remaining Action Points for +" + (this.m.ConsumedActionPoints * 30) + "% damage.");
		return ret;
	}
});
