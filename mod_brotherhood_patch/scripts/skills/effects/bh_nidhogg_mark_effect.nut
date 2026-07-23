this.bh_nidhogg_mark_effect <- this.inherit("scripts/skills/skill", {
	m = { OwnerID = 0, OwnerName = "" },
	function create()
	{
		this.m.ID = "effects.bh_nidhogg";
		this.m.Name = "Nidhogg";
		this.m.Description = "When the marking character hits this character, they make a second attack.";
		this.m.Icon = "ui/perks/perk_03.png";
		this.m.IconMini = "perk_36_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}
	function configure( _owner, _targetID )
	{
		this.m.OwnerID = _owner.getID();
		// Store a bracket-free roster name. Nested Tooltips treats [Text] as links.
		this.m.OwnerName = this.sanitizeName(_owner.getNameOnly());
		this.m.ID = "effects.bh_nidhogg." + _targetID;
	}
	function sanitizeName( _name )
	{
		if (_name == null) return "";
		local text = "" + _name;
		while (true)
		{
			local open = text.find("[");
			if (open == null) break;
			text = text.slice(0, open) + text.slice(open + 1);
		}
		while (true)
		{
			local close = text.find("]");
			if (close == null) break;
			text = text.slice(0, close) + text.slice(close + 1);
		}
		return text;
	}
	function getOwnerPlainName()
	{
		if (this.m.OwnerID != 0 && ::Tactical.isActive())
		{
			local owner = ::Tactical.getEntityByID(this.m.OwnerID);
			if (owner != null)
			{
				local name = this.sanitizeName(owner.getNameOnly());
				if (name != "") return name;
			}
		}
		return this.m.OwnerName;
	}
	function getDescription()
	{
		return "When the marking character hits this character, they make a second attack.";
	}
	function getTooltip()
	{
		local ownerName = this.getOwnerPlainName();
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() }
		];
		if (ownerName != null && ownerName != "")
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Marked by " + ::MSU.Text.colorPositive(ownerName)
			});
		}
		return ret;
	}
	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU32(this.m.OwnerID);
	}
	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.OwnerID = _in.readU32();
	}
});
