class @BaseAbility
  _parts: 1
  _doneParts: 0

  constructor: (data) ->
    @_action = data.action
    @_game = data.baseGame.game
    @_baseUnit = data.baseGame[data.action.from]
    @_abilityData = SpecialAbilities.findOne({_id: data.action.abilityId})
    @_statesArr = @_abilityData.states
    @_from = data.action.from

    # init targets here
    @_targets = []
    for target in data.action.to
      target.gameTeam = data.baseGame[target.gameTeamId]
      @_targets.push target

  play: ->
    if @_statesArr[0]
      @[@_statesArr[0]]()
    else
      @finishAnimation()

  finishPart: ->
    if @_parts == @_doneParts
      @_doneParts = 0
      @_statesArr.shift()
      @play()

  finishAnimation: ->
    # console.log "Finish Animation"
    player = GamePlayers.findOne
      gameId: @_action.gameId
      userId: Meteor.userId()
    GamePlayers.update
      _id: player._id
    ,
      $set:
        state: 'waiting'
        lastIndex: @_action.index

    console.log "Updated at: " + new Date()

  pullweapon: ->
    # console.log "Pullweapon"
    @_parts = 1
    @_doneParts++
    @finishPart()

  downweapon: ->
    # console.log "Downeweapon"
    @_parts = 1
    @_doneParts++
    @finishPart()

  shoot: ->
    # console.log "Shoot"
    @_parts = @_targets.length
    for target, index in @_targets
      ability = @_game.add.sprite(@_baseUnit._posX, @_baseUnit._posY, @_abilityData.name)
      ability.animations.add("shooting_" + index)
      ability.animations.play("shooting_" + index, 20, true)
      tween = @_game.add.tween(ability).to({x: target.gameTeam.getCoordinates().x, y: target.gameTeam.getCoordinates().y }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
      tween.index = index
      tween.onComplete.add (tween)->
        @hit({x: tween.x, y: tween.y})
        tween.kill()
      , @

  hit: (target)->
    # console.log "Hit"
    explode = @_game.add.sprite(target.x - (Math.abs(@_baseUnit._unit.width)), target.y - (@_baseUnit._unit.height), "explode")
    explode.animations.add "exploding"
    explode.animations.play "exploding", 10, false
    explode.events.onAnimationComplete.add (explode)->
      @_doneParts++
      explode.kill()
      @finishPart()
    , @

  buff: ->
    # console.log "Buff"
    @_parts = @_targets.length
    for target, index in @_targets
      ability = @_game.add.sprite(target.gameTeam.getCoordinates().x, target.gameTeam.getCoordinates().y, @_abilityData.name)
      ability.animations.add("shooting_" + index)
      ability.animations.play("shooting_" + index, 20, true)
      ability.onAnimationComplete.add (ability)->
        @_doneParts++
        explode.kill()
        @finishPart()
      , @

