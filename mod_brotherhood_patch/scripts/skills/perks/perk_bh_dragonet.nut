this.perk_bh_dragonet <- this.inherit("scripts/skills/skill", {
	m = { IsResolving = false },

	function create()
	{
		this.m.ID = "perk.bh_dragonet";
		this.m.Name = "Dragonet";
		this.m.Description = ::Brotherhood.getLatestObsidianTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.mastery.crossbow", "ui/perks/perk_48.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function onMissed( _attacker, _skill )
	{
		local owner = this.getContainer().getActor();
		if (this.m.IsResolving || _attacker == null || _skill == null || !_skill.isAttack() || _attacker.isAlliedWith(owner)) return;

		local fire = this.getContainer().getSkillByID("actives.fire_handgonne");
		if (fire == null || fire.getItem() == null || !fire.getItem().isWeaponType(this.Const.Items.WeaponType.Firearm))
		{
			::Brotherhood.logLatestObsidianTest("DRAGONET", owner, "Enemy miss detected, but no equipped handgonne fire skill was available.");
			return;
		}

		local loaded = fire.getItem().isLoaded();
		::Brotherhood.logLatestObsidianTest("DRAGONET", owner, _attacker.getName() + " missed; scheduled automatic " + (loaded ? "fire." : "reload."));
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, this.resolveReaction.bindenv(this), {
			OwnerID = owner.getID(),
			AttackerID = _attacker.getID(),
			Loaded = loaded
		});
	}

	function resolveReaction( _data )
	{
		local actor = ::Tactical.getEntityByID(_data.OwnerID);
		if (actor == null || !actor.isAlive())
		{
			::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Scheduled reaction canceled: the user no longer exists or is alive.");
			return;
		}

		local perk = actor.getSkills().getSkillByID("perk.bh_dragonet");
		if (perk == null)
		{
			::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Scheduled reaction canceled: Dragonet is no longer present.");
			return;
		}
		perk.m.IsResolving = true;

		if (_data.Loaded)
		{
			local attacker = ::Tactical.getEntityByID(_data.AttackerID);
			local shot = actor.getSkills().getSkillByID("actives.fire_handgonne");
			if (attacker == null || !attacker.isAlive())
			{
				::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatic shot canceled: the attacker was already dead or no longer present.");
			}
			else if (shot == null)
			{
				::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatic shot failed: the handgonne fire skill was no longer available.");
			}
			else if (!shot.isInRange(attacker.getTile()))
			{
				::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatic shot failed: " + attacker.getName() + " was no longer in range.");
			}
			else
			{
				local fatigue = shot.getFatigueCost();
				if (shot.onUse(actor, attacker.getTile()))
				{
					actor.setFatigue(::Math.min(actor.getFatigueMax(), actor.getFatigue() + fatigue));
					::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatically fired at " + attacker.getName() + " for " + fatigue + " Fatigue.");
				}
				else
				{
					::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatic shot was rejected by the handgonne fire skill.");
				}
			}
		}
		else
		{
			local reload = actor.getSkills().getSkillByID("actives.reload_handgonne");
			if (reload == null)
			{
				::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatic reload failed: no handgonne reload skill was available.");
			}
			else if (!("getAmmo" in reload) || reload.getAmmo() <= 0)
			{
				::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatic reload failed: no powder ammunition was available.");
			}
			else
			{
				local fatigue = reload.getFatigueCost();
				if (reload.onUse(actor, actor.getTile()))
				{
					actor.setFatigue(::Math.min(actor.getFatigueMax(), actor.getFatigue() + fatigue));
					::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatically reloaded for " + fatigue + " Fatigue.");
				}
				else
				{
					::Brotherhood.logLatestObsidianTest("DRAGONET", actor, "Automatic reload was rejected by the handgonne reload skill.");
				}
			}
		}

		perk.m.IsResolving = false;
	}
});
