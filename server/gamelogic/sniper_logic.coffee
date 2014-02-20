class @SniperLogic extends BaseUnitLogic
	constructor: (game)->
		@_unit = Units.findOne({name:"Sniper"})

		options =
			unit: @_unit
		super(options, game)

	autoattack_sniper: (ability, targets) ->
		@baseAttack(ability, targets)

	defense_sniper: (ability, targets) ->
		@baseDefense(ability, targets)

	buffAccuracy_sniper: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	buffDamage_sniper: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	buffCrit_sniper: (ability, targets) ->
		@baseBuffFunction(ability, targets)
