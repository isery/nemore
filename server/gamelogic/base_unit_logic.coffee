class @BaseUnitLogic
    _operators:
      '<': (a,b) ->  a < b
      '>': (a,b) ->  a > b
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
    @_unitCritFactor = @_unit.critFactor

    @_specialAbilities = SpecialAbilities.find({unitId: @_unit._id}).fetch()

    @_conditions = new BaseCondition({game: @_game, gameTeamId: @_gameTeamId})

  baseAttack: (ability, targets, term = false) ->
    damageFactor = parseFloat(ability.value)

    for target in targets
      if Math.random() <= @getHitChance()
        didHit = true
        didCrit = false
        damageToTarget = damageFactor * @getBaseDamage() * @_game[target.gameTeamId].getArmor()
        if Math.random() <= @getCritChance()
          didCrit = true
          damageToTarget = damageToTarget * @getCritChance()
      else
        didHit = false
        didCrit = false
        damageToTarget = 0

      if term
        @_operators[term.operator](term.value, @_game[target.gameTeamId]._unitLife)


      target.damage = Math.floor(damageToTarget)
      target.hit = didHit
      target.crit = didCrit

      @_game[target.gameTeamId].updateLife(damageToTarget)

      target.life = @_game[target.gameTeamId]._unitLife

  baseBuffFunction: (ability, targets) ->
    buffFactor = ability.value
    for target in targets
      @_game[target.gameTeamId]._conditions.add(ability)

  updateLife: (damage) ->
    @_unitLife -= damage
    if @_unitLife < 0
      @_unitLife = 0
    GameTeam.update(@_gameTeamId, {life: @_unitLife})

  generateRandomAbility: ->
    @_specialAbilities[Math.floor(Math.random() * @_specialAbilities.length)]

  getBaseDamage: ->
    dmg = @_unitBaseDamage
    if @_conditions._conditions['dmg']
      dmg += @_conditions._conditions['dmg'].value || 10

    dmg

  getCritChance: ->
    crit = @_unitCritChance
    if @_conditions._conditions['crit']
      crit += @_conditions._conditions['crit'].value || 10

    crit

  getHitChance: ->
    hit = @_unitBaseHitChance
    if @_conditions._conditions['hit']
      hit += @_conditions._conditions['hit'].value || 10

    hit

  getArmor: ->
    armor = @_unitArmor
    if @_conditions._conditions['armor']
      armor += @_conditions._conditions['armor'].value || 10

    armor

  baseHeal: (ability, targets)->
    for target in targets
      target.hit = false
      target.crit = false
      target.heal = 0
      if Math.random() <= @getHitChance()
        target.hit = true
        target.heal = @_unitBaseDamage
        if Math.random() <= @getCritChance()
          target.crit = true
          target.heal *= @_unitCritFactor

        target.heal *= parseFloat(ability.value)
        target.heal *= -1

      @_game[target.gameTeamId].updateLife(target.heal)
      target.life = @_game[target.gameTeamId]._unitLife
