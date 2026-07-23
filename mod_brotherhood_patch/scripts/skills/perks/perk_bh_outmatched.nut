this.perk_bh_outmatched <- this.inherit("scripts/skills/skill", {
	m = { AdjacentEnemies = 0, BonusMultiplier = 1 },
	function create()
	{
		this.m.ID = "perk.bh_outmatched";
		this.m.Name = "Outmatched";
		this.m.Description = ::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);
		::Brotherhood.applySourcePerkIcon(this, "perk.underdog", "ui/perks/perk_30.png");
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}
	function isHidden(){return this.m.AdjacentEnemies==0;}
	function getTooltip()
	{
		local total=this.m.AdjacentEnemies*this.m.BonusMultiplier;
		return [
			{id=1,type="title",text=this.getName()},
			{id=2,type="description",text="You are fighting an uneven battle and gain the following benefits:"},
			{id=10,type="text",icon="ui/icons/melee_defense.png",text="Current Melee Defense: "+::MSU.Text.colorPositive("+"+(5*total))},
			{id=11,type="text",icon="ui/icons/direct_damage.png",text="Current armor penetration: "+::MSU.Text.colorPositive("+"+(5*total)+"%")}
		];
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local offhand = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		if (!::Brotherhood.isFleshcraftPermittedOffhand(offhand)) { this.m.AdjacentEnemies=0; return; }
		local enemies = 0;
		local allies = 0;
		foreach (other in ::Brotherhood.getAdjacentCombatants(actor))
		{
			if (other.isAlliedWith(actor)) ++allies;
			else ++enemies;
		}
		enemies = ::Math.min(2, enemies);
		local multiplier = allies == 0 ? 2 : 1;
		this.m.AdjacentEnemies=enemies;
		this.m.BonusMultiplier=multiplier;
		_properties.MeleeDefense += 5 * enemies * multiplier;
		_properties.DamageDirectAdd += 0.05 * enemies * multiplier;
	}
});
