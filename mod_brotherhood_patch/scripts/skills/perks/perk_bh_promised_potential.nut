this.perk_bh_promised_potential <- this.inherit("scripts/skills/skill", {
	m = {
		Chance = 1,
		QualifiedKill = false,
		BestKillXP = 0
	},

	function create()
	{
		this.m.ID = "perk.bh_promised_potential";
		this.m.Name = "Promised Potential";
		this.m.Description = ::Brotherhood.getNewArchetypeTooltip(this.m.ID);
		this.m.Icon = "ui/perks/bh_promised_potential.png";
		this.m.IconDisabled = "ui/perks/bh_promised_potential_sw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
	}

	function getSuccessChance()
	{
		return this.m.Chance;
	}

	function ensureChanceEffect()
	{
		if (!this.getContainer().hasSkill("effects.bh_promised_potential"))
		{
			this.getContainer().add(this.new("scripts/skills/effects/bh_promised_potential_effect"));
		}
	}

	function setSuccessChance( _chance )
	{
		this.m.Chance = this.Math.max(1, this.Math.min(80, _chance));
		this.ensureChanceEffect();
		this.getContainer().getActor().setDirty(true);
	}

	function onAdded()
	{
		this.ensureChanceEffect();
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.bh_promised_potential");
	}

	function onUpdate( _properties )
	{
		this.ensureChanceEffect();
	}

	function onTargetKilled( _target, _skill )
	{
		this.m.QualifiedKill = true;
		this.m.BestKillXP = ::Math.max(this.m.BestKillXP, _target.getXPValue());
	}

	function onCombatFinished()
	{
		if (this.m.QualifiedKill)
		{
			local gain = ::Math.max(1, ::Math.min(5, 1 + (this.m.BestKillXP / 75).tointeger()));
			this.setSuccessChance(this.m.Chance + gain);
			::Brotherhood.logArchetypeTest("PROMISED POTENTIAL", this.getContainer().getActor(), "Qualified victory increased chance by " + gain + "% to " + this.m.Chance + "%.");
		}

		this.m.QualifiedKill = false;
		this.m.BestKillXP = 0;
		this.skill.onCombatFinished();
	}

	function onUpdateLevel()
	{
		local actor = this.getContainer().getActor();
		if (actor.getLevel() < 11) return;

		local chance = this.m.Chance;
		local success = ::Reforged.Math.randWithSeed(1, 100, actor.getUID(), this.getID()) <= chance;
		this.getContainer().removeByID("effects.bh_promised_potential");
		this.removeSelf();

		local id = success ? "perk.bh_realized_potential" : "perk.bh_wasted_potential";
		actor.getPerkTree().removePerk(this.getID());
		actor.getPerkTree().addPerk(id, 1);

		local script = success ? "scripts/skills/perks/perk_bh_realized_potential" : "scripts/skills/perks/perk_bh_wasted_potential";
		this.getContainer().add(::new(script));
		actor.setDirty(true);
		::Brotherhood.logArchetypeTest("PROMISED POTENTIAL", actor, "Level 11 roll at " + chance + "%: " + (success ? "REALIZED" : "WASTED") + ".");
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(this.m.Chance);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Chance = _in.readU8();
	}
});
