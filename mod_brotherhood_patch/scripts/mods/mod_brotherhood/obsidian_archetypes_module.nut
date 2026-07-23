if (!("Brotherhood" in getroottable())) return;

::Brotherhood.logObsidianTest <- function( _tag, _actor, _message )
{
	::Brotherhood.logActivePerkMechanic(_tag, _actor, _message);
}

::Brotherhood.HelpTransferAudit <- [];

::Brotherhood.trackHelpEquipmentTransfer <- function( _source, _target, _item, _slot )
{
	if (_source == null || _target == null || _item == null) return;
	if (!("World" in getroottable()) || ::World.Assets == null || !("RestoreEquipment" in ::World.Assets.m) || ::World.Assets.m.RestoreEquipment.len() == 0)
	{
		::Brotherhood.logObsidianTest("HELP RESTORE", _source, "No pre-battle equipment snapshot is active; " + _item.getName() + " will remain with " + _target.getName() + " normally.");
		return;
	}

	local instanceID = _item.getInstanceID();
	local targetStore = null;
	local removed = 0;
	foreach (store in ::World.Assets.m.RestoreEquipment)
	{
		if (store.ID == _target.getID()) targetStore = store;
		for (local i = store.Slots.len() - 1; i >= 0; --i)
		{
			local saved = store.Slots[i];
			if (saved.Item != null && saved.Item.getInstanceID() == instanceID)
			{
				store.Slots.remove(i);
				++removed;
			}
		}
	}

	local snapshotUpdated = targetStore != null;
	if (snapshotUpdated) targetStore.Slots.push({ Item = _item, Slot = _slot });
	::Brotherhood.HelpTransferAudit.push({
		Item = _item,
		InstanceID = instanceID,
		SourceID = _source.getID(),
		SourceName = _source.getName(),
		TargetID = _target.getID(),
		TargetName = _target.getName(),
		Slot = _slot
	});
	::Brotherhood.logObsidianTest("HELP RESTORE", _source, "Moved " + _item.getName() + " (instance " + instanceID + ") from " + removed + " old snapshot slot(s) to " + _target.getName() + "'s snapshot; target snapshot found=" + (snapshotUpdated ? "true" : "false") + ".");
}

::Brotherhood.findRosterActorByID <- function( _id )
{
	local tactical = ::Tactical.getEntityByID(_id);
	if (tactical != null) return tactical;
	foreach (bro in ::World.getPlayerRoster().getAll()) if (bro.getID() == _id) return bro;
	return null;
}

::Brotherhood.auditHelpEquipmentTransfers <- function()
{
	if (::Brotherhood.HelpTransferAudit.len() == 0) return;
	local records = clone ::Brotherhood.HelpTransferAudit;
	::Brotherhood.HelpTransferAudit.clear();
	foreach (record in records)
	{
		local target = ::Brotherhood.findRosterActorByID(record.TargetID);
		if (target != null && target.getItems().getItemByInstanceID(record.InstanceID) != null)
		{
			::Brotherhood.logObsidianTest("HELP RESTORE", target, "Verified " + record.Item.getName() + " (instance " + record.InstanceID + ") after equipment restoration.");
			continue;
		}

		local item = record.Item;
		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			local found = bro.getItems().getItemByInstanceID(record.InstanceID);
			if (found == null) continue;
			item = found;
			if (found.getCurrentSlotType() == ::Const.ItemSlot.Bag) bro.getItems().removeFromBag(found);
			else bro.getItems().unequip(found);
			break;
		}

		local stashEntry = ::World.Assets.getStash().getItemByInstanceID(record.InstanceID);
		if (stashEntry != null) item = ::World.Assets.getStash().remove(stashEntry.item);

		local recovered = false;
		local destination = "";
		if (target != null && target.isAlive())
		{
			if (record.Slot == ::Const.ItemSlot.Mainhand && target.getItems().equip(item))
			{
				recovered = true;
				destination = target.getName() + "'s main hand";
			}
			else if (target.getItems().addToBag(item))
			{
				recovered = true;
				destination = target.getName() + "'s bag";
			}
		}
		if (!recovered && ::World.Assets.getStash().add(item) != null)
		{
			recovered = true;
			destination = "the company stash";
		}

		local actorForLog = target != null ? target : ::Brotherhood.findRosterActorByID(record.SourceID);
		::Brotherhood.logObsidianTest("HELP RESTORE", actorForLog, (recovered ? "Recovered " : "FAILED TO RECOVER ") + item.getName() + " (instance " + record.InstanceID + ") after equipment restoration" + (recovered ? " into " + destination : "") + ".");
	}
}

