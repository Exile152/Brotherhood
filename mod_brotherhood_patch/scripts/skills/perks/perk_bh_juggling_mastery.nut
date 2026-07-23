this.perk_bh_juggling_mastery <- this.inherit("scripts/skills/skill", {
	m = { Ricocheting = false, PendingGraze = null, PendingAxeTile = null, PendingAxeTargetID = null },
	function create(){this.m.ID="perk.bh_juggling_mastery";this.m.Name="Juggling Mastery";this.m.Description=::Brotherhood.getFleshcraftPerkTooltip(this.m.ID);::Brotherhood.applySourcePerkIcon(this,"perk.mastery.throwing","ui/perks/perk_10.png");this.m.Type=this.Const.SkillType.Perk;this.m.Order=this.Const.SkillOrder.Perk;this.m.IsActive=false;}
	function valid(_s){local w=_s==null?null:_s.getItem();return _s!=null&&_s.isAttack()&&_s.isRanged()&&::Brotherhood.isFleshcraftThrowingWeapon(w);}
	function onAfterUpdate(_p){foreach(s in this.getContainer().getAllSkillsOfType(this.Const.SkillType.Active))if(this.valid(s))s.m.FatigueCostMult*=0.75;}
	function buildPartialHit( _skill, _target, _multiplier )
	{
		if (_target == null || !_target.isAlive()) return null;
		local p = this.getContainer().buildPropertiesForUse(_skill, _target);
		local rolled = ::Math.rand(p.DamageRegularMin, p.DamageRegularMax);
		local totalMult = p.DamageTotalMult * p.RangedDamageMult * _multiplier;
		local part = ::Math.rand(1, 100) <= p.getHitchance(this.Const.BodyPart.Head) ? this.Const.BodyPart.Head : this.Const.BodyPart.Body;
		local direct = ::Math.maxf(0.0, _skill.m.DirectDamageMult + p.DamageDirectAdd + p.DamageDirectRangedAdd);
		local hit = clone this.Const.Tactical.HitInfo;
		hit.DamageRegular = ::Math.max(1, ::Math.floor(rolled * totalMult));
		hit.DamageArmor = ::Math.max(1, ::Math.floor(rolled * totalMult * p.DamageArmorMult));
		hit.DamageDirect = ::Math.minf(1.0, p.DamageDirectMult * direct);
		hit.DamageFatigue = 0;
		hit.DamageMinimum = 0;
		hit.BodyPart = part;
		hit.BodyDamageMult = 1.0;
		hit.FatalityChanceMult = 0.0;
		hit.Injuries = null;
		hit.InjuryThresholdMult = 1.0;
		hit.Tile = _target.getTile();
		return hit;
	}
	function dealPartialDamage( _skill, _target, _multiplier, _reason )
	{
		local hit = this.buildPartialHit(_skill, _target, _multiplier);
		if (hit == null) return false;
		_target.onDamageReceived(this.getContainer().getActor(), _skill, hit);
		::Brotherhood.logFleshcraftMechanic("JUGGLING MASTERY", this.getContainer().getActor(), _reason + " hit " + _target.getName() + " for " + ::Math.round(_multiplier * 100) + "% damage.");
		return true;
	}
	function isSpear(_s){if(_s==null)return false;local id=_s.getID().tolower();local w=_s.getItem();return id.find("throw_javelin")!=null||(w!=null&&(w.getID().tolower().find("javelin")!=null||w.getID().tolower().find("throwing_spear")!=null));}
	function isAxe(_s){if(_s==null)return false;local id=_s.getID().tolower();local w=_s.getItem();return id.find("throw_axe")!=null||(w!=null&&w.getID().tolower().find("throwing_axe")!=null);}
	function onTargetMissed(_s,_target)
	{
		if (!this.valid(_s) || !this.isSpear(_s)) return;
		local hit = this.buildPartialHit(_s, _target, 0.25);
		this.m.PendingGraze = hit == null ? null : { Skill = _s, Target = _target, Hit = hit };
	}
	function resolvePendingGraze( _unused = null )
	{
		local pending = this.m.PendingGraze;
		this.m.PendingGraze = null;
		if (pending == null || pending.Target == null || !pending.Target.isAlive()) return false;
		pending.Target.onDamageReceived(this.getContainer().getActor(), pending.Skill, pending.Hit);
		::Brotherhood.logFleshcraftMechanic("JUGGLING MASTERY", this.getContainer().getActor(), "Javelin graze hit the intended target " + pending.Target.getName() + " for 25% damage.");
		return true;
	}
	function schedulePendingGraze()
	{
		if(this.m.PendingGraze==null)return false;
		// MV starts the miss projectile after onTargetMissed. Let that projectile
		// reach the target before applying the graze damage.
		this.Time.scheduleEvent(this.TimeUnit.Virtual,250,this.resolvePendingGraze.bindenv(this),null);
		return true;
	}
	function resolveRicochet( _tag )
	{
		local container = this.getContainer();
		local actor = container == null ? null : container.getActor();
		if (_tag.Target != null && !::MSU.isNull(_tag.Target) && _tag.Target.isAlive() && !_tag.Target.isDying() && _tag.IsHit)
		{
			_tag.Skill.spawnAttackEffect(_tag.Target.getTile(), this.Const.Tactical.AttackEffectChop);
			if (_tag.Skill.m.SoundOnHit.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * _tag.Skill.m.SoundVolume, _tag.Target.getPos());
			}
			_tag.Target.onDamageReceived(actor, _tag.Skill, _tag.Hit);
			::Brotherhood.logFleshcraftMechanic("JUGGLING MASTERY", actor, "Throwing axe ricochet visibly hit " + _tag.Target.getName() + " for 25% damage (Chance: " + _tag.Chance + ", Rolled: " + _tag.Roll + ").");
		}
		else if (_tag.Target != null && !::MSU.isNull(_tag.Target) && _tag.Target.isAlive() && !_tag.Target.isDying())
		{
			_tag.Target.onMissed(actor, _tag.Skill, false);
			if (container != null) container.onTargetMissed(_tag.Skill, _tag.Target);
			if (_tag.Skill.m.SoundOnMiss.len() != 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnMiss[this.Math.rand(0, _tag.Skill.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * _tag.Skill.m.SoundVolume, _tag.Target.getPos());
			}
			::Brotherhood.logFleshcraftMechanic("JUGGLING MASTERY", actor, "Throwing axe ricochet visibly missed " + _tag.Target.getName() + " (Chance: " + _tag.Chance + ", Rolled: " + _tag.Roll + ").");
		}
		this.m.Ricocheting = false;
		if (container != null) container.setBusy(false);
	}
	function scheduleRicochet( _skill, _fromTile, _target )
	{
		local chance = _skill.getHitchance(_target);
		local roll = this.Math.rand(1, 100);
		local isHit = roll <= chance;
		local hit = isHit ? this.buildPartialHit(_skill, _target, 0.25) : null;
		if (isHit && hit == null) return false;
		this.m.Ricocheting = true;
		this.getContainer().setBusy(true);
		local flip = !_skill.m.IsProjectileRotated && _target.getPos().X > _fromTile.Pos.X;
		local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[_skill.getProjectileType()], _fromTile, _target.getTile(), 1.0, _skill.m.ProjectileTimeScale, _skill.m.IsProjectileRotated, flip);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.resolveRicochet.bindenv(this), { Skill = _skill, Target = _target, Hit = hit, IsHit = isHit, Chance = chance, Roll = roll });
		return true;
	}
	function onAnySkillUsed(_s,_target,_properties)
	{
		if(!this.valid(_s)||!this.isAxe(_s)||_target==null||!_target.isPlacedOnMap())return;
		this.m.PendingAxeTile=_target.getTile();
		this.m.PendingAxeTargetID=_target.getID();
	}
	function onTargetHit(_s,_target,_part,_hp,_armor)
	{
		if(this.m.Ricocheting||!this.valid(_s)||!this.isAxe(_s)||_target==null)return;
		local tile=_target.isPlacedOnMap()?_target.getTile():this.m.PendingAxeTile;
		if(tile==null)return;
		local actor=this.getContainer().getActor();
		local candidates=[];
		for(local d=0;d<6;++d)
		{
			if(!tile.hasNextTile(d))continue;
			local n=tile.getNextTile(d);
			if(!n.IsOccupiedByActor)continue;
			local e=n.getEntity();
			if(e!=null&&e.isAlive()&&!e.isDying()&&!e.isAlliedWith(actor)&&e.getID()!=_target.getID())candidates.push(e);
		}
		if(candidates.len()==0)return;
		candidates.sort(@(a,b)a.getID()<=>b.getID());
		this.scheduleRicochet(_s,tile,candidates[0]);
	}
	function onAnySkillExecutedFully(_s,_tile,_target,_free)
	{
		if(this.valid(_s)&&this.isAxe(_s)){this.m.PendingAxeTile=null;this.m.PendingAxeTargetID=null;}
	}
	function onCombatStarted(){this.m.PendingGraze=null;this.m.Ricocheting=false;this.m.PendingAxeTile=null;this.m.PendingAxeTargetID=null;}
	function onCombatFinished(){this.m.PendingGraze=null;this.m.Ricocheting=false;this.m.PendingAxeTile=null;this.m.PendingAxeTargetID=null;this.skill.onCombatFinished();}
});
