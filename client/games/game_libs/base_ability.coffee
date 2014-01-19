class @BaseAbility
  constructor: (data) ->
    @_baseUnit = data.baseUnit
    @_game = data.baseUnit._game
    @_abilityData = data.ability

  activate: (target) ->
    @_ability = @_game.add.sprite(@_baseUnit._posX, @_baseUnit._posY, @_abilityData.name)
    @_ability.animations.add "shooting"
    @_ability.animations.play "shooting", 20, true
    tween = @_game.add.tween(@_ability).to({x: target.x, y: target.y }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
    tween.onComplete.add (tween)->
      @tweenComplete(target)
      tween.kill()
    , @

  tweenComplete: (target)->
    explode = @_game.add.sprite(target.x - (Math.abs(@_baseUnit._unit.width) * 2), target.y - (@_baseUnit._unit.height), "explode")
    explode.animations.add "exploding"
    explode.animations.play "exploding", 10, false
    explode.events.onAnimationComplete.add @completedExplode , @

  completedExplode: (explode, animation)->
    explode.kill()
