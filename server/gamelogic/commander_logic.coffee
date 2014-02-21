class @CommanderLogic extends BaseUnitLogic
	constructor: (options)->
		@_unit = Units.findOne({name:"Commander"})
		super(@_unit, options)

	autoattack_commander: (ability, targets) ->
		@baseAttack(ability, targets)

	defense_commander: (ability, targets) ->
		@baseDefense(ability, targets)

	buffAllCrit_commander: (ability, targets) ->
		@baseBuffFunction(ability,targets)

	buffAllAccuracy_commander: (ability, targets) ->
		@baseBuffFunction(ability, targets)

	buffAllDamage_commander: (ability, targets) ->
		@baseBuffFunction(ability,targets)