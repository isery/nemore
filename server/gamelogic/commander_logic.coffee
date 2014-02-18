class @CommanderLogic extends BaseUnitLogic
	constructor: (game)->
		@_unit = Units.findOne({name:"Commander"})

		options =
			unit: @_unit
			game: game

		super(options)

	autoattack_commander: (doc) ->
		ability = SpecialAbilities.findOne({name: "autoattack_commander"})
		@baseAutoAttack(ability, doc)

	defense_commander: (doc) ->
		ability = SpecialAbilities.findOne({name: "defense_sniper"})
		@baseDefense(ability, doc)

	buffAllCrit_commander: (doc) ->
		ability = SpecialAbilities.findOne({name: "buffAllCrit_commander"})
		@baseBuffFunction(ability, doc)

	buffAllAccuracy_commander: (doc) ->
		ability = SpecialAbilities.findOne({name: "buffAllAccuracy_commander"})
		@baseBuffFunction(ability, doc)

	buffAllDamage_commander: (doc) ->
		ability = SpecialAbilities.findOne({name: "buffAllDamage_commander"})
		@baseBuffFunction(ability, doc)