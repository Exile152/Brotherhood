if (!("Brotherhood" in getroottable())) return;

::Brotherhood.getArtilleristTooltip <- function( _id )
{
	local d = {
		"perk.bh_more_ammo": ["Always have more.", ["At the start of combat, gain " + ::MSU.Text.colorPositive("2") + " temporary maximum ammunition for your currently equipped ammunition slot."]],
		"perk.bh_gunpowder_mastery": ["Master the power of the gunpowder!", ["Handgonne skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Reloading a Handgonne costs " + ::MSU.Text.colorPositive("6") + " [Action Points|Concept.ActionPoints].", "Handgonnes ignore an additional " + ::MSU.Text.colorPositive("10%") + " of armor."]],
		"perk.bh_explosive_bullets": ["A new technology that can surpass metal.", ["Unlocks Load Explosive Bullets, which loads your Handgonne and makes your next shot deal " + ::MSU.Text.colorPositive("+60%") + " armor damage and ignore an additional " + ::MSU.Text.colorPositive("20%") + " of armor.", "Your Handgonne must be empty to use this skill.", "Costs " + ::MSU.Text.colorNegative("9") + " [Action Points|Concept.ActionPoints] to use and builds up " + ::MSU.Text.colorNegative("10") + " [Fatigue|Concept.Fatigue].", "Consumes " + ::MSU.Text.colorNegative("3") + " ammunition."]]
		,"perk.bh_parry_a_gun": ["Boom and Slash.", ["After making a melee attack, switching to a Handgonne costs " + ::MSU.Text.colorPositive("0") + " [Action Points|Concept.ActionPoints].", "Switching to your Handgonne this way automatically reloads it and allows it to fire at " + ::MSU.Text.colorPositive("1") + " tile range instead of " + ::MSU.Text.colorPositive("2") + ".", "Switching back to a one-handed melee weapon automatically reloads the Handgonne."]]
	};
	local x = d[_id];
	local type = _id == "perk.bh_explosive_bullets" ? ::UPD.EffectType.Active : ::UPD.EffectType.Passive;
	return ::Brotherhood.formatSurvivalPerkTooltip({Fluff=x[0], Effects=[{Type=type, Description=x[1]}]});
}

::Brotherhood.isHandgonne <- function( _item )
{
	return _item != null && ("isLoaded" in _item) && _item.getAmmoID() == "ammo.powder";
}

::Brotherhood.isSameTacticalTile <- function( _a, _b )
{
	return _a != null && _b != null && _a.Coords.X == _b.Coords.X && _a.Coords.Y == _b.Coords.Y;
}

::Brotherhood.buildDragonBreathAlternatingPath <- function( _origin, _firstDirection, _secondDirection )
{
	local ret = [];
	local tile = _origin;
	for (local i = 0; i < 4; ++i)
	{
		local direction = i % 2 == 0 ? _firstDirection : _secondDirection;
		if (!tile.hasNextTile(direction)) break;
		tile = tile.getNextTile(direction);
		if (_origin.getDistanceTo(tile) != i + 1) break;
		ret.push(tile);
	}
	return ret;
}

::Brotherhood.getDragonBreathHorizontalPatterns <- function( _origin )
{
	local bestLeft = null;
	local bestRight = null;
	for (local first = 0; first < 6; ++first)
	{
		foreach (turn in [-1, 1])
		{
			local second = (first + turn + 6) % 6;
			local tiles = ::Brotherhood.buildDragonBreathAlternatingPath(_origin, first, second);
			if (tiles.len() < 2) continue;

			// A horizontal hex-grid ray returns to the shooter's screen row on
			// every second step. This detects the two left/right direction pairs
			// without relying on hard-coded engine direction numbers.
			if (tiles[1].SquareCoords.Y != _origin.SquareCoords.Y || tiles[1].Pos.X == _origin.Pos.X) continue;
			local score = tiles[0].Pos.Y <= _origin.Pos.Y ? 0 : 1;
			local pattern = { Tiles = tiles, FirstDirection = first, SecondDirection = second, Mode = "horizontal zig-zag", Score = score };
			if (tiles[1].Pos.X < _origin.Pos.X)
			{
				if (bestLeft == null || score < bestLeft.Score) bestLeft = pattern;
			}
			else if (bestRight == null || score < bestRight.Score) bestRight = pattern;
		}
	}

	local ret = [];
	if (bestLeft != null) ret.push(bestLeft);
	if (bestRight != null) ret.push(bestRight);
	return ret;
}

