class @SpecialistLogic extends BaseUnitLogic
  constructor: (options)->
    @_unit = Units.findOne({name:"Specialist"})
    super(@_unit, options)

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