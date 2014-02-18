class @DroneLogic extends BaseUnitLogic
	constructor: (game)->
		@_unit = Units.findOne({name:"Drone"})

		options =
			unit: @_unit
			game: game

		super(options)

	autoattack_drone: (doc) ->
		ability = SpecialAbilities.findOne({name: "autoattack_drone"})
		@baseAutoAttack(ability, doc)

	defense_drone: (doc) ->
		ability = SpecialAbilities.findOne({name: "defense_drone"})
		@baseDefense(ability, doc)

	armorAll_drone: (doc) ->
		ability = SpecialAbilities.findOne({name: "armorAll_drone"})
		@baseBuffFunction(ability, doc)

	armorSelf_drone: (doc) ->
		ability = SpecialAbilities.findOne({name: "armorSelf_drone"})
		@baseDefense(ability, doc)

	armorTarget_drone: (doc) ->
		ability = SpecialAbilities.findOne({name: "armorTarget_drone"})
		@baseBuffFunction(ability, doc)
