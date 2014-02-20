class @BaseUnitLogic
  constructor: (options)->
    @_game = options.game
    @_targets = @_game._targets
    @_unit = options.unit
    @_unitLife = @_unit.life
    @_unitArmor = @_unit.armor
    @_unitBaseDamage = @_unit.damage
    @_unitCritChance = @_unit.crit
    @_unitHitChance = @_unit.accuracy
    @_unitCritFactor = 1.75

    @_specialAbilities = SpecialAbilities.find({unitId: @_unit._id}).fetch()

  baseAutoAttack: (ability, doc) ->
    damageFactor = parseFloat(ability.factor)
    targetTo = @_targets.generateTo(ability.target_count)

    for target in targetTo
      if Math.random() <= @_unitHitChance
        didHit = true
        didCrit = false
        damageToTarget = damageFactor * @_unitBaseDamage * target.armor
        if Math.random() <= @_unitCritChance
          didCrit = true
          damageToTarget = damageToTarget * @_unitCritFactor
      else
        didHit = false
        didCrit = false
        damageToTarget = 0

      target.damage = damageToTarget
      target.hit = didHit
      target.crit = didCrit
      @updateLifeOfTarget(target, damageToTarget)

    @add(targetTo, ability._id, doc)

  baseDefense: (ability, doc) ->
    buffFactor = ability.factor
    targetTo = [
      gameTeamId: doc.gameTeam._id
      armor: doc.gameTeam.unit().armor
    ]

    @add(targetTo, ability._id, doc)

  baseBuffFunction: (ability, doc) ->
    buffFactor = ability.factor
    targetTo = @_targets.generateTo(ability.target_count)

    @add(targetTo, ability._id, doc)

  add: (targets, abilityId, doc) ->
    actionId = Actions.insert
      gameId: @_game._gameId
      from: doc.gameTeam._id
      to: targets
      abilityId: abilityId
      index: parseInt(doc.lastIndex) + 1
    console.log "Added Actions with id: " + actionId

  updateLifeOfTarget: (target, damageToTarget) ->
    gameTeamId = target.gameTeamId
    #curLife = GameTeam.findOne({_id: gameTeamId}).life
    curLife=  @_unitLife

    calcLife = curLife - damageToTarget
    updateLife = if calcLife < 0 then 0 else calcLife

    target.life = @_unitLife = updateLife

    options =
      life: updateLife

    GameTeam.update(gameTeamId, options)

    updateLife: () ->

  generateRandomAbility: ->
    @_specialAbilities[Math.floor(Math.random() * @_specialAbilities.length)]
