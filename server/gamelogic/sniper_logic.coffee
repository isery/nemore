class @SniperLogic extends BaseUnitLogic
	constructor: (game)->
		@_unit = Units.findOne({name:"Sniper"})

		options =
			unit: @_unit
			game: game
		super(options)

	autoattack_sniper: (doc) ->
		ability = SpecialAbilities.findOne({name: "autoattack_sniper"})
		@baseAutoAttack(ability, doc)

	defense_sniper: (doc) ->
		ability = SpecialAbilities.findOne({name: "defense_sniper"})


	buffAccuracy_sniper: (doc) ->
		ability = SpecialAbilities.findOne({name: "buffAccuracy_sniper"})


	buffDamage_sniper: (doc) ->
		ability = SpecialAbilities.findOne({name: "buffDamage_sniper"})


	buffCrit_sniper: (doc) ->
		ability = SpecialAbilities.findOne({name: "buffCrit_sniper"})
