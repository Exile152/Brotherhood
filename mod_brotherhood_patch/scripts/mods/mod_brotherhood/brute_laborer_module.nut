if (!("Brotherhood" in getroottable())) return;

::Brotherhood.getBruteLaborerTooltip <- function(_id)
{
	local d = {
		"perk.bh_brute_force": ["Hit harder.", ["Deal " + ::MSU.Text.colorPositive("5%") + " more damage with melee attacks."]],
		"perk.bh_too_strong_to_miss": ["Hell yeah I am.", ["Missed attacks with two-handed weapons still deal " + ::MSU.Text.colorPositive("25%") + " damage to armor.", "This damage cannot damage [Hitpoints|Concept.Hitpoints]."]],
		"perk.bh_axe_mastery": ["Master combat with axes and destroying shields.", ["Axe skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Smash Shield damage is increased by " + ::MSU.Text.colorPositive("50%") + " when used with axes.", "Round Swing gains " + ::MSU.Text.colorPositive("+5%") + " chance to hit.", "The Longaxe no longer has a penalty for attacking targets directly adjacent."]],
		"perk.bh_mace_mastery": ["Master the maces and beat your opponents into submission.", ["Mace skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "All mace skills now have a " + ::MSU.Text.colorPositive("33%") + " chance of applying Dazed.", "The Polemace no longer has a penalty for attacking targets directly adjacent."]],
		"perk.bh_brutality": ["You will feel it!", ["Whenever your melee attack destroys a target's body or head armor, inflict Staggered on that target."]],
		"perk.bh_splitter": ["Stop hiding behind your own tombstone!", ["All non-polearm melee weapons gain access to Smash Shield.", "When you destroy an enemy's shield, they cannot benefit from Double Grip for " + ::MSU.Text.colorPositive("{X}") + " turns (" + ::MSU.Text.colorPositive("3%") + " of your Melee Skill), to a minimum of " + ::MSU.Text.colorPositive("1") + "."]],
		"perk.bh_fruits_of_labor": ["Years of hard work have borne fruit.", ["Your [Hitpoints|Concept.Hitpoints] and maximum [Fatigue|Concept.MaximumFatigue] are increased by " + ::MSU.Text.colorPositive("10%") + " of their respective values."]],
		"perk.bh_hard_boiled_egg": ["You'll have to try something different.", ["Gain an additional stacking " + ::MSU.Text.colorPositive("-10%") + " chance that an opponent will hit you with each attack.", "The bonus resets when they miss.", "Stacks separately for each enemy."]],
		"perk.bh_repetitive_work": ["You don't like it, but it is needed.", ["The second and subsequent use of the same skill during your turn builds " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Your maximum [Fatigue|Concept.MaximumFatigue] is increased by " + ::MSU.Text.colorPositive("10%") + " of its base value."]],
		"perk.bh_hammer_mastery": ["Master hammers and fighting against heavily armored opponents.", ["Hammer skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Destroy Armor and Demolish Armor inflict " + ::MSU.Text.colorPositive("33%") + " more damage against armor.", "Shatter gains " + ::MSU.Text.colorPositive("+5%") + " chance to hit.", "The Polehammer no longer has a penalty for attacking targets directly adjacent."]]
	};
	local x = d[_id];
	return ::Brotherhood.formatSurvivalPerkTooltip({Fluff=x[0], Effects=[{Type=::UPD.EffectType.Passive, Description=x[1]}]});
}

::Brotherhood.registerBruteLaborerPerks <- function()
{
	local defs = [
		["perk.bh_brute_force","Brute Force","perk.berserk"], ["perk.bh_too_strong_to_miss","Too Strong to Miss","perk.head_hunter"],
		["perk.bh_axe_mastery","Axe Mastery","perk.mastery.axe"], ["perk.bh_mace_mastery","Mace Mastery","perk.mastery.mace"],
		["perk.bh_brutality","Brutality","perk.battle_flow"], ["perk.bh_splitter","Splitter","perk.shield_expert"],
		["perk.bh_fruits_of_labor","Fruits of Labor","perk.rf_fruits_of_labor"], ["perk.bh_hard_boiled_egg","Hard-Boiled Egg","perk.dodge"], ["perk.bh_repetitive_work","Repetitive Work","perk.battle_flow"],
		["perk.bh_hammer_mastery","Hammer Mastery","perk.mastery.hammer"]
	];
	local customIcons = {
		"perk.bh_brute_force": ["ui/perks/bh_brute_force.png", "ui/perks/bh_brute_force_sw.png"],
		"perk.bh_brutality": ["ui/perks/bh_brutality.png", "ui/perks/bh_brutality_sw.png"],
		"perk.bh_hard_boiled_egg": ["ui/perks/bh_hard_boiled_egg.png", "ui/perks/bh_hard_boiled_egg_sw.png"]
	};
	local perks=[];
	foreach(d in defs)
	{
		local source=::Const.Perks.findById(d[2]);
		local icon=source == null ? "ui/perks/perk_10.png" : source.Icon;
		local disabled=source == null ? "ui/perks/perk_10_sw.png" : source.IconDisabled;
		if (d[0] in customIcons)
		{
			icon = customIcons[d[0]][0];
			disabled = customIcons[d[0]][1];
		}
		perks.push({ID=d[0], Script="scripts/skills/perks/perk_"+d[0].slice(5), Name=d[1], Tooltip=::Brotherhood.getBruteLaborerTooltip(d[0]), Icon=icon, IconDisabled=disabled, PerkGroupIDs=[]});
	}
	::DynamicPerks.Perks.addPerks(perks);
}

::Brotherhood.initializeBruteAndLaborer <- function()
{
	::Brotherhood.registerBruteLaborerPerks();
	if (!::Brotherhood.shouldInitializeArchetypeModule(["pg.bh_brute", "pg.bh_laborer"])) return;
	::Brotherhood.HooksMod.hook("scripts/skills/skill_container", function(q) {
		q.onTargetHit = @(__original) { function onTargetHit( _caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
		{
			__original(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
			if (_caller == null || !_caller.isAttack() || _targetEntity == null) return;
			local perk = _targetEntity.getSkills().getSkillByID("perk.bh_hard_boiled_egg");
			if (perk != null) perk.recordHit(this.getActor());
		}}.onTargetHit;
		q.onTargetMissed = @(__original) { function onTargetMissed( _caller, _targetEntity )
		{
			__original(_caller, _targetEntity);
			if (_caller == null || !_caller.isAttack() || _targetEntity == null) return;
			local perk = _targetEntity.getSkills().getSkillByID("perk.bh_hard_boiled_egg");
			if (perk != null) perk.recordMiss(this.getActor());
		}}.onTargetMissed;
	});
	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.getDescription = @(__original) { function getDescription()
		{
			local text=__original();
			if(this.getID()!="perk.bh_splitter" || this.getContainer()==null)return text;
			local turns=::Math.max(1,::Math.floor(this.getContainer().getActor().getCurrentProperties().MeleeSkill*0.03));
			return text.find("{X}")==null ? text : text.slice(0,text.find("{X}"))+turns+text.slice(text.find("{X}")+3);
		}}.getDescription;
		q.getFatigueCost = @(__original) { function getFatigueCost()
		{
			local cost=__original(); if(this.getContainer()==null)return cost;
			local weapon=this.getItem();
			local usesFirstAttackCost=false;
			if(weapon!=null&&("isWeaponType" in weapon)&&this.getID()=="actives.split_shield"&&weapon.isWeaponType(::Const.Items.WeaponType.Axe)&&("SkillPtrs" in weapon.m))
			{
				foreach(attack in weapon.m.SkillPtrs)if(attack!=null&&attack.getID()!="actives.split_shield"&&attack.isAttack()){cost=attack.getFatigueCost();usesFirstAttackCost=true;break;}
			}
			if(weapon!=null&&("isWeaponType" in weapon)&&this.getID()=="actives.split_shield"&&weapon.isWeaponType(::Const.Items.WeaponType.Axe)&&!usesFirstAttackCost)
			{
				foreach(attack in this.getContainer().m.Skills)if(attack!=null&&attack.getID()!="actives.split_shield"&&attack.isAttack()&&attack.getItem()==weapon){cost=attack.getFatigueCost();usesFirstAttackCost=true;break;}
			}
			if(weapon!=null&&("isWeaponType" in weapon))
			{
				local skills=this.getContainer();
				if(!usesFirstAttackCost&&((weapon.isWeaponType(::Const.Items.WeaponType.Axe)&&skills.hasSkill("perk.bh_axe_mastery"))
					||(weapon.isWeaponType(::Const.Items.WeaponType.Mace)&&skills.hasSkill("perk.bh_mace_mastery"))
					||(weapon.isWeaponType(::Const.Items.WeaponType.Hammer)&&skills.hasSkill("perk.bh_hammer_mastery"))))
					cost=::Math.max(0,::Math.round(cost*0.75));
			}
			local p=this.getContainer().getSkillByID("perk.bh_repetitive_work");
			if(p!=null && p.wasUsed(this.getID()))cost=::Math.max(0,::Math.round(cost*0.75));
			return cost;
		}}.getFatigueCost;
		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret=__original();
			if(this.getContainer()==null||!this.isAttack())return ret;
			local weapon=this.getItem();
			if(weapon!=null&&("isWeaponType" in weapon)&&weapon.isWeaponType(::Const.Items.WeaponType.Mace)&&this.getContainer().hasSkill("perk.bh_mace_mastery"))
			{
				ret.push({id=92,type="text",icon="ui/icons/special.png",text=::Reforged.Mod.Tooltips.parseString("Has a "+::MSU.Text.colorPositive("33%")+" chance to inflict [$Dazed|Skill+dazed_effect]")});
			}
			return ret;
		}}.getTooltip;
		q.onAnySkillUsed = @(__original) { function onAnySkillUsed(_skill,_target,_properties)
		{
			__original(_skill,_target,_properties);
			if(_skill!=this||_target==null||this.getContainer()==null)return;
			local weapon=this.getItem();if(weapon==null||this.getContainer().getActor().getTile().getDistanceTo(_target.getTile())!=1)return;
			local id=weapon.getID();
			local ignores=(id.find("longaxe")!=null&&this.getContainer().hasSkill("perk.bh_axe_mastery"))
				||(id.find("polemace")!=null&&this.getContainer().hasSkill("perk.bh_mace_mastery"))
				||(id.find("polehammer")!=null&&this.getContainer().hasSkill("perk.bh_hammer_mastery"));
			if(ignores){_properties.MeleeSkill+=15;this.m.HitChanceBonus+=15;}
		}}.onAnySkillUsed;
		q.use = @(__original) { function use(_tile,_free=false)
		{
			local id=this.getID(); local p=this.getContainer()==null?null:this.getContainer().getSkillByID("perk.bh_repetitive_work");
			local repeated=p!=null&&p.wasUsed(id); local ret=__original(_tile,_free);
			if(ret && !_free && p!=null)p.recordUse(id,repeated); return ret;
		}}.use;
	});
	::Brotherhood.HooksMod.hookTree("scripts/items/weapons/weapon", function(q) {
		q.getShieldDamage = @(__original) { function getShieldDamage()
		{
			local damage=__original();
			if(this.getContainer()!=null&&this.isWeaponType(::Const.Items.WeaponType.Axe))
			{
				local actor=this.getContainer().getActor();
				local attack=null;
				if("SkillPtrs" in this.m)foreach(skill in this.m.SkillPtrs)if(attack==null&&skill!=null&&skill.getID()!="actives.split_shield"&&skill.isAttack())attack=skill;
				// Reforged may detach native skills from SkillPtrs after equipping. Fall
				// back to the actor's skills that are still bound to this weapon.
				if(actor!=null&&attack==null)foreach(skill in actor.getSkills().m.Skills)if(attack==null&&skill!=null&&skill.getID()!="actives.split_shield"&&skill.isAttack()&&skill.getItem()==this)attack=skill;
				if(actor!=null&&attack!=null)
				{
					local properties=actor.getSkills().buildPropertiesForUse(attack,null);
					damage=::Math.max(1,::Math.round((properties.DamageRegularMin+properties.DamageRegularMax)*0.5*properties.DamageTotalMult*properties.MeleeDamageMult*0.8));
				}
				else if(actor!=null)
				{
					// Some native axe skills are no longer bound to the weapon by the
					// time Reforged asks for shield damage. Never fall back to the old
					// fixed ShieldDamage value; derive it from the axe itself instead.
					local properties=actor.getCurrentProperties();
					damage=::Math.max(1,::Math.round((this.m.RegularDamage+this.m.RegularDamageMax)*0.5*properties.DamageTotalMult*properties.MeleeDamageMult*0.8));
				}
				if(actor!=null&&actor.getSkills().hasSkill("perk.bh_axe_mastery"))damage+=::Math.max(1,::Math.floor(damage*0.5));
			}
			return damage;
		}}.getShieldDamage;
	});
	::Brotherhood.HooksMod.hook("scripts/items/item_container", function(q) {
		q.unequip = @(__original) { function unequip( _item )
		{
			if (_item != null && _item != -1 && this.getActor() != null)
			{
				local splitter = this.getActor().getSkills().getSkillByID("perk.bh_splitter");
				if (splitter != null && splitter.m.GrantedWeapon == _item && splitter.m.IsGrantedSkill)
				{
					splitter.removeGrantedSkill();
					::Brotherhood.logArchetypeTest("SPLITTER", this.getActor(), "Removed granted Smash Shield immediately before unequipping " + _item.getName() + ".");
				}
			}
			return __original(_item);
		}}.unequip;
	});
	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.general_queryUIPerkTooltipData = @(__original) { function general_queryUIPerkTooltipData( _entityId, _perkId )
		{
			local ret = __original(_entityId, _perkId);
			if (ret == null || _perkId != "perk.bh_splitter") return ret;
			local actor = ::Tactical.getEntityByID(_entityId);
			if (actor == null) return ret;
			local turns = ::Math.max(1, ::Math.floor(actor.getCurrentProperties().MeleeSkill * 0.03));
			foreach (entry in ret)
			{
				if (entry.id != 2 || !("text" in entry)) continue;
				local marker = entry.text.find("{X}");
				if (marker != null) entry.text = entry.text.slice(0, marker) + turns + entry.text.slice(marker + 3);
			}
			return ret;
		}}.general_queryUIPerkTooltipData;
	});
	::Brotherhood.HooksMod.hook("scripts/skills/special/double_grip", function(q) {
		q.canDoubleGrip = @(__original) { function canDoubleGrip()
		{
			if(this.getContainer()!=null&&this.getContainer().hasSkill("effects.bh_splitter_no_double_grip"))return false;
			return __original();
		}}.canDoubleGrip;
		q.onUpdate = @(__original) { function onUpdate(_properties)
		{
			if(this.getContainer()!=null&&this.getContainer().hasSkill("effects.bh_splitter_no_double_grip"))return;
			__original(_properties);
		}}.onUpdate;
	});
	::Brotherhood.HooksMod.hook("scripts/skills/actives/split_shield", function(q) {
		q.RF_getFatigueDamage = @(__original) { function RF_getFatigueDamage()
		{
			if (this.getContainer() == null) return __original();
			local weapon = this.getContainer().getActor().getMainhandItem();
			local unifiedNativeAxe = weapon != null && weapon.isWeaponType(::Const.Items.WeaponType.Axe);
			if (!this.getContainer().hasSkill("perk.bh_splitter") && !unifiedNativeAxe) return __original();
			local shieldDamage = weapon == null ? 0 : weapon.getShieldDamage();
			local fatigueDamage = shieldDamage <= 0 ? 0 : ::Math.max(1, ::Math.round(shieldDamage / 5.0));
			return fatigueDamage;
		}}.RF_getFatigueDamage;
	});
	::Brotherhood.HooksMod.hook("scripts/skills/actives/round_swing", function(q) { q.onAnySkillUsed = @(__original) { function onAnySkillUsed(_s,_t,_p){__original(_s,_t,_p);if(_s==this&&this.getContainer().hasSkill("perk.bh_axe_mastery")){_p.MeleeSkill+=5;this.m.HitChanceBonus+=5;}}}.onAnySkillUsed; });
	::Brotherhood.HooksMod.hook("scripts/skills/actives/shatter_skill", function(q) { q.onAnySkillUsed = @(__original) { function onAnySkillUsed(_s,_t,_p){__original(_s,_t,_p);if(_s==this&&this.getContainer().hasSkill("perk.bh_hammer_mastery")){_p.MeleeSkill+=5;this.m.HitChanceBonus+=5;}}}.onAnySkillUsed; });
	foreach(path in ["scripts/skills/actives/crush_armor","scripts/skills/actives/demolish_armor_skill"])
	::Brotherhood.HooksMod.hook(path, function(q) { q.onAnySkillUsed = @(__original) { function onAnySkillUsed(_s,_t,_p){__original(_s,_t,_p);if(_s==this&&this.getContainer().hasSkill("perk.bh_hammer_mastery")){_p.DamageArmorMult*=1.33;::Brotherhood.logArchetypeTest("HAMMER MASTERY",this.getContainer().getActor(),"Applied +33% armor damage to "+this.getName()+".");}}}.onAnySkillUsed; });
	::Reforged.QueueBucket.AfterHooks.push(function(){
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		local memberships={"perk.bh_brute_force":["pg.bh_brute"],"perk.bh_too_strong_to_miss":["pg.bh_brute"],"perk.bh_axe_mastery":["pg.bh_brute"],"perk.bh_cleaver_mastery":["pg.bh_executioner","pg.bh_brute"],"perk.bh_mace_mastery":["pg.bh_brute"],"perk.bh_brutality":["pg.bh_brute"],"perk.bh_splitter":["pg.bh_brute"],"perk.bh_fruits_of_labor":["pg.bh_laborer"],"perk.bh_hard_boiled_egg":["pg.bh_laborer"],"perk.bh_repetitive_work":["pg.bh_laborer"],"perk.bh_hammer_mastery":["pg.bh_laborer"]};
		foreach(id,groups in memberships){local p=::Const.Perks.findById(id);if(p!=null)p.PerkGroupIDs=clone groups;}
		local c=::DynamicPerks.PerkGroupCategories.findById("pgc.rf_fighting_style");if(c!=null){local groups=clone c.getGroups();if(groups.find("pg.bh_brute")==null)groups.push("pg.bh_brute");c.setGroups(groups);}
	});
}