::Brotherhood.resolveDragonBreathPattern <- function( _origin, _target )
{
	if (_origin == null || _target == null) return null;

	local straightDirection = _origin.getDirectionTo(_target);
	local straightTiles = [];
	local tile = _origin;
	for (local i = 0; i < 4; ++i)
	{
		if (!tile.hasNextTile(straightDirection)) break;
		tile = tile.getNextTile(straightDirection);
		straightTiles.push(tile);
	}
	foreach (candidate in straightTiles)
	{
		if (::Brotherhood.isSameTacticalTile(candidate, _target))
		{
			local mode = straightTiles.len() > 0 && straightTiles[0].Pos.X == _origin.Pos.X ? "vertical straight" : "straight";
			return { Tiles = straightTiles, FirstDirection = straightDirection, SecondDirection = straightDirection, Mode = mode };
		}
	}

	foreach (pattern in ::Brotherhood.getDragonBreathHorizontalPatterns(_origin))
	{
		foreach (candidate in pattern.Tiles)
		{
			if (::Brotherhood.isSameTacticalTile(candidate, _target)) return pattern;
		}
	}
	return null;
}

::Brotherhood.ensureGodsEyesTierSeven <- function( _perkTree )
{
	if (!_perkTree.hasPerk("perk.bh_gods_eyes") || _perkTree.getPerkTier("perk.bh_gods_eyes") == 7) return false;

	local perk = _perkTree.getPerk("perk.bh_gods_eyes");
	foreach (row in _perkTree.m.Tree)
	{
		foreach (i, entry in row)
		{
			if (entry.ID == "perk.bh_gods_eyes")
			{
				row.remove(i);
				break;
			}
		}
	}
	while (_perkTree.m.Tree.len() < 7) _perkTree.m.Tree.push([]);
	perk.Row = 6;
	perk.Unlocks = 6;
	_perkTree.m.Tree[6].push(perk);
	return true;
}

