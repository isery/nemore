class @SniperLogic extends ActionDatabase
	constructor: (data)->

		@_unit = Units.findOne({name:"Sniper"})
		@_unitLife = @_unit.live
		@_unitArmor = @_unit.armor
		@_unitBaseDamage = @_unit.damage
		@_unitCritChance = @_unit.crit
		@_unitHitChance = @_unit.accuracy
		@_unitCritFactor = 1.75

		@_specialAbilities = SpecialAbilities.find({unit_id: @_unit._id}).fetch()

		@_target = new Targets()

	autoattack_sniper: (doc) ->
		#if @_targets.length == @_specialAbilities.target_count
		ability = SpecialAbilities.findOne({name: "autoattack_sniper"})
		damageFactor = ability.factor
		didHit = false

		damageToTargetWithoutArmor = parseFloat(damageFactor) * @_unitBaseDamage
		if Math.random() <= @_unitCritChance
			didHit = true
			damageToTargetWithoutArmor = damageToTargetWithoutArmor * @_unitCritFactor

		#damageToTarget = Math.floor(damageToTargetWithoutArmor * @_targets.armor)

		damageToTarget = Math.floor(damageToTargetWithoutArmor)

		###
			LT Altmann: ans Game alles draufhängen --> würde man sich das zu übergebene zeug sparen
			wat?
		###

		targetTo = @_target.generateTo
			gameId: doc.gameId
			numTargets: 1
			damage: damageToTarget
			hit: didHit

		###
		@add({
			gameId: doc.gameId
			from: @_target.generateFrom(doc.gameId)
			to:	targetTo
			abilityId: 1
			index: 1
		})
		###

	defense_sniper: (data) ->

	buffAccuracy_sniper: (data) ->

	buffDamage_sniper: (data) ->

	buffCrit_sniper: (data) ->