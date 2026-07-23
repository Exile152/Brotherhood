this.perk_bh_poach <- this.inherit("scripts/skills/skill", {
	m = { IsResolving = false },

	function create()
	{
		this.m.ID = "perk.bh_poach";
		this.m.Name = "Poach";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.head_hunter", "ui/perks/perk_15.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onTargetHit( _skill, _target, _part, _hp, _armor )
	{
		if (this.m.IsResolving || _skill == null || !_skill.isAttack() || !_skill.isRanged() || _target == null || _part != this.Const.BodyPart.Head) return;

		local owner = this.getContainer().getActor();
		local isCrossbow = ::Brotherhood.isWeaponSkillType(_skill, this.Const.Items.WeaponType.Crossbow);
		::Brotherhood.logLatestObsidianTest("POACH", owner, "Head hit on " + _target.getName() + " scheduled an automatic " + (isCrossbow ? "reload." : "repeat attack."));
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, this.resolvePoach.bindenv(this), {
			OwnerID = owner.getID(),
			TargetID = _target.getID(),
			SkillID = _skill.getID(),
			IsCrossbow = isCrossbow
		});
	}

	function resolvePoach( _data )
	{
		local actor = ::Tactical.getEntityByID(_data.OwnerID);
		if (actor == null || !actor.isAlive())
		{
			::Brotherhood.logLatestObsidianTest("POACH", actor, "Scheduled effect canceled: the user no longer exists or is alive.");
			return;
		}

		local perk = actor.getSkills().getSkillByID("perk.bh_poach");
		if (perk == null)
		{
			::Brotherhood.logLatestObsidianTest("POACH", actor, "Scheduled effect canceled: Poach is no longer present.");
			return;
		}
		perk.m.IsResolving = true;

		if (_data.IsCrossbow)
		{
			local reload = actor.getSkills().getSkillByID("actives.reload_bolt");
			if (reload == null)
			{
				::Brotherhood.logLatestObsidianTest("POACH", actor, "Automatic crossbow reload failed: no reload skill was available.");
			}
			else if (!("getAmmo" in reload) || reload.getAmmo() <= 0)
			{
				::Brotherhood.logLatestObsidianTest("POACH", actor, "Automatic crossbow reload failed: no bolt ammunition was available.");
			}
			else
			{
				local fatigue = reload.getFatigueCost();
				if (reload.onUse(actor, actor.getTile()))
				{
					actor.setFatigue(::Math.min(actor.getFatigueMax(), actor.getFatigue() + fatigue));
					::Brotherhood.logLatestObsidianTest("POACH", actor, "Automatically reloaded the crossbow for " + fatigue + " Fatigue.");
				}
				else
				{
					::Brotherhood.logLatestObsidianTest("POACH", actor, "Automatic crossbow reload was rejected by the reload skill.");
				}
			}
		}
		else
		{
			local target = ::Tactical.getEntityByID(_data.TargetID);
			local skill = actor.getSkills().getSkillByID(_data.SkillID);
			if (target == null || !target.isAlive())
			{
				::Brotherhood.logLatestObsidianTest("POACH", actor, "Repeat attack canceled: the original target was already dead or no longer present.");
			}
			else if (skill == null)
			{
				::Brotherhood.logLatestObsidianTest("POACH", actor, "Repeat attack canceled: the original ranged skill was no longer available.");
			}
			else
			{
				local fatigue = skill.getFatigueCost();
				if (skill.use(target.getTile(), true))
				{
					actor.setFatigue(::Math.min(actor.getFatigueMax(), actor.getFatigue() + fatigue));
					::Brotherhood.logLatestObsidianTest("POACH", actor, "Repeated " + skill.getName() + " against " + target.getName() + " for " + fatigue + " Fatigue and 0 AP.");
				}
				else
				{
					::Brotherhood.logLatestObsidianTest("POACH", actor, "Repeat attack failed its current range, target, or usability checks.");
				}
			}
		}

		perk.m.IsResolving = false;
	}
});
