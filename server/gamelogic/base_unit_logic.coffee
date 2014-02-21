class @BaseUnitLogic
  constructor: (unit, options)->
    @_game = options.game
    @_gameTeamId = options.gameTeamId

    @_unit = unit

    @_unitLife = @_unit.life
    @_unitLife = @_unit.life * 0.75 unless GameTeam.findOne({_id: @_gameTeamId}).hero
    @_unitArmor = @_unit.armor
    @_unitBaseDamage = @_unit.damage
    @_unitCritChance = @_unit.crit
    @_unitHitChance = @_unit.accuracy
    @_unitCritFactor = 1.75

    @_specialAbilities = SpecialAbilities.find({unitId: @_unit._id}).fetch()

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
    GameTeam.update(@_gameTeamId, {life: @_unitLife})

  generateRandomAbility: ->
    @_specialAbilities[Math.floor(Math.random() * @_specialAbilities.length)]
