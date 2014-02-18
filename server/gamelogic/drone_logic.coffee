class @DroneLogic
	constructor: (data)->

		@_unit = Units.findOne({name:"Drone"})

		@_unitLife = @_unit.life
		@_unitArmor = @_unit.armor
		@_unitBaseDamage = @_unit.damage
		@_unitCritChance = @_unit.crit
		@_unitCritFactor = 1.75

		@_unitHitChance = @_unit.accuracy

		@_specialAbilities = SpecialAbilities.find({unit_id: @_unit._id})


	autoattack_drone: (data) ->

	defense_drone: (data) ->

	armorAll_drone: (data) ->

	armorSelf_drone: (data) ->

	armorTarget_drone: (data) ->