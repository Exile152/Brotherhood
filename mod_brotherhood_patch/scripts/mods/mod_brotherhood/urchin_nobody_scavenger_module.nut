if (!("Brotherhood" in getroottable())) return;

::Brotherhood.getNewArchetypeTooltip <- function( _id )
{
	local d = {
		"perk.bh_misdirect": ["Look over there!", ["After you hit an enemy with a melee attack, the next melee attack made against them by an ally gains " + ::MSU.Text.colorPositive("+10") + " chance to hit.", "After you hit an enemy with a ranged attack, the next ranged attack made against them by an ally gains " + ::MSU.Text.colorPositive("+10") + " chance to hit.", "This does not benefit your own attacks."]],
		"perk.bh_backstabber": ["Honor doesn't win you fights.", ["The melee hit chance bonus for each ally, including Wardogs, surrounding and distracting the target is doubled to " + ::MSU.Text.colorPositive("+10%") + "."]],
		"perk.bh_dagger_mastery": ["Master the sneaky art of the dagger.", ["Dagger skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "You deal " + ::MSU.Text.colorPositive("+10%") + " damage against targets with lower [Initiative|Concept.Initiative] than you.", "Gain " + ::MSU.Text.colorPositive("+10%") + " [Initiative|Concept.Initiative].", "Stab, Puncture, and Deathblow cost " + ::MSU.Text.colorPositive("1") + " less [Action Point|Concept.ActionPoints]."]],
		"perk.bh_disengage": ["This attack was merely a trick, you idiot.", ["After missing an attack with a one-handed weapon, you can leave that opponent's [Zone of Control|Concept.ZoneOfControl] without triggering free attacks.", "After hitting an attack with a one-handed weapon, you gain " + ::MSU.Text.colorPositive("+15") + " Melee Defense until the end of this turn, and your next attack this turn automatically misses. This does not stack."]],
		"perk.bh_promised_potential": ["I know you can do it!", ["Upon reaching level 11, this perk has a chance to become Realized Potential. This doubles your salary, increases all attributes by " + ::MSU.Text.colorPositive("+15") + ", and grants one Perk Point.", "The chance starts at " + ::MSU.Text.colorPositive("1%") + " and increases after victories in which you participated and scored at least one kill. The increase is based on the fight's difficulty, ranging from " + ::MSU.Text.colorPositive("+1%") + " to " + ::MSU.Text.colorPositive("+5%") + ".", "The chance is capped at " + ::MSU.Text.colorPositive("80%") + ".", "If the level 11 roll fails, this perk becomes Wasted Potential and nothing happens."]],
		"perk.bh_finders_keepers": ["If no one wants it...", ["Picking up an item from the ground costs " + ::MSU.Text.colorPositive("1") + " AP.", "Equipping an item from the ground costs " + ::MSU.Text.colorPositive("0") + " AP, as long as it is not a shield."]],
		"perk.bh_dead_mans_arsenal": ["Nothing goes wasted.", ["Weapons dropped by defeated enemies that you pick up gain " + ::MSU.Text.colorPositive("+25%") + " damage for the remainder of combat."]]
	};
	local x = d[_id];
	return ::Brotherhood.formatSurvivalPerkTooltip({ Fluff = x[0], Effects = [{ Type = ::UPD.EffectType.Passive, Description = x[1] }] });
}

::Brotherhood.registerNewArchetypePerks <- function()
{
	local defs = [
		["perk.bh_misdirect", "Misdirect", "ui/perks/bh_misdirect.png", "ui/perks/bh_misdirect_sw.png", null],
		["perk.bh_backstabber", "Backstabber", null, null, "perk.backstabber"],
		["perk.bh_dagger_mastery", "Dagger Mastery", null, null, "perk.mastery.dagger"],
		["perk.bh_disengage", "Disengage", "ui/perks/bh_disengage.png", "ui/perks/bh_disengage_sw.png", null],
		["perk.bh_promised_potential", "Promised Potential", "ui/perks/bh_promised_potential.png", "ui/perks/bh_promised_potential_sw.png", null],
		["perk.bh_finders_keepers", "Finders Keepers", "ui/perks/bh_finders_keepers.png", "ui/perks/bh_finders_keepers_sw.png", null],
		["perk.bh_dead_mans_arsenal", "Dead Man's Arsenal", "ui/perks/perk_rf_fruits_of_labor.png", "ui/perks/perk_rf_fruits_of_labor_sw.png", null]
	];
	local perks = [];
	foreach (d in defs)
	{
		local icon = d[2]; local iconDisabled = d[3];
		if (d[4] != null) { local source = ::Const.Perks.findById(d[4]); if (source != null) { icon = source.Icon; iconDisabled = source.IconDisabled; } }
		perks.push({ ID=d[0], Script="scripts/skills/perks/perk_" + d[0].slice(5), Name=d[1], Tooltip=::Brotherhood.getNewArchetypeTooltip(d[0]), Icon=icon, IconDisabled=iconDisabled, PerkGroupIDs=[] });
	}
	::DynamicPerks.Perks.addPerks(perks);
	::DynamicPerks.Perks.addPerks([
		{ID="perk.bh_realized_potential",Script="scripts/skills/perks/perk_bh_realized_potential",Name="Realized Potential",Tooltip="Your salary is doubled, all attributes are increased by +15, and you gain one Perk Point.",Icon="ui/perks/perk_rf_discovered_talent.png",IconDisabled="ui/perks/perk_rf_discovered_talent_sw.png",PerkGroupIDs=[]},
		{ID="perk.bh_wasted_potential",Script="scripts/skills/perks/perk_bh_wasted_potential",Name="Wasted Potential",Tooltip="You never achieved it...",Icon="ui/perks/perk_rf_failed_potential.png",IconDisabled="ui/perks/perk_rf_failed_potential_sw.png",PerkGroupIDs=[]}
	]);
}

::Brotherhood.initializeUrchinNobodyScavenger <- function()
{
	::Brotherhood.registerNewArchetypePerks();
	if (!::Brotherhood.shouldInitializeArchetypeModule(["pg.bh_knave", "pg.bh_nobody"])) return;
	// Reforged replaces the Shiv/Knife skill loadout but leaves its weapon type
	// unset. Restore the actual category so every dagger mechanic recognizes it.
	::Brotherhood.HooksMod.hook("scripts/items/weapons/knife", function(q) {
		q.create = @(__original) { function create()
		{
			__original();
			this.setWeaponType(::Const.Items.WeaponType.Dagger);
		}}.create;

		q.onEquip = @(__original) { function onEquip()
		{
			this.setWeaponType(::Const.Items.WeaponType.Dagger);
			__original();
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			if (actor != null) ::Brotherhood.logArchetypeTest("DAGGER MASTERY", actor, "Shiv equipped with WeaponType.Dagger metadata.");
		}}.onEquip;
	});
	::Brotherhood.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
		q.getLootForTile = @(__original) { function getLootForTile(_killer,_loot)
		{
			local ret=__original(_killer,_loot);
			if(!this.isPlayerControlled())foreach(item in ret)if(item!=null&&item.isItemType(::Const.Items.ItemType.Weapon))item.m.BH_DroppedByEnemy<-true;
			return ret;
		}}.getLootForTile;
	});
	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.attackEntity = @(__original) { function attackEntity(_user,_targetEntity,_allowDiversion = true)
		{
			if(this.isAttack()&&this.getContainer()!=null)
			{
				local disengage=this.getContainer().getSkillByID("perk.bh_disengage");
				if(disengage!=null&&disengage.m.ForceMiss)
				{
					disengage.m.ForceMiss=false;
					::Brotherhood.logArchetypeTest("DISENGAGE",_user,"Intercepted "+this.getID()+" at attack resolution; forced miss consumed.");
					if(_targetEntity!=null)_targetEntity.getSkills().onMissed(_user,this);
					_user.getSkills().onTargetMissed(this,_targetEntity);
					return false;
				}
			}
			return __original(_user,_targetEntity,_allowDiversion);
		}}.attackEntity;
		q.getHitchance = @(__original) { function getHitchance(_targetEntity)
		{
			if(this.isAttack()&&this.getContainer()!=null)
			{
				local disengage=this.getContainer().getSkillByID("perk.bh_disengage");
				if(disengage!=null&&disengage.m.ForceMiss)return 0;
			}
			return __original(_targetEntity);
		}}.getHitchance;
	});
	// Archetypes supplement background packages. Never remove a vanilla or
	// Reforged membership just because the perk also belongs to an archetype.
	local updateBagsAndBeltsMembership = function()
	{
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		::Brotherhood.appendPerkGroupMembership("perk.bags_and_belts", "pg.bh_knave");
	}
	// DPF rebuilds PerkGroupIDs late. Run after that rebuild, and retain the
	// Reforged callback below as a second pass for load-order compatibility.
	::DynamicPerks.QueueBucket.AfterHooks.push(updateBagsAndBeltsMembership);
	// Brotherhood initializes after Dynamic Perks has already run its AfterHooks
	// bucket, so apply this immediately as the authoritative late pass too.
	updateBagsAndBeltsMembership();
	::Reforged.QueueBucket.AfterHooks.push(function() {
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		local memberships = {
			"perk.bh_misdirect":["pg.bh_knave"], "perk.bh_backstabber":["pg.bh_knave"],
			"perk.bh_dagger_mastery":["pg.bh_knave"], "perk.bh_disengage":["pg.bh_knave"], "perk.bh_stolen":["pg.bh_swashbuckler", "pg.bh_knave"],
			"perk.bh_promised_potential":["pg.bh_nobody"], "perk.bh_finders_keepers":["pg.bh_scavenger"], "perk.bh_dead_mans_arsenal":["pg.bh_scavenger"]
		};
		foreach (id, groups in memberships) { local p=::Const.Perks.findById(id); if (p!=null) p.PerkGroupIDs=clone groups; }
		updateBagsAndBeltsMembership();
		local collection=::DynamicPerks.PerkGroupCategories.findById("pgc.rf_fighting_style");
		if (collection!=null) { local groups=clone collection.getGroups(); foreach (id in ["pg.bh_knave","pg.bh_nobody"]) if (groups.find(id)==null) groups.push(id); collection.setGroups(groups); }
	});
}
