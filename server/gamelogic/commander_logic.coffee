class @CommanderLogic
	constructor: (data)->
		@_unit = Units.findOne({name:"Commander"})

		@_unitLife = @_unit.life
		@_unitArmor = @_unit.armor
		@_unitBaseDamage = @_unit.damage
		@_unitCritChance = @_unit.crit
		@_unitHitChance = @_unit.accuracy
		@_unitCritFactor = 1.75
		@_specialAbilities = SpecialAbilities.find({unit_id: @_unit._id})


	autoattack_commander: (data) ->

	defense_commander: (data) ->

	buffAllCrit_commander: (data) ->

	buffAllAccuracy_commander: (data) ->

	buffAllDamage_commander: (data) ->