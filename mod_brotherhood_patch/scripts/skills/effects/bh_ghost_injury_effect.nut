this.bh_ghost_injury_effect <- this.inherit("scripts/skills/skill", {
	m = { SourceInjuryID = "", SourceInjuryScript = "", SourceInjuryName = "", SourceInjury = null },
	function create()
	{
		this.m.ID = "effects.bh_ghost_injury";
		this.m.Name = "Ghost Injury";
		this.m.Description = "This character witnessed a terrible injury and believes they suffered it too.";
		this.m.Icon = "ui/perks/bh_ghost_pain.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsRemovedAfterBattle = true;
	}
	function configure( _injuryID, _injuryScript, _injuryName = "" )
	{
		this.m.SourceInjuryID = _injuryID;
		this.m.SourceInjuryScript = _injuryScript;
		this.m.SourceInjuryName = _injuryName;
		this.m.ID = ::Brotherhood.getGhostInjuryEffectID(_injuryID);
		this.rebuildSourceInjury();
	}
	function getNameOnly()
	{
		if (this.m.SourceInjury == null) this.rebuildSourceInjury();
		return this.m.SourceInjuryName == "" ? this.m.Name : "Ghost " + this.m.SourceInjuryName;
	}
	function getName() { return this.getNameOnly(); }
	function getDescription()
	{
		return "This character witnessed a terrible injury and believes they suffered it too.";
	}
	function rebuildSourceInjury()
	{
		if (this.m.SourceInjuryScript == "" && this.m.SourceInjuryID != "")
		{
			local definition = ::Brotherhood.getInjuryDefinition(this.m.SourceInjuryID);
			if (definition != null) this.m.SourceInjuryScript = definition.Script;
		}
		if (this.m.SourceInjuryScript == "") return false;
		this.m.SourceInjury = this.new("scripts/skills/" + this.m.SourceInjuryScript);
		this.m.SourceInjuryName = this.m.SourceInjury.getNameOnly();
		this.m.Name = "Ghost " + this.m.SourceInjuryName;
		this.m.Description = "This character witnessed a terrible injury and believes they suffered it too.";
		if ("IsContentWithReserve" in this.m.SourceInjury.m) this.m.SourceInjury.m.IsContentWithReserve = false;
		if ("IsHealingMentioned" in this.m.SourceInjury.m) this.m.SourceInjury.m.IsHealingMentioned = false;
		if ("IsAlwaysInEffect" in this.m.SourceInjury.m) this.m.SourceInjury.m.IsAlwaysInEffect = true;
		if ("IsFresh" in this.m.SourceInjury.m) this.m.SourceInjury.m.IsFresh = false;
		return true;
	}
	function onAdded()
	{
		this.rebuildSourceInjury();
		if (this.m.SourceInjury != null) this.m.SourceInjury.m.Container = this.getContainer();
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap()) this.spawnIcon("bh_ghost_pain", actor.getTile());
		::Brotherhood.refreshCrimsonActors();
	}
	function onRemoved()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null)
		{
			actor.setDirty(true);
		}
		::Brotherhood.refreshCrimsonActors();
	}
	function onUpdate( _properties )
	{
		if (this.m.SourceInjury == null && !this.rebuildSourceInjury()) return;
		this.m.SourceInjury.m.Container = this.getContainer();
		local before = {};
		foreach (key, value in _properties)
		{
			if (typeof value == "integer" || typeof value == "float") before[key] <- value;
			else if (typeof value == "array") before[key] <- clone value;
		}
		this.m.SourceInjury.onUpdate(_properties);
		foreach (key, oldValue in before)
		{
			if (typeof oldValue == "integer" || typeof oldValue == "float")
			{
				if (_properties[key] != oldValue) _properties[key] = oldValue + (_properties[key] - oldValue) * 0.5;
			}
			else if (typeof oldValue == "array" && typeof _properties[key] == "array")
			{
				for (local i = 0; i < oldValue.len() && i < _properties[key].len(); ++i)
				{
					if ((typeof oldValue[i] == "integer" || typeof oldValue[i] == "float") && _properties[key][i] != oldValue[i])
						_properties[key][i] = oldValue[i] + (_properties[key][i] - oldValue[i]) * 0.5;
				}
			}
		}
	}
	function halveColoredNumbers( _text )
	{
		local ret = _text;
		local searchFrom = 0;
		while (true)
		{
			local colorStart = ret.find("[color=", searchFrom);
			if (colorStart == null) break;
			local marker = ret.find("]", colorStart);
			if (marker == null) break;
			local valueStart = marker + 1;
			local valueEnd = ret.find("[/color]", valueStart);
			if (valueEnd == null) break;
			local raw = ret.slice(valueStart, valueEnd);
			local suffix = "";
			local numeric = raw;
			if (raw.len() > 0 && raw.slice(raw.len() - 1) == "%") { suffix = "%"; numeric = raw.slice(0, raw.len() - 1); }
			local first = numeric.len() == 0 ? "" : numeric.slice(0, 1);
			if (first != "-" && first != "+" && (first < "0" || first > "9")) { searchFrom = valueEnd + 8; continue; }
			local scaled = numeric.tofloat() * 0.5;
			local scaledText = scaled == this.Math.floor(scaled) ? this.Math.floor(scaled).tostring() : scaled.tostring();
			if (first == "+" && scaled > 0) scaledText = "+" + scaledText;
			ret = ret.slice(0, valueStart) + scaledText + suffix + ret.slice(valueEnd);
			searchFrom = valueStart + scaledText.len() + suffix.len() + 8;
		}
		return ret;
	}
	function getTooltip()
	{
		this.rebuildSourceInjury();
		local ret = [{ id = 1, type = "title", text = this.getNameOnly() }, { id = 2, type = "description", text = this.getDescription() }];
		if (this.m.SourceInjury != null)
		{
			this.m.SourceInjury.m.Container = this.getContainer();
			local sourceTooltip = this.m.SourceInjury.getTooltip();
			for (local i = 2; i < sourceTooltip.len(); ++i)
			{
				local entry = clone sourceTooltip[i];
				if (!("type" in entry) || entry.type != "text") continue;
				if ("text" in entry && typeof entry.text == "string") entry.text = this.halveColoredNumbers(entry.text);
				entry.id = 10 + ret.len();
				ret.push(entry);
			}
		}
		return ret;
	}
	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeString(this.m.SourceInjuryID);
		_out.writeString(this.m.SourceInjuryScript);
	}
	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.configure(_in.readString(), _in.readString());
	}
});
