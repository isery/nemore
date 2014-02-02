class @BaseAbility
  constructor: (data) ->
    @_baseUnit = data.baseUnit
    @_game = data.baseUnit._game
    @_abilityData = data.ability


  startAnimation: (target, animationArr) ->
    @_animationArr = animationArr
    @_target = target
    @activate()

  activate: () ->
    @_action = @_animationArr[0]
    @_ability = @_game.add.sprite(@_baseUnit._posX, @_baseUnit._posY, @_abilityData.name)
    @_ability.animations.add "shooting"
    @_ability.animations.play "shooting", 20, true
    tween = @_game.add.tween(@_ability).to({x: @_target.x, y: @_target.y }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
    tween.onComplete.add (tween)->
      @tweenComplete()
      tween.kill()
    , @

  tweenComplete: ()->
    explode = @_game.add.sprite(@_target.x - (Math.abs(@_baseUnit._unit.width)), @_target.y - (@_baseUnit._unit.height), "explode")
    explode.animations.add "exploding"
    explode.animations.play "exploding", 10, false
    explode.events.onAnimationComplete.add @completedExplode , @

  completedExplode: (explode, animation)->
    explode.kill()
    console.log "FINISH"
    @_animationArr.shift()
    if @_animationArr.length > 0
      console.log "> 0"
      @activate()
    else
      @finishAction()

  finishAction: ->
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




