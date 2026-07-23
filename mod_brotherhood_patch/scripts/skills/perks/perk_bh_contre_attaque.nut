this.perk_bh_contre_attaque <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "perk.bh_contre_attaque"; this.m.Name = "Contre-Attaque"; this.m.Description = ::Brotherhood.getFencerTooltip(this.m.ID); this.m.Icon = "ui/perks/bh_contre_attaque.png"; this.m.IconDisabled = "ui/perks/bh_contre_attaque_sw.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; this.m.IsActive = false; }
	function onAdded()
	{
		if (!this.getContainer().hasSkill("actives.riposte")) this.getContainer().add(::new("scripts/skills/actives/riposte"));
		local riposte = this.getContainer().getSkillByID("actives.riposte");
		if (riposte != null) riposte.m.Order = this.Const.SkillOrder.Last;
	}
	function onRemoved() { this.getContainer().removeByID("actives.riposte"); ::Brotherhood.logFencerTest(this.getContainer().getActor(), "Contre-Attaque removed its Riposte access."); }
});
