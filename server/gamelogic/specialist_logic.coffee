class @SpecialistLogic extends BaseUnitLogic
  constructor: (options)->
    @_unit = Units.findOne({name:"Specialist"})
    super(@_unit, options)

  attack_specialist: (ability, targets) ->
    @baseAttack(ability, targets)

  attackAll_specialist: (ability, targets) ->
    @baseAttack(ability, targets)

  burstShot_specialist: (ability, targets) ->
    @baseAttack(ability, targets)

  heal_specialist: (ability, targets) ->
    @baseHeal(ability, targets)
