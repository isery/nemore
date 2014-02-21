class @DroneLogic extends BaseUnitLogic
	constructor: (options)->
		@_unit = Units.findOne({name:"Drone"})
		super(@_unit, options)

	autoattack_drone: (ability, targets) ->
		@baseAttack(ability, targets)

	defense_drone: (ability, targets) ->
		@baseDefense(ability, targets)

	armorAll_drone: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	armorSelf_drone: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	armorTarget_drone: (ability, targets) ->
		@baseBuffFunction(ability, targets)