::Brotherhood.initializeArtillerist <- function()
{
	local defs = [
		["perk.bh_more_ammo", "More Ammo!", "perk.bags_and_belts"],
		["perk.bh_gunpowder_mastery", "Gunpowder Mastery", "perk.mastery.crossbow"],
		["perk.bh_explosive_bullets", "Explosive Bullets", "perk.head_hunter"]
		,["perk.bh_parry_a_gun", "Parry a Gun!", "perk.quick_hands"]
	];
	local customIcons = {
		"perk.bh_more_ammo": ["ui/perks/bh_more_ammo.png", "ui/perks/bh_more_ammo_sw.png"],
		"perk.bh_gunpowder_mastery": ["ui/perks/bh_gunpowder_mastery.png", "ui/perks/bh_gunpowder_mastery_sw.png"]
	};
	local perks = [];
	foreach (d in defs)
	{
		local source = ::Const.Perks.findById(d[2]);
		local icon = source == null ? "ui/perks/perk_10.png" : source.Icon;
		local disabled = source == null ? "ui/perks/perk_10_sw.png" : source.IconDisabled;
		if (d[0] in customIcons)
		{
			icon = customIcons[d[0]][0];
			disabled = customIcons[d[0]][1];
		}
		perks.push({ID=d[0], Script="scripts/skills/perks/perk_"+d[0].slice(5), Name=d[1], Tooltip=::Brotherhood.getArtilleristTooltip(d[0]), Icon=icon, IconDisabled=disabled, PerkGroupIDs=[]});
	}
	::DynamicPerks.Perks.addPerks(perks);
	if (!::Brotherhood.shouldInitializeArchetypeModule(["pg.bh_artillerist"])) return;

	::Brotherhood.HooksMod.hook(::DynamicPerks.Class.PerkTree, function(q) {
		q.build = @(__original) { function build()
		{
			local ret=__original();
			if ("BH_SelectedFleshcraftParents" in this.m) return ret;
			local duoPerks=[];
			if(this.hasPerkGroup("pg.bh_artillerist") && this.hasPerkGroup("pg.bh_swashbuckler"))
			{
				this.addPerk("perk.bh_parry_a_gun",6);
				duoPerks.push("perk.bh_parry_a_gun");
			}
			if(this.hasPerkGroup("pg.bh_duelist") && this.hasPerkGroup("pg.bh_marksman"))
			{
				this.addPerk("perk.bh_gods_eyes",7);
				duoPerks.push("perk.bh_gods_eyes");
			}
			::Brotherhood.logGeneratedPerkTree(this,duoPerks);
			return ret;
		}}.build;

		q.onDeserialize = @(__original) { function onDeserialize( _in )
		{
			local ret = __original(_in);
			if (::Brotherhood.ensureGodsEyesTierSeven(this))
			{
				local actor = this.getActor();
				::logInfo("[Brotherhood][GOD'S EYES] Moved " + (::MSU.isNull(actor) ? "loaded character" : actor.getName()) + "'s duo perk from tier 6 to tier 7.");
			}
			return ret;
		}}.onDeserialize;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/reload_handgonne_skill", function(q) {
		q.onAfterUpdate = @(__original) { function onAfterUpdate( _properties )
		{
			__original(_properties);
			if (this.getContainer()!=null && this.getContainer().hasSkill("perk.bh_gunpowder_mastery")) this.m.ActionPointCost=6;
		}}.onAfterUpdate;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/fire_handgonne_skill", function(q) {
		q.m.BH_DragonBreathDirection <- null;
		q.m.BH_DragonBreathMode <- null;

		q.onAfterUpdate = @(__original) { function onAfterUpdate( _properties )
		{
			__original(_properties);
			local dragon=this.getContainer()==null?null:this.getContainer().getSkillByID("perk.bh_dragons_breath");
			if(dragon!=null)
			{
				this.m.MinRange=1;
				this.m.MaxRange=4;
				this.m.MaxRangeBonus=0;
				return;
			}
			local perk=this.getContainer()==null?null:this.getContainer().getSkillByID("perk.bh_parry_a_gun");
			this.m.MinRange=perk!=null&&perk.m.IsCloseRangeHandgonne?1:2;
		}}.onAfterUpdate;
		q.getMaxRange = @(__original) { function getMaxRange()
		{
			return this.getContainer()!=null&&this.getContainer().hasSkill("perk.bh_dragons_breath") ? 4 : __original();
		}}.getMaxRange;
		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret=__original();
			local dragon=this.getContainer()==null?null:this.getContainer().getSkillByID("perk.bh_dragons_breath");
			if(dragon!=null)
			{
				ret=ret.filter(@(_,entry) !("text" in entry) || (entry.text.find("Can hit up to 6 targets")==null && entry.text.find("engaged in melee")==null));
				ret.push({id=93,type="text",icon="ui/icons/special.png",text="Dragon's Breath fires in any of the six straight directions, including vertical, or in a left/right horizontal zig-zag; the path continues for "+::MSU.Text.colorPositive("4")+" tiles"});
				ret.push({id=94,type="text",icon="ui/icons/ranged_skill.png",text="Can be fired while adjacent to enemies"});
				ret.push({id=95,type="text",icon="skills/active_202.png",text="Enemies hit are set Burning until the start of their next turn"});
				ret.push({id=96,type="text",icon="ui/icons/special.png",text="After firing, moves back one tile if the tile directly behind is free"});
			}
			local perk=this.getContainer()==null?null:this.getContainer().getSkillByID("perk.bh_parry_a_gun");
			if(perk!=null&&perk.m.IsCloseRangeHandgonne)
			{
				ret=ret.filter(@(_,entry) !("text" in entry) || entry.text.find("engaged in melee")==null);
				ret.push({id=93,type="text",icon="ui/icons/ranged_skill.png",text="Parry a Gun! allows firing while engaged and reduces minimum range to "+::MSU.Text.colorPositive("1")+" tile"});
			}
			return ret;
		}}.getTooltip;
		q.isUsable = @(__original) { function isUsable()
		{
			if(this.getContainer()!=null&&this.getContainer().hasSkill("perk.bh_dragons_breath"))return this.skill.isUsable()&&this.getItem().isLoaded();
			local perk=this.getContainer()==null?null:this.getContainer().getSkillByID("perk.bh_parry_a_gun");
			if(perk==null||!perk.m.IsCloseRangeHandgonne)return __original();
			return this.skill.isUsable()&&this.getItem().isLoaded();
		}}.isUsable;
		q.onVerifyTarget = @(__original) { function onVerifyTarget( _originTile, _targetTile )
		{
			if(!__original(_originTile,_targetTile))return false;
			if(this.getContainer()==null||!this.getContainer().hasSkill("perk.bh_dragons_breath"))return true;
			return ::Brotherhood.resolveDragonBreathPattern(_originTile,_targetTile)!=null;
		}}.onVerifyTarget;
		q.getAffectedTiles = @(__original) { function getAffectedTiles( _targetTile )
		{
			if(this.getContainer()==null||!this.getContainer().hasSkill("perk.bh_dragons_breath"))return __original(_targetTile);
			local ownTile=this.getContainer().getActor().getTile();
			local pattern=::Brotherhood.resolveDragonBreathPattern(ownTile,_targetTile);
			if(pattern==null)return [];
			local ret=[];
			foreach(tile in pattern.Tiles)
			{
				if(::Math.abs(tile.Level-ownTile.Level)<=this.m.MaxLevelDifference)ret.push(tile);
			}
			return ret;
		}}.getAffectedTiles;
		q.onAnySkillUsed = @(__original) { function onAnySkillUsed( _skill, _targetEntity, _properties )
		{
			__original(_skill,_targetEntity,_properties);
			if (_skill!=this || this.getContainer()==null) return;
			if (this.getContainer().hasSkill("perk.bh_gunpowder_mastery")) _properties.DamageDirectAdd+=0.10;
			if (this.getContainer().hasSkill("effects.bh_explosive_bullets_loaded"))
			{
				_properties.DamageArmorMult*=1.60;
				_properties.DamageDirectAdd+=0.20;
			}
		}}.onAnySkillUsed;
		q.onUse = @(__original) { function onUse( _user, _targetTile )
		{
			local dragon=this.getContainer()==null?null:this.getContainer().getSkillByID("perk.bh_dragons_breath");
			if(dragon!=null&&_user!=null&&_user.isPlacedOnMap())
			{
				local pattern=::Brotherhood.resolveDragonBreathPattern(_user.getTile(),_targetTile);
				this.m.BH_DragonBreathDirection=pattern==null?null:pattern.FirstDirection;
				this.m.BH_DragonBreathMode=pattern==null?null:pattern.Mode;
			}
			local explosive=this.getContainer()==null?null:this.getContainer().getSkillByID("effects.bh_explosive_bullets_loaded");
			local ret=__original(_user,_targetTile);
			if(ret&&dragon!=null)
			{
				local mode=this.m.BH_DragonBreathMode==null?"unresolved":this.m.BH_DragonBreathMode;
				local first=this.m.BH_DragonBreathDirection==null?"none":this.m.BH_DragonBreathDirection.tostring();
				local recoil=this.m.BH_DragonBreathDirection==null?"none":((this.m.BH_DragonBreathDirection+3)%6).tostring();
				::Brotherhood.logObsidianTest("DRAGONS BREATH",_user,"Fired a four-tile "+mode+" Handgonne line; first direction="+first+" and recoil direction="+recoil+".");
			}
			if(ret && explosive!=null)
			{
				::Brotherhood.logArchetypeTest("EXPLOSIVE BULLETS",_user,"Fired the loaded explosive Handgonne shot; +60% armor damage and +20% armor penetration applied.");
				explosive.removeSelf();
			}
			return ret;
		}}.onUse;
		q.applyEffectToTargets = @(__original) { function applyEffectToTargets( _tag )
		{
			__original(_tag);
			local user=_tag.User;
			local direction=this.m.BH_DragonBreathDirection;
			local mode=this.m.BH_DragonBreathMode;
			this.m.BH_DragonBreathDirection=null;
			this.m.BH_DragonBreathMode=null;
			if(direction==null||user==null||!user.isAlive()||!user.isPlacedOnMap()||!user.getSkills().hasSkill("perk.bh_dragons_breath"))return;
			local ownTile=user.getTile();
			local behindDir=(direction+3)%6;
			if(!ownTile.hasNextTile(behindDir))
			{
				::Brotherhood.logObsidianTest("DRAGONS BREATH",user,"Recoil rejected: no tile exists directly behind the shooter.");
				return;
			}
			local behind=ownTile.getNextTile(behindDir);
			if(!behind.IsEmpty)
			{
				::Brotherhood.logObsidianTest("DRAGONS BREATH",user,"Recoil rejected: the tile directly behind is occupied or blocked.");
				return;
			}
			if(::Math.abs(behind.Level-ownTile.Level)>1)
			{
				::Brotherhood.logObsidianTest("DRAGONS BREATH",user,"Recoil rejected: the tile directly behind differs by more than one height level.");
				return;
			}
			::Tactical.getNavigator().teleport(user,behind,null,null,false);
			::Brotherhood.logObsidianTest("DRAGONS BREATH",user,"Recoiled one tile backward after firing the "+(mode==null?"unresolved":mode)+" path; direction="+behindDir+".");
		}}.applyEffectToTargets;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.getFatigueCost = @(__original) { function getFatigueCost()
		{
			local cost=__original();
			if(this.getContainer()==null || !this.getContainer().hasSkill("perk.bh_gunpowder_mastery")) return cost;
			local item=this.getItem();
			return ::Brotherhood.isHandgonne(item) ? ::Math.max(0,::Math.round(cost*0.75)) : cost;
		}}.getFatigueCost;
	});

	// Dynamic perk initialization can precede the equipped ammo item on some
	// tactical entry paths. Dispatch again from the actor after vanilla setup;
	// applyAmmoBonus is idempotent, so this can never grant the bonus twice.
	::Brotherhood.HooksMod.hook("scripts/entity/tactical/player", function(q) {
		q.onCombatStart = @(__original) { function onCombatStart()
		{
			__original();
			local perk=this.getSkills().getSkillByID("perk.bh_more_ammo");
			if(perk!=null)perk.applyAmmoBonus();
		}}.onCombatStart;
		q.onTurnStart = @(__original) { function onTurnStart()
		{
			__original();
			local perk=this.getSkills().getSkillByID("perk.bh_more_ammo");
			if(perk!=null)perk.applyAmmoBonus();
		}}.onTurnStart;
	});

	::Brotherhood.HooksMod.hook("scripts/items/item_container", function(q) {
		q.getActionCost = @(__original) { function getActionCost( _items )
		{
			local perk=this.getActor()==null?null:this.getActor().getSkills().getSkillByID("perk.bh_parry_a_gun");
			if(perk!=null && perk.m.FreeHandgonneSwap && perk.itemsContainHandgonne(_items))return 0;
			return __original(_items);
		}}.getActionCost;
		q.payForAction = @(__original) { function payForAction( _items )
		{
			local perk=this.getActor()==null?null:this.getActor().getSkills().getSkillByID("perk.bh_parry_a_gun");
			local equipped=this.getActor()==null?null:this.getActor().getMainhandItem();
			local freeHandgonne=perk!=null&&perk.m.FreeHandgonneSwap&&::Brotherhood.isHandgonne(equipped)&&perk.itemsContainHandgonne(_items);
			local melee=perk==null?null:perk.findOneHandedMelee(_items);
			local handgonne=perk==null?null:perk.findHandgonne(_items);
			local ret=__original(_items);
			if(freeHandgonne)perk.onFreeHandgonneEquipped();
			else if(perk!=null&&perk.m.IsCloseRangeHandgonne&&melee!=null&&equipped==melee)perk.onMeleeEquipped(perk.findBagHandgonne());
			return ret;
		}}.payForAction;
	});

	::Reforged.QueueBucket.AfterHooks.push(function() {
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		::Brotherhood.appendPerkGroupMembership("perk.bh_anticipation", "pg.bh_artillerist");
		foreach(id in ["perk.bh_more_ammo","perk.bh_explosive_bullets"])
		{
			local p=::Const.Perks.findById(id);if(p!=null)p.PerkGroupIDs=["pg.bh_artillerist"];
		}
		local gunpowder=::Const.Perks.findById("perk.bh_gunpowder_mastery");if(gunpowder!=null)gunpowder.PerkGroupIDs=["pg.bh_artillerist","pg.bh_dragon"];
		local duo=::Const.Perks.findById("perk.bh_parry_a_gun");if(duo!=null)duo.PerkGroupIDs=["pg.bh_artillerist","pg.bh_swashbuckler"];
		local c=::DynamicPerks.PerkGroupCategories.findById("pgc.rf_fighting_style");
		if(c!=null){local groups=clone c.getGroups();if(groups.find("pg.bh_artillerist")==null)groups.push("pg.bh_artillerist");c.setGroups(groups);}
	});
}
