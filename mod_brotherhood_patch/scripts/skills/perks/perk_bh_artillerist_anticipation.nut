this.perk_bh_artillerist_anticipation <- this.inherit("scripts/skills/skill", {
	m={},
	function create(){this.m.ID="perk.bh_artillerist_anticipation";this.m.Name="Anticipation";this.m.Description=::Brotherhood.getArtilleristTooltip(this.m.ID);this.m.Icon="ui/perks/perk_10.png";this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Last;this.m.IsActive=false;}
	function onUpdate(_p){_p.Vision+=1;}
	function onAfterUpdate(_p){local actor=this.getContainer().getActor();if(this.Tactical.isActive()&&actor.isPlacedOnMap()&&!::Brotherhood.hasEnemyWithinDistance(actor,1))_p.MeleeDefense+=::Math.floor(_p.RangedDefense*0.5);}
});
