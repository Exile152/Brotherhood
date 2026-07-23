this.perk_bh_feint <- this.inherit("scripts/skills/skill", {
	m = {},
	function create() { this.m.ID = "perk.bh_feint"; this.m.Name = "Feint"; this.m.Description = ::Brotherhood.getDuelistTooltip(this.m.ID); this.m.Icon = "ui/perks/bh_feint.png"; this.m.IconDisabled = "ui/perks/bh_feint_sw.png"; this.m.Type = this.Const.SkillType.Perk; this.m.Order = this.Const.SkillOrder.Perk; }
	function onTargetMissed( _skill, _targetEntity )
	{
		local actor = this.getContainer().getActor();
		if (_targetEntity != null && _skill.isAttack() && actor.getInitiative() > _targetEntity.getInitiative())
		{
			local refund = this.Math.floor(_skill.getFatigueCost() * 0.75);
			actor.m.Fatigue = this.Math.max(0, actor.m.Fatigue - refund);
			::Brotherhood.logDuelistTest(actor, "Feint activated; refunded " + refund + " Fatigue after a miss.");
			::Brotherhood.logFencerTest(actor, "Feint triggered against " + _targetEntity.getName() + "; initiative " + actor.getInitiative() + " > " + _targetEntity.getInitiative() + ", refunded " + refund + " Fatigue.");
		}
		else if (_targetEntity != null && _skill.isAttack()) ::Brotherhood.logFencerTest(actor, "Feint did not trigger against " + _targetEntity.getName() + "; initiative " + actor.getInitiative() + " <= " + _targetEntity.getInitiative() + ".");
	}
});
