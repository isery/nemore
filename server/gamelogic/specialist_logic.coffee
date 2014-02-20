class @SpecialistLogic extends BaseUnitLogic
  constructor: (game)->
    @_unit = Units.findOne({name:"Specialist"})

    options =
      unit: @_unit
    super(options, game)

  autoattack_specialist: (ability, targets) ->
    @baseAttack(ability, targets)

  defense_specialist: (ability, targets) ->
    @baseDefense(ability, targets)

  multiShot_specialist: (ability, targets) ->
    @baseAttack(ability, targets)

  burstShot_specialist: (ability, targets) ->
    @baseAttack(ability, targets)

  disableSpecialAbility_specialist: (ability, targets) ->
    @baseBuffFunction(ability, targets)