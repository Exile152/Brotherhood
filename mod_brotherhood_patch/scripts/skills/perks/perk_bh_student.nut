this.perk_bh_student <- this.inherit("scripts/skills/skill", {
	m = { LevelElevenPointGranted = false },
	function create()
	{
		this.m.ID = "perk.bh_student";
		this.m.Name = "Student";
		this.m.Description = ::Brotherhood.getExpansionArchetypeTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.student", "ui/perks/perk_21.png");
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}
	function ensureProgressEffect()
	{
		if (!this.getContainer().hasSkill("effects.bh_student_permanent_gains"))
			this.getContainer().add(this.new("scripts/skills/effects/bh_student_permanent_gains_effect"));
	}
	function onUpdate( _properties ) { _properties.XPGainMult *= 1.2; this.ensureProgressEffect(); }
	function onAdded()
	{
		if (this.getContainer().getActor().getLevel() >= 11) this.grantLevelElevenPerkPoint();
		this.ensureProgressEffect();
	}
	function onRemoved() { this.getContainer().removeByID("effects.bh_student_permanent_gains"); }
	function grantLevelElevenPerkPoint()
	{
		if (this.m.LevelElevenPointGranted) return;
		local actor = this.getContainer().getActor();
		this.m.LevelElevenPointGranted = true;
		++actor.m.PerkPoints;
		actor.setDirty(true);
		::Brotherhood.logArchetypeTest("STUDENT", actor, "Granted the Level 11 bonus perk point.");
	}
	function recordPermanentGain( _flag )
	{
		local flags = this.getContainer().getActor().getFlags();
		local key = "BH_StudentPermanentGain_" + _flag;
		flags.set(key, flags.has(key) ? flags.get(key) + 1 : 1);
	}
	function increaseRandomAttribute()
	{
		local actor = this.getContainer().getActor();
		local baseProperties = actor.getBaseProperties();
		local choices = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.Bravery,
			this.Const.Attributes.Initiative,
			this.Const.Attributes.MeleeSkill,
			this.Const.Attributes.RangedSkill,
			this.Const.Attributes.MeleeDefense,
			this.Const.Attributes.RangedDefense
		];
		local attribute = choices[::Math.rand(0, choices.len() - 1)];
		local name = "";
		local flag = "";
		switch (attribute)
		{
			case this.Const.Attributes.Hitpoints: baseProperties.Hitpoints += 1; actor.setHitpoints(actor.getHitpoints() + 1); name = "Hitpoints"; flag = "Hitpoints"; break;
			case this.Const.Attributes.Fatigue: baseProperties.Stamina += 1; name = "Fatigue"; flag = "Fatigue"; break;
			case this.Const.Attributes.Bravery: baseProperties.Bravery += 1; name = "Resolve"; flag = "Resolve"; break;
			case this.Const.Attributes.Initiative: baseProperties.Initiative += 1; name = "Initiative"; flag = "Initiative"; break;
			case this.Const.Attributes.MeleeSkill: baseProperties.MeleeSkill += 1; name = "Melee Skill"; flag = "MeleeAttack"; break;
			case this.Const.Attributes.RangedSkill: baseProperties.RangedSkill += 1; name = "Ranged Skill"; flag = "RangedAttack"; break;
			case this.Const.Attributes.MeleeDefense: baseProperties.MeleeDefense += 1; name = "Melee Defense"; flag = "MeleeDefense"; break;
			case this.Const.Attributes.RangedDefense: baseProperties.RangedDefense += 1; name = "Ranged Defense"; flag = "RangedDefense"; break;
		}
		this.recordPermanentGain(flag);
		this.ensureProgressEffect();
		actor.getSkills().update();
		actor.setDirty(true);
		::Brotherhood.logArchetypeTest("STUDENT", actor, "Permanently gained +1 " + name + ".");
	}
	function onCombatFinished()
	{
		local actor = this.getContainer().getActor();
		local data = ::Brotherhood.getStudentBattleData();
		local actorFlags = actor.getFlags();
		local wasDeployed = actorFlags.has("BH_StudentDeployedBattle") && actorFlags.get("BH_StudentDeployedBattle") == data.Serial;
		local alreadyProcessed = actorFlags.has("BH_StudentProcessedBattle") && actorFlags.get("BH_StudentProcessedBattle") == data.Serial;
		local qualifies = data.Active && wasDeployed && !alreadyProcessed && actor.isAlive() && ::Brotherhood.isActorInPlayerCompany(actor);
		if (qualifies)
		{
			actorFlags.set("BH_StudentProcessedBattle", data.Serial);
			local battleScore = data.DeployedCount <= 0 ? 0 : data.TotalBaseXP / data.DeployedCount;
			local chance = ::Math.min(50, ::Math.floor(battleScore / 5.0));
			local forced = actorFlags.has("BH_StudentDebugForce100");
			if (forced) chance = 100;
			if (actor.getLevel() < 11 && chance > 0)
			{
				local roll = ::Math.rand(1, 100);
				if (roll <= chance) this.increaseRandomAttribute();
				::Brotherhood.logArchetypeTest("STUDENT", actor, "Battle base XP " + data.TotalBaseXP + " / " + data.DeployedCount + " deployed = " + battleScore + "; growth chance " + chance + "%; rolled " + roll + ".");
			}
			if (forced) actorFlags.remove("BH_StudentDebugForce100");
		}
		this.skill.onCombatFinished();
	}
	function onSerialize( _out ) { this.skill.onSerialize(_out); _out.writeBool(this.m.LevelElevenPointGranted); }
	function onDeserialize( _in ) { this.skill.onDeserialize(_in); this.m.LevelElevenPointGranted = _in.readBool(); }
});
