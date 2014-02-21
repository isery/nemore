class @SniperLogic extends BaseUnitLogic
	constructor: (options)->
		@_unit = Units.findOne({name:"Sniper"})
		super(@_unit, options)

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