::Brotherhood.getObsidianArchetypeTooltip <- function( _id )
{
	// Little Devil is shared with the mobility set. Keep its canonical tooltip
	// here while still registering it through the active Obsidian load path.
	if (_id == "perk.bh_little_devil") return ::Brotherhood.getMobilityPerkTooltip(_id);

	local data = {
		"perk.bh_not_important": ["Why attack me? Can't see I don't carry a weapon?", ["While not carrying weapons or shields, you are considered less of a threat and are targeted less."]],
		"perk.bh_sonata": ["The power of music!", ["Unlocks Sonata, which targets an ally within " + ::MSU.Text.colorPositive("4") + " tiles. Their next attack gains " + ::MSU.Text.colorPositive("{X}%") + " chance to hit (" + ::MSU.Text.colorPositive("20%") + " of your [Resolve|Concept.Bravery]) and builds " + ::MSU.Text.colorPositive("50%") + " less [Fatigue|Concept.Fatigue].", "Costs " + ::MSU.Text.colorNegative("4") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue].", "Requires a lute."]],
		"perk.bh_fuck_off": ["Humiliated by a Lute", ["Lute attacks have a " + ::MSU.Text.colorPositive("10%") + " chance to make a human enemy instantly [Fleeing|Concept.Morale] if they fail a negative [morale check|Concept.Morale].", "Requires a lute."]],
		"perk.bh_fabula": ["A fable for centuries!", ["Unlocks Fabula, which targets an ally within " + ::MSU.Text.colorPositive("4") + " tiles and triggers a positive [morale check|Concept.Morale] using the Bard's [Resolve|Concept.Bravery] instead of their own.", "Costs " + ::MSU.Text.colorNegative("6") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue].", "Requires a lute."]],
		"perk.bh_music_mastery": ["Learn the true art of music and composition!", ["Lute skills build " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "The first lute skill each [round|Concept.Round] costs " + ::MSU.Text.colorPositive("1") + " less [Action Point|Concept.ActionPoints].", "While carrying a lute, gain " + ::MSU.Text.colorPositive("+10") + " [Resolve|Concept.Bravery].", "A lute may be carried in either hand, and lute skills can be used from either hand.", "Equipping or switching a lute costs " + ::MSU.Text.colorPositive("0") + " [Action Points|Concept.ActionPoints]."]],
		"perk.bh_callous_hands": ["Weapons are for scholars and sellswords.", ["Unarmed attacks deal " + ::MSU.Text.colorPositive("+25%") + " damage.", "Punch can be used with a free off-hand."]],
		"perk.bh_martial_mastery": ["Master the martial arts.", ["Unarmed skills build " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].", "Punch costs " + ::MSU.Text.colorPositive("2") + " fewer [Action Points|Concept.ActionPoints] and gains " + ::MSU.Text.colorPositive("30%") + " armor penetration.", "While both hands are free, gain " + ::MSU.Text.colorPositive("+10") + " [Melee Defense|Concept.MeleeDefense] and " + ::MSU.Text.colorPositive("+10") + " [Initiative|Concept.Initiative]."]],
		"perk.bh_grit": ["Bend their metal.", ["Unarmed attacks gain damage and armor penetration equal to " + ::MSU.Text.colorPositive("25%") + " of accumulated [Fatigue|Concept.Fatigue]."]],
		"perk.bh_not_you": ["You thought this was about you?", ["After entering an enemy's [Zone of Control|Concept.ZoneOfControl], your next attack this [turn|Concept.Turn] against a different enemy deals " + ::MSU.Text.colorPositive("+10%") + " damage."]],
		"perk.bh_duck": ["Missed.", ["The first melee attack that misses you each [round|Concept.Round] hits another random enemy adjacent to you for " + ::MSU.Text.colorPositive("50%") + " damage."]],
		"perk.bh_playful_smile": ["This is fun.", ["Whenever an attack misses you, there is a " + ::MSU.Text.colorPositive("25%") + " chance to trigger a positive [morale check|Concept.Morale]."]],
		"perk.bh_dreadful_presence": ["Do not draw his attention.", ["Enemies adjacent to you suffer " + ::MSU.Text.colorNegative("-5") + " [Resolve|Concept.Bravery]."]],
		"perk.bh_dragons_breath": ["Fire and Sunder.", ["Handgonne attacks are fired in any of the six straight directions, including vertical, or in a left/right horizontal zig-zag instead of a cone.", "The path begins on an adjacent tile and continues for " + ::MSU.Text.colorPositive("4") + " tiles.", "Handgonne skills can be used while adjacent to enemies.", "Enemies hit are set Burning until the start of their next [turn|Concept.Turn].", "After firing, move back " + ::MSU.Text.colorPositive("1") + " tile opposite the first leg of the selected path if that tile is free."]],
		"perk.bh_fearsome": ["Make them scatter and flee!", ["Any attack that inflicts at least " + ::MSU.Text.colorPositive("1") + " point of damage to [Hitpoints|Concept.Hitpoints] triggers a [morale check|Concept.Morale] for the opponent with a penalty of " + ::MSU.Text.colorPositive("{X}%") + " (" + ::MSU.Text.colorPositive("15%") + " of your [Resolve|Concept.Bravery] - " + ::MSU.Text.colorNegative("10") + ")."]],
		"perk.bh_face_the_dragon": ["Everybody here dies.", ["Deal " + ::MSU.Text.colorPositive("+10%") + " damage for each adjacent enemy at Wavering [morale|Concept.Morale] or worse, up to " + ::MSU.Text.colorPositive("+25%") + "."]],
		"perk.bh_hard_lesson": ["Every scar is a lesson, and you been very educated.", ["Gain " + ::MSU.Text.colorPositive("+3") + " [Melee Defense|Concept.MeleeDefense] for each [temporary injury|Concept.InjuryTemporary] or [permanent injury|Concept.InjuryPermanent]."]],
		"perk.bh_sangria": ["Let the bad blood flow.", ["Whenever you receive an [injury|Concept.InjuryTemporary], heal " + ::MSU.Text.colorPositive("10%") + " of maximum [Hitpoints|Concept.Hitpoints]."]],
		"perk.bh_truthful_pain": ["To feel pain, is to be alive.", ["Convert current and newly received [temporary injuries|Concept.InjuryTemporary] into Flagellant injuries.", "Flagellant injuries do not become [permanent|Concept.InjuryPermanent]."]],
		"perk.bh_rage": ["Death is calling me!", ["Gain " + ::MSU.Text.colorPositive("+5%") + " melee damage for each " + ::MSU.Text.colorNegative("20%") + " of maximum [Hitpoints|Concept.Hitpoints] missing, up to " + ::MSU.Text.colorPositive("+25%") + " at " + ::MSU.Text.colorNegative("20%") + " or fewer [Hitpoints|Concept.Hitpoints]."]],
		"perk.bh_help": ["Here you go.", ["Unlocks Help, which gives an item from your bag to an adjacent ally.", "The item goes into their bag if it has space, or into their hand if it is a weapon and their hand is free.", "Costs " + ::MSU.Text.colorNegative("5") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("10") + " [Fatigue|Concept.Fatigue]."]],
		"perk.bh_use_mine": ["I brought enough.", ["Adjacent allies can use consumable items from your bag as though they were carrying them."]],
		"perk.bh_bladed_arm": ["An extension of your body.", ["Attacks made with daggers are also considered unarmed attacks."]],
		"perk.bh_swords_and_sandals": ["Gladiator!", ["Unlocks Swords and Sandals, which targets yourself or an ally within " + ::MSU.Text.colorPositive("4") + " tiles. Their next attack deals " + ::MSU.Text.colorPositive("+5%") + " damage per enemy adjacent to them.", "Costs " + ::MSU.Text.colorNegative("8") + " [Action Points|Concept.ActionPoints] and builds " + ::MSU.Text.colorNegative("20") + " [Fatigue|Concept.Fatigue].", "Requires a lute."]]
	};
	local d = data[_id];
	local active = _id == "perk.bh_sonata" || _id == "perk.bh_fabula" || _id == "perk.bh_help" || _id == "perk.bh_swords_and_sandals";
	return ::Brotherhood.formatSurvivalPerkTooltip({ Fluff=d[0], Effects=[{ Type=active ? ::UPD.EffectType.Active : ::UPD.EffectType.Passive, Description=d[1] }] });
}

::Brotherhood.hasLute <- function( _actor )
{
	if (_actor == null) return false;
	foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand])
	{
		local item = _actor.getItems().getItemAtSlot(slot);
		if (item != null && item.getID().tolower().find("lute") != null) return true;
	}
	return false;
}

::Brotherhood.isLuteItem <- function( _item )
{
	return _item != null && _item.getID().tolower().find("lute") != null;
}

::Brotherhood.configureLuteSlotForActor <- function( _item, _actor )
{
	if (!::Brotherhood.isLuteItem(_item)) return;
	if (_actor == null || !_actor.getSkills().hasSkill("perk.bh_music_mastery"))
	{
		_item.m.SlotType = ::Const.ItemSlot.Mainhand;
		_item.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		return;
	}

	local current = _item.getCurrentSlotType();
	if (current == ::Const.ItemSlot.Mainhand || current == ::Const.ItemSlot.Offhand)
	{
		// Never change the reported slot while equipped. item_container.unequip()
		// searches by getSlotType(), so changing it here strands the item.
		_item.m.SlotType = current;
		return;
	}

	local items = _actor.getItems();
	local slot = items.hasEmptySlot(::Const.ItemSlot.Offhand)
		? ::Const.ItemSlot.Offhand
		: (items.hasEmptySlot(::Const.ItemSlot.Mainhand) ? ::Const.ItemSlot.Mainhand : ::Const.ItemSlot.Offhand);
	_item.m.SlotType = slot;
	_item.m.BlockedSlotType = null;
}

::Brotherhood.refreshMusicMasteryLutes <- function( _actor )
{
	if (_actor == null) return;
	local items = _actor.getItems();
	local equipped = items.getItemAtSlot(::Const.ItemSlot.Mainhand);
	if (!::Brotherhood.isLuteItem(equipped)) equipped = items.getItemAtSlot(::Const.ItemSlot.Offhand);
	if (::Brotherhood.isLuteItem(equipped))
	{
		// Unequip first while the legacy two-handed blocker can still be observed
		// and cleared, then re-equip with Offhand preference and no blocked slot.
		if (equipped.getCurrentSlotType() == ::Const.ItemSlot.Mainhand && items.hasBlockedSlot(::Const.ItemSlot.Offhand)) equipped.m.BlockedSlotType = ::Const.ItemSlot.Offhand;
		if (items.unequip(equipped))
		{
			::Brotherhood.configureLuteSlotForActor(equipped, _actor);
			items.equip(equipped);
			::Brotherhood.logObsidianTest("MUSIC", _actor, "Migrated equipped lute to " + (equipped.getCurrentSlotType() == ::Const.ItemSlot.Offhand ? "off hand" : "main hand") + " with dual-hand switching enabled.");
		}
	}
	for (local i = 0; i < items.getUnlockedBagSlots(); ++i)
	{
		local item = items.getItemAtBagSlot(i);
		if (::Brotherhood.isLuteItem(item)) ::Brotherhood.configureLuteSlotForActor(item, _actor);
	}
}

::Brotherhood.canUseLuteSkills <- function( _actor )
{
	return ::Brotherhood.hasLute(_actor);
}

::Brotherhood.isLuteSkill <- function( _skill )
{
	if (_skill == null) return false;
	local id = _skill.getID();
	if (id == "actives.bh_sonata" || id == "actives.bh_fabula" || id == "actives.bh_swords_and_sandals") return true;
	local item = _skill.getItem();
	return item != null && item.getID().tolower().find("lute") != null;
}

::Brotherhood.isUnarmedSkill <- function( _skill, _actor = null )
{
	if (_skill == null || !_skill.isAttack()) return false;
	if (_skill.getID() == "actives.hand_to_hand") return true;
	if (_actor == null || !_actor.getSkills().hasSkill("perk.bh_bladed_arm")) return false;
	local item = _skill.getItem();
	return item != null && item.isItemType(::Const.Items.ItemType.Weapon) && item.isWeaponType(::Const.Items.WeaponType.Dagger);
}

::Brotherhood.UseMineConsumableSkills <- {
	"tool.throwing_net": "scripts/skills/actives/throw_net",
	"tool.reinforced_throwing_net": "scripts/skills/actives/throw_net",
	"weapon.fire_bomb": "scripts/skills/actives/throw_fire_bomb_skill",
	"weapon.smoke_bomb": "scripts/skills/actives/throw_smoke_bomb_skill",
	"weapon.daze_bomb": "scripts/skills/actives/throw_daze_bomb_skill",
	"weapon.acid_flask": "scripts/skills/actives/throw_acid_flask",
	"weapon.holy_water": "scripts/skills/actives/throw_holy_water",
	"accessory.bandage": "scripts/skills/actives/bandage_ally_skill",
	"accessory.antidote": "scripts/skills/actives/drink_antidote_skill",
	"accessory.poison": "scripts/skills/actives/coat_with_poison_skill",
	"accessory.spider_poison": "scripts/skills/actives/coat_with_spider_poison_skill"
};

::Brotherhood.createUseMineConsumableSkill <- function( _item )
{
	if (_item == null || !(_item.getID() in ::Brotherhood.UseMineConsumableSkills)) return null;
	local skill = ::new(::Brotherhood.UseMineConsumableSkills[_item.getID()]);
	skill.setItem(_item);
	if (_item.getID() == "tool.reinforced_throwing_net") skill.setReinforced(true);
	return skill;
}

::Brotherhood.isFreeLuteSwap <- function( _actor, _items )
{
	if (_actor == null || !_actor.getSkills().hasSkill("perk.bh_music_mastery")) return false;
	foreach (item in _items) if (item != null && item.getID().tolower().find("lute") != null) return true;
	return false;
}

::Brotherhood.getAdjacentEnemies <- function( _actor )
{
	local ret = [];
	if (_actor == null || !_actor.isPlacedOnMap()) return ret;
	local tile = _actor.getTile();
	for (local i = 0; i < 6; ++i)
	{
		if (!tile.hasNextTile(i)) continue;
		local next = tile.getNextTile(i);
		if (!next.IsOccupiedByActor) continue;
		local other = next.getEntity();
		if (other != null && other.isAlive() && !other.isAlliedWith(_actor)) ret.push(other);
	}
	return ret;
}

::Brotherhood.refreshUseMineSkills <- function( _actor )
{
	if (_actor == null || !_actor.isPlacedOnMap()) return;
	foreach (skill in clone _actor.getSkills().m.Skills) if (skill != null && skill.getID().find("actives.bh_use_mine_proxy") == 0) _actor.getSkills().remove(skill);
	local added = 0;
	local tile = _actor.getTile();
	for (local i = 0; i < 6; ++i)
	{
		if (!tile.hasNextTile(i)) continue;
		local next = tile.getNextTile(i);
		if (!next.IsOccupiedByActor) continue;
		local source = next.getEntity();
		if (source == null || !source.isAlliedWith(_actor) || !source.getSkills().hasSkill("perk.bh_use_mine")) continue;
		for (local bag = 0; bag < source.getItems().getUnlockedBagSlots(); ++bag)
		{
			local item = source.getItems().getItemAtBagSlot(bag);
			local sourceSkill = ::Brotherhood.createUseMineConsumableSkill(item);
			if (sourceSkill == null) continue;
			local proxy = ::new("scripts/skills/actives/bh_use_mine_proxy_skill");
			proxy.configure(source.getID(), item.getInstanceID(), sourceSkill);
			_actor.getSkills().add(proxy);
			++added;
			::Brotherhood.logObsidianTest("USE MINE", _actor, "Exposed " + sourceSkill.getName() + " from " + source.getName() + "'s bag item " + item.getName() + " (instance " + item.getInstanceID() + ").");
		}
	}
	local previous = "BH_UseMineProxyCount" in _actor.m ? _actor.m.BH_UseMineProxyCount : -1;
	if ("BH_UseMineProxyCount" in _actor.m) _actor.m.BH_UseMineProxyCount = added;
	else _actor.m.BH_UseMineProxyCount <- added;
	if (previous != added) ::Brotherhood.logObsidianTest("USE MINE", _actor, "Refreshed adjacent shared consumables: " + previous + " -> " + added + " proxy skill(s).");
}

::Brotherhood.registerObsidianArchetypePerks <- function()
{
	local defs = [
		["perk.bh_not_important","Harmless","perk.dodge"], ["perk.bh_sonata","Sonata","perk.rally_the_troops"], ["perk.bh_fuck_off","Fuck Off","perk.fearsome"], ["perk.bh_fabula","Fabula","perk.rally_the_troops"], ["perk.bh_music_mastery","Music Mastery","perk.mastery.sword"],
		["perk.bh_callous_hands","Callous Hands","perk.brawny"], ["perk.bh_martial_mastery","Martial Mastery","perk.mastery.mace"], ["perk.bh_grit","Grit","perk.battle_forged"],
		["perk.bh_little_devil","Little Devil","perk.dodge"], ["perk.bh_not_you","Not You","perk.overwhelm"], ["perk.bh_duck","Duck!","perk.anticipation"], ["perk.bh_playful_smile","Playful Smile","perk.fortified_mind"],
		["perk.bh_dreadful_presence","Dreadful Presence","perk.fearsome"], ["perk.bh_dragons_breath","Dragon's Breath","perk.mastery.crossbow"], ["perk.bh_fearsome","Fearsome","perk.fearsome"], ["perk.bh_face_the_dragon","Face the Dragon","perk.lone_wolf"],
		["perk.bh_hard_lesson","Hard Lesson","perk.hold_out"], ["perk.bh_sangria","Sangria","perk.nine_lives"], ["perk.bh_truthful_pain","Truthful Pain","perk.colossus"],
		["perk.bh_rage","Rage","perk.killing_frenzy"], ["perk.bh_help","Help","perk.bags_and_belts"], ["perk.bh_use_mine","Use Mine","perk.bags_and_belts"],
		["perk.bh_bladed_arm","Bladed Arm","perk.mastery.dagger"], ["perk.bh_swords_and_sandals","Swords and Sandals","perk.rally_the_troops"]
	];
	local perks = [];
	foreach (d in defs)
	{
		local source = ::Const.Perks.findById(d[2]);
		local custom = ::Brotherhood.getCustomPerkIcons(d[0]);
		perks.push({ ID=d[0], Script="scripts/skills/perks/perk_"+d[0].slice(5), Name=d[1], Tooltip=::Brotherhood.getObsidianArchetypeTooltip(d[0]), Icon=custom==null?(source==null?"ui/perks/perk_10.png":source.Icon):custom[0], IconDisabled=custom==null?(source==null?"ui/perks/perk_10_sw.png":source.IconDisabled):custom[1], PerkGroupIDs=[] });
	}
	::DynamicPerks.Perks.addPerks(perks);
}

::Brotherhood.initializeObsidianArchetypes <- function()
{
	::Brotherhood.registerObsidianArchetypePerks();
	if (!::Brotherhood.shouldInitializeArchetypeModule(["pg.bh_bard", "pg.bh_brawler", "pg.bh_impish", "pg.bh_dragon", "pg.bh_flagellant", "pg.bh_berserker", "pg.bh_improviser"])) return;

	::Brotherhood.HooksMod.hook(::DynamicPerks.Class.PerkTree, function(q) {
		q.build = @(__original) { function build()
		{
			local ret = __original();
			if ("BH_SelectedFleshcraftParents" in this.m) return ret;
			if (this.hasPerkGroup("pg.bh_brawler") && this.hasPerkGroup("pg.bh_knave")) this.addPerk("perk.bh_bladed_arm", 6);
			if (this.hasPerkGroup("pg.bh_bard") && this.hasPerkGroup("pg.bh_gladiator")) this.addPerk("perk.bh_swords_and_sandals", 7);
			return ret;
		}}.build;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill", function(q) {
		q.getActionPointCost = @(__original) { function getActionPointCost()
		{
			local cost = __original();
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			local mastery = actor==null?null:actor.getSkills().getSkillByID("perk.bh_music_mastery");
			if (mastery != null && ::Brotherhood.isLuteSkill(this) && !mastery.m.UsedLuteSkillThisRound) cost = ::Math.max(0, cost - 1);
			if (actor != null && actor.getSkills().hasSkill("perk.bh_martial_mastery") && ::Brotherhood.isUnarmedSkill(this, actor)) cost = ::Math.max(1, cost - 2);
			return cost;
		}}.getActionPointCost;

		q.getFatigueCost = @(__original) { function getFatigueCost()
		{
			local cost = __original();
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			if (actor == null) return cost;
			if (actor.getSkills().hasSkill("perk.bh_music_mastery") && ::Brotherhood.isLuteSkill(this)) cost = ::Math.round(cost * 0.75);
			if (actor.getSkills().hasSkill("perk.bh_martial_mastery") && ::Brotherhood.isUnarmedSkill(this, actor)) cost = ::Math.round(cost * 0.75);
			if (this.isAttack() && actor.getSkills().hasSkill("effects.bh_sonata")) cost = ::Math.round(cost * 0.5);
			return cost;
		}}.getFatigueCost;

		q.use = @(__original) { function use( _targetTile, _free=false )
		{
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			local isLute = actor != null && ::Brotherhood.isLuteSkill(this);
			local hadSonata = actor != null && actor.getSkills().hasSkill("effects.bh_sonata");
			local hadSwordsAndSandals = actor != null && actor.getSkills().hasSkill("effects.bh_swords_and_sandals");
			local actionPointCost = actor == null ? 0 : this.getActionPointCost();
			local fatigueCost = actor == null ? 0 : this.getFatigueCost();
			local ret = __original(_targetTile, _free);
			if (!ret || actor == null) return ret;
			if (isLute)
			{
				local mastery = actor.getSkills().getSkillByID("perk.bh_music_mastery");
				if (mastery != null) mastery.m.UsedLuteSkillThisRound = true;
				::Brotherhood.logObsidianTest("MUSIC", actor, "Used " + this.getName() + " for " + actionPointCost + " AP and " + fatigueCost + " Fatigue; first-lute-skill discount is now spent for this round.");
			}
			if (this.isAttack())
			{
				actor.getSkills().removeByID("effects.bh_sonata");
				actor.getSkills().removeByID("effects.bh_swords_and_sandals");
				if (hadSonata) ::Brotherhood.logObsidianTest("SONATA", actor, "Consumed Sonata on " + this.getName() + ".");
				if (hadSwordsAndSandals) ::Brotherhood.logObsidianTest("SWORDS AND SANDALS", actor, "Consumed Swords and Sandals on " + this.getName() + ".");
			}
			return ret;
		}}.use;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/actives/hand_to_hand", function(q) {
		q.onUpdate = @(__original) { function onUpdate( _properties )
		{
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			local mainhand = actor==null?null:actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
			local isOffhandPunch = actor != null
				&& actor.getSkills().hasSkill("perk.bh_callous_hands")
				&& mainhand != null
				&& !actor.getSkills().hasSkill("effects.disarmed");
			if (isOffhandPunch) return;

			__original(_properties);
			if (actor != null && actor.getSkills().hasSkill("perk.bh_callous_hands"))
			{
				_properties.MeleeDamageMult *= 1.25;
			}
		}}.onUpdate;

		q.onAnySkillUsed = @(__original) { function onAnySkillUsed( _skill, _targetEntity, _properties )
		{
			__original(_skill, _targetEntity, _properties);
			if (_skill != this) return;
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			local mainhand = actor==null?null:actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
			if (actor != null && actor.getSkills().hasSkill("perk.bh_callous_hands") && mainhand != null && !actor.getSkills().hasSkill("effects.disarmed"))
			{
				_properties.DamageRegularMin = 5;
				_properties.DamageRegularMax = 10;
				_properties.DamageArmorMult = 0.5;
			}
		}}.onAnySkillUsed;

		q.getTooltip = @(__original) { function getTooltip()
		{
			local ret = __original();
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			if (actor != null && actor.getSkills().hasSkill("perk.bh_callous_hands"))
			{
				ret.push({
					id = 90,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("[Callous Hands|Perk+perk_bh_callous_hands]: Can be used while the off hand is free, even with a one-handed item in the main hand")
				});
			}
			return ret;
		}}.getTooltip;

		q.isHidden = @(__original) { function isHidden()
		{
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			if (actor != null && actor.getSkills().hasSkill("perk.bh_callous_hands") && actor.getItems().hasEmptySlot(::Const.ItemSlot.Offhand)) return this.skill.isHidden();
			return __original();
		}}.isHidden;

		q.isUsable = @(__original) { function isUsable()
		{
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			if (actor != null && actor.getSkills().hasSkill("perk.bh_callous_hands") && actor.getItems().hasEmptySlot(::Const.ItemSlot.Offhand)) return this.skill.isUsable();
			return __original();
		}}.isUsable;
	});

	::Brotherhood.HooksMod.hook("scripts/skills/skill_container", function(q) {
		q.update = @(__original) { function update()
		{
			local ret = __original();
			local actor = this.getActor();
			if (actor == null || !actor.isPlacedOnMap()) return ret;
			local tile = actor.getTile();
			local presenceCount = 0;
			local presenceSource = null;
			for (local i = 0; i < 6; ++i)
			{
				if (!tile.hasNextTile(i)) continue;
				local next = tile.getNextTile(i);
				if (!next.IsOccupiedByActor) continue;
				local enemy = next.getEntity();
				if (enemy != null && !enemy.isAlliedWith(actor) && enemy.getSkills().hasSkill("perk.bh_dreadful_presence"))
				{
					actor.getCurrentProperties().Bravery -= 5;
					++presenceCount;
					presenceSource = enemy;
				}
			}
			local previous = "BH_DreadfulPresenceCount" in actor.m ? actor.m.BH_DreadfulPresenceCount : -1;
			if ("BH_DreadfulPresenceCount" in actor.m) actor.m.BH_DreadfulPresenceCount = presenceCount;
			else actor.m.BH_DreadfulPresenceCount <- presenceCount;
			if (previous != presenceCount && (presenceSource != null || previous > 0))
			{
				::Brotherhood.logObsidianTest("DREADFUL PRESENCE", presenceSource, actor.getName() + " is affected by " + presenceCount + " adjacent presence(s), for " + (presenceCount * -5) + " Resolve.");
			}
			return ret;
		}}.update;

		q.onTurnStart = @(__original) { function onTurnStart()
		{
			local ret = __original();
			::Brotherhood.refreshUseMineSkills(this.getActor());
			return ret;
		}}.onTurnStart;

		q.onMovementFinished = @(__original) { function onMovementFinished()
		{
			local ret = __original();
			::Brotherhood.refreshUseMineSkills(this.getActor());
			return ret;
		}}.onMovementFinished;
	});

	::Brotherhood.HooksMod.hook("scripts/items/weapons/lute", function(q) {
		q.create = @(__original) { function create()
		{
			__original();
			this.m.ConditionMax = 30.0;
			this.m.Condition = 30.0;
		}}.create;

		q.onDeserialize = @(__original) { function onDeserialize( _in )
		{
			__original(_in);
			local oldMax = this.m.ConditionMax > 0 ? this.m.ConditionMax : 1.0;
			local ratio = ::Math.maxf(0.0, ::Math.minf(1.0, this.m.Condition / oldMax));
			this.m.ConditionMax = 30.0;
			this.m.Condition = ::Math.max(1, ::Math.round(30.0 * ratio));
		}}.onDeserialize;

		q.onPutIntoBag = @(__original) { function onPutIntoBag()
		{
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			::Brotherhood.configureLuteSlotForActor(this, actor);
			return __original();
		}}.onPutIntoBag;

		q.getSlotType = @(__original) { function getSlotType()
		{
			local current = this.getCurrentSlotType();
			return current == ::Const.ItemSlot.Mainhand || current == ::Const.ItemSlot.Offhand ? current : __original();
		}}.getSlotType;
		q.getBlockedSlotType = @(__original) { function getBlockedSlotType()
		{
			local actor = this.getContainer()==null?null:this.getContainer().getActor();
			if (actor == null || !actor.getSkills().hasSkill("perk.bh_music_mastery")) return __original();
			// An old save or a newly purchased perk can still have the vanilla
			// two-handed -1 marker. Expose it once so unequip() clears it.
			if (this.getCurrentSlotType() == ::Const.ItemSlot.Mainhand && actor.getItems().hasBlockedSlot(::Const.ItemSlot.Offhand)) return ::Const.ItemSlot.Offhand;
			return null;
		}}.getBlockedSlotType;
	});

	::Brotherhood.HooksMod.hook("scripts/items/item_container", function(q) {
		q.equip = @(__original) { function equip( _item )
		{
			::Brotherhood.configureLuteSlotForActor(_item, this.getActor());
			return __original(_item);
		}}.equip;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/character/character_screen", function(q) {
		q.general_onEquipStashItem = @(__original) { function general_onEquipStashItem( _data )
		{
			local data = this.helper_queryStashItemData(_data);
			if (!("error" in data)) ::Brotherhood.configureLuteSlotForActor(data.sourceItem, data.entity);
			return __original(_data);
		}}.general_onEquipStashItem;

		q.general_onEquipBagItem = @(__original) { function general_onEquipBagItem( _data )
		{
			local data = this.helper_queryEntityItemData(_data);
			if (!("error" in data)) ::Brotherhood.configureLuteSlotForActor(data.sourceItem, data.entity);
			return __original(_data);
		}}.general_onEquipBagItem;
	});

	::Brotherhood.HooksMod.hook("scripts/states/world/asset_manager", function(q) {
		q.restoreEquipment = @(__original) { function restoreEquipment()
		{
			local ret = __original();
			::Brotherhood.auditHelpEquipmentTransfers();
			return ret;
		}}.restoreEquipment;
	});

	::Brotherhood.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
		q.general_queryUIPerkTooltipData = @(__original) { function general_queryUIPerkTooltipData( _entityId, _perkId )
		{
			local ret = __original(_entityId, _perkId);
			if (ret == null || (_perkId != "perk.bh_sonata" && _perkId != "perk.bh_fearsome")) return ret;
			local actor = ::Tactical.getEntityByID(_entityId);
			if (actor == null && ::Tactical.isActive()) actor = ::Tactical.TurnSequenceBar.getActiveEntity();
			if (actor == null && ::Tactical.isActive())
			{
				foreach (candidate in ::Tactical.Entities.getAllInstancesAsArray())
					if (candidate != null && candidate.isPlayerControlled() && candidate.getSkills().hasSkill(_perkId)) { actor = candidate; break; }
			}
			if (actor == null) return ret;
			local value = _perkId == "perk.bh_sonata"
				? ::Math.floor(actor.getCurrentProperties().getBravery() * 0.20)
				: ::Math.floor(actor.getCurrentProperties().getBravery() * 0.15) - 10;
			foreach (entry in ret)
			{
				if (!("text" in entry)) continue;
				local marker = entry.text.find("{X}");
				if (marker != null) entry.text = entry.text.slice(0, marker) + value + entry.text.slice(marker + 3);
			}
			return ret;
		}}.general_queryUIPerkTooltipData;
	});

	::Reforged.QueueBucket.AfterHooks.push(function() {
		if (!::Brotherhood.FleshcraftGenerationEnabled) return;
		local memberships = {
			"perk.bh_not_important":["pg.bh_bard"], "perk.bh_sonata":["pg.bh_bard"], "perk.bh_fuck_off":["pg.bh_bard"], "perk.bh_fabula":["pg.bh_bard"], "perk.bh_music_mastery":["pg.bh_bard"],
			"perk.bh_callous_hands":["pg.bh_brawler"], "perk.bh_martial_mastery":["pg.bh_brawler"], "perk.bh_grit":["pg.bh_brawler"],
			"perk.bh_little_devil":["pg.bh_impish"], "perk.bh_not_you":["pg.bh_impish"], "perk.bh_duck":["pg.bh_impish"], "perk.bh_playful_smile":["pg.bh_impish"],
			"perk.bh_dragons_breath":["pg.bh_dragon"], "perk.bh_fearsome":["pg.bh_dragon"],
			"perk.bh_hard_lesson":["pg.bh_flagellant"], "perk.bh_sangria":["pg.bh_flagellant"], "perk.bh_truthful_pain":["pg.bh_flagellant"],
			"perk.bh_rage":["pg.bh_berserker"],
			"perk.bh_help":["pg.bh_improviser"], "perk.bh_quick_hands":["pg.bh_improviser","pg.bh_opportunist"], "perk.bh_use_mine":["pg.bh_improviser"],
			"perk.bh_bladed_arm":["pg.bh_brawler","pg.bh_knave"], "perk.bh_swords_and_sandals":["pg.bh_bard","pg.bh_gladiator"]
		};
		foreach (id, groups in memberships) { local perk=::Const.Perks.findById(id); if(perk!=null) perk.PerkGroupIDs=clone groups; }
		::Brotherhood.appendPerkGroupMembership("perk.dodge", "pg.bh_impish");
		::Brotherhood.appendPerkGroupMembership("perk.berserk", "pg.bh_berserker");
		::Brotherhood.appendPerkGroupMembership("perk.killing_frenzy", "pg.bh_berserker");
		::Brotherhood.appendPerkGroupMembership("perk.bags_and_belts", "pg.bh_improviser");
		local category = ::DynamicPerks.PerkGroupCategories.findById("pgc.rf_fighting_style");
		if (category != null)
		{
			local groups = clone category.getGroups();
			foreach (id in ["pg.bh_bard","pg.bh_brawler","pg.bh_impish","pg.bh_dragon","pg.bh_flagellant","pg.bh_berserker","pg.bh_improviser"]) if (groups.find(id)==null) groups.push(id);
			category.setGroups(groups);
		}
	});
}
