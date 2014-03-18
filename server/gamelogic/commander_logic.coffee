class @CommanderLogic extends BaseUnitLogic
	constructor: (options)->
		@_unit = Units.findOne({name:"Commander"})
		super(@_unit, options)

	heal_commander: (ability, targets) ->
		@baseHeal(ability, targets)

	trueDamage_commander: (ability, targets) ->
		@baseAttack(ability, targets)

	hitBuff_commander: (ability, targets) ->
		@baseBuffFunction(ability,targets)

	attack_commander: (ability, targets) ->
		@baseAttack(ability, targets)
