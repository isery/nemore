class @DroneLogic extends BaseUnitLogic
	constructor: (options)->
		@_unit = Units.findOne({name:"Drone"})
		super(@_unit, options)

	defenseBuff_drone: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	defenseAll_drone: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	damageBuff_drone: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	damageAll_drone: (ability, targets) ->
		@baseAttack(ability, targets)