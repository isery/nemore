class @BaseUnitLogic
  constructor: (unit, options)->
    @_game = options.game
    @_gameTeamId = options.gameTeamId

    @_unit = unit

    @_unitLife = @_unit.life
    @_unitLife = @_unit.life * 0.75 unless GameTeam.findOne({_id: @_gameTeamId}).hero
    @_unitMaxLife = @_unitLife
    @_unitArmor = @_unit.armor
    @_unitBaseDamage = @_unit.damage
    @_unitCritChance = @_unit.crit
    @_unitHitChance = @_unit.accuracy
    @_unitCritFactor = @_unit.critFactor

    @_specialAbilities = SpecialAbilities.find({unitId: @_unit._id}).fetch()

    @_conditions = new BaseCondition({game: @_game, gameTeamId: @_gameTeamId})

    @_operators =
      '<': (a,b) -> a < b
      '>': (a,b) -> a > b

  baseAttack: (ability, targets, termObj = {}) ->
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

      if Object.keys(termObj).length > 0 && @_operators[termObj.operator](termObj.value, @_game[target.gameTeamId]._unitLife)
          damageToTarget * termObj.value


      target.damage = Math.floor(damageToTarget)
      target.hit = didHit
      target.crit = didCrit

      @_game[target.gameTeamId].updateLife(damageToTarget)
      target.life = @_game[target.gameTeamId]._unitLife

  baseHeal: (ability, targets) ->
    for target in targets
      target.hit = true
      target.crit = false
      target.heal = @_unitBaseDamage
      if Math.random() <= @getCritChance()
        target.crit = true
        target.heal *= @_unitCritFactor

      target.heal *= ability.value

      if (@_game[target.gameTeamId]._unitLife + target.heal) > @_game[target.gameTeamId]._unitMaxLife
        target.heal = @_game[target.gameTeamId]._unitMaxLife - @_game[target.gameTeamId]._unitLife

      target.heal *= -1
      target.heal = Math.round(target.heal)

      @_game[target.gameTeamId].updateLife(target.heal)
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
      console.log "DMG BUFF"
      console.log @_conditions._conditions['dmg'].value
      dmg += @_conditions._conditions['dmg'].value || 10
    dmg

  getCritChance: ->
    crit = @_unitCritChance
    if @_conditions._conditions['crit']
      console.log "CRIT BUFF"
      console.log @_conditions._conditions['crit'].value
      crit += @_conditions._conditions['crit'].value || 10
      @_conditions.remove 'crit'
    crit

  getHitChance: ->
    hit = @_unitHitChance
    if @_conditions._conditions['hit']
      console.log "HIT BUFF"
      console.log @_conditions._conditions['hit'].value
      hit += @_conditions._conditions['hit'].value || 10
    hit

  getArmor: ->
    armor = @_unitArmor
    if @_conditions._conditions['armor']
      console.log "ARMOR BUFF"
      console.log @_conditions._conditions['armor'].value
      armor += @_conditions._conditions['armor'].value || 10
    armor

