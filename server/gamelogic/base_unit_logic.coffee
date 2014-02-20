class @BaseUnitLogic
  constructor: (options, base)->

    @_game = base.game
    @_gameTeamId = @_game.gameTeamId
    @_unit = options.unit
    @_unitLife = @_unit.life
    @_unitArmor = @_unit.armor
    @_unitBaseDamage = @_unit.damage
    @_unitCritChance = @_unit.crit
    @_unitHitChance = @_unit.accuracy
    @_unitCritFactor = 1.75

    @_specialAbilities = SpecialAbilities.find({unit_id: @_unit._id}).fetch()

  baseAttack: (ability, targets) ->
    damageFactor = parseFloat(ability.factor)

    for target in targets
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

      @_game[target.gameTeamId].updateLife(damageToTarget)

      target.life = @_game[target.gameTeamId]._unitLife

  baseDefense: (ability, targets) ->
    buffFactor = ability.factor

  baseBuffFunction: (ability, targets) ->
    buffFactor = ability.factor

  updateLife: (damage) ->
    @_unitLife -= damage
    console.log damage
    console.log @_unitLife
    GameTeam.update(@_gameTeamId, {life: @_unitLife})

  generateRandomAbility: ->
    @_specialAbilities[Math.floor(Math.random() * @_specialAbilities.length)]