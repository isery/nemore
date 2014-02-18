class @SpecialistLogic
	constructor: (data)->

		@_unit = Units.findOne({name:"Specialist"})

		@_unitLife = @_unit.life
		@_unitArmor = @_unit.armor
		@_unitBaseDamage = @_unit.damage
		@_unitCritChance = @_unit.crit
		@_unitHitChance = @_unit.accuracy
		@_unitCritFactor = 1.75

		@_specialAbilities = SpecialAbilities.find({unit_id: @_unit._id})


	autoattack_specialist: (data) ->

	defense_specialist: (data) ->

	multiShot_specialist: (data) ->

	burstShot_specialist: (data) ->

	disableSpecialAbility_specialist: (data) ->