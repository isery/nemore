class @SniperLogic extends BaseUnitLogic
	constructor: (options)->
		@_unit = Units.findOne({name:"Sniper"})
		super(@_unit, options)

	attack_sniper: (ability, targets) ->
		@baseAttack(ability, targets)

	steadyShot_sniper: (ability, targets) ->
		@baseAttack(ability, targets)

	executeShot_sniper: (ability, targets) ->
		termObj =
			term: Terms.findOne({name: '< 50'})
			value: 0.8
		@baseAttack(ability, targets, termObj)

	critBuff_sniper: (ability, targets) ->
		@baseBuffFunction(ability, targets)
