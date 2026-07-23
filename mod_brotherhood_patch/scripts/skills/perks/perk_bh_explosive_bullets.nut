this.perk_bh_explosive_bullets <- this.inherit("scripts/skills/skill", {
	m={},function create(){this.m.ID="perk.bh_explosive_bullets";this.m.Name="Explosive Bullets";this.m.Description=::Brotherhood.getArtilleristTooltip(this.m.ID);this.m.Icon="ui/perks/perk_15.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function onAdded(){if(!this.getContainer().hasSkill("actives.bh_load_explosive_bullets"))this.getContainer().add(this.new("scripts/skills/actives/bh_load_explosive_bullets_skill"));}
	function onRemoved(){this.getContainer().removeByID("actives.bh_load_explosive_bullets");this.getContainer().removeByID("effects.bh_explosive_bullets_loaded");}
});
