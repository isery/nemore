class @SpecialistLogic extends BaseUnitLogic
  constructor: (game)->
    @_unit = Units.findOne({name:"Specialist"})

    options =
      unit: @_unit
      game: game
    super(options)

  autoattack_specialist: (doc) ->
    ability = SpecialAbilities.findOne({name: "autoattack_specialist"})
    @baseAutoAttack(ability, doc)

  defense_specialist: (doc) ->
    ability = SpecialAbilities.findOne({name: "defense_specialist"})
    @baseDefense(ability, doc)

  multiShot_specialist: (doc) ->
    ability = SpecialAbilities.findOne({name: "multiShot_specialist"})
    @baseAutoAttack(ability, doc)

  burstShot_specialist: (doc) ->
    ability = SpecialAbilities.findOne({name: "burstShot_specialist"})

    damageFactor = parseFloat(ability.factor)
    targetTo = @_targets.generateTo(ability.target_count)

    targetTo.push(targetTo[0])
    targetTo.push(targetTo[0])

    for target in targetTo
      if Math.random() <= @_unitHitChance
        didHit = true
        didCrit = false
        damageToTarget = damageFactor * @_unitBaseDamage * target.armor
        if Math.random() <= @_unitCritChance
          didCri = true
          damageToTarget = damageToTarget * @_unitCritFactor
      else
        didCrit = false
        didHit = false
        damageToTarget = 0

      target.damage = damageToTarget
      target.hit = didHit
      target.crit = didCrit
      @updateLifeOfTarget(target, damageToTarget)

    @add(targetTo, ability._id, doc)

  disableSpecialAbility_specialist: (doc) ->
    ability = SpecialAbilities.findOne({name: "disableSpecialAbility_specialist"})
    @baseBuffFunction(ability, doc)