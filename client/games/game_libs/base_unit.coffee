class @BaseUnit
  constructor: (data)->
    @_unitId = data.unitId
    @_game = data.game
    @_name = data.name
    @_image = data.image
    @_json = data.json
    @_shootTime = 0

    @initSprites()

  initSprites: ->
    @_game.load.atlas(@_name, @_image, @_json)
    #@_game.load.atlasJSONHash(@_name, @_image, @_json)

  initAbilities: ->
    abilities = SpecialAbilities.find({unit_id: @_unitId}).fetch()
    for ability in abilities
      @[ability.name] = new BaseAbility({baseUnit: @, ability: ability})

  addSprite: (x,y) ->
    # @_unit = @_game.add.sprite(x, y, @_name, "a.png")
    @_unit = @_game.add.sprite(x, y, @_name, "a.png")

  setLifeLine: (x, y, life) ->
    if life >= 700
      color = 0x39bd22
    else if life >= 400
      color = 0xffbb00
    else if life >= 100
      color = 0xff0011
    @_unitLife = @_game.add.graphics(0, 0)
    @_unitLife.beginFill(color)
    @_unitLife.lineStyle(10, color, 1)
    @_unitLife.moveTo(x + 10, y - 10)
    @_unitLife.lineTo(x + 50, y - 10)
    @_unitLife.endFill()

  addAnimation: (name, frames, isLoop) ->
    @_unit.animations.add "idle"
    @_unit.animations.add("pullweapon", ["a.png", "b.png", "c.png"], 50, false, false)
    @_unit.animations.add("downweapon", ["c.png", "b.png", "a.png"], 50, false, false)

    # @_unit.animations.add "downweapon", [2, 1, 0]

    #@_unit.animations.play "idle", 20, true

  # initShots: () ->
  #   @_shots = @_game.add.group(null, "shots")

  #   i = 0
  #   while i < 10
  #     shot = @_shots.create(0, 0, "shot")
  #     shot.name = "shot" + i
  #     shot.animations.add "shooting"
  #     shot.animations.play "shooting", 20, true
  #     shot.exists = false
  #     shot.visible = false
  #     shot.events.onOutOfBounds.add @resetShot, @
  #     i++

  # resetShot: (shot) ->
  #   shot.kill()

  # activateAbility: (target, abilityId)->
  #   if @_game.time.now > @_shootTime
  #     #For later use (after shooting animation shot goes blah)
  #     #@_unit.events.onAnimationComplete.add @test, @
  #     @_shootTime = @_game.time.now + 250
  #     shot = @_shots.getFirstExists(false)
  #     if shot
  #       shot.reset @_unit.x + 6, @_unit.y + 8
  #       # shot.velocity.x = directionVector.x
  #       # shot.velocity.y = directionVector.y

  #       tween = @_game.add.tween(shot).to({ x: target.x, y: target.y }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false);
  #       tween.onComplete.add (tween)->
  #         @tweenComplete(target)
  #         tween.kill()
  #       , @

  # tweenComplete: (target)->
  #   explode = @_game.add.sprite(target.x - (Math.abs(@_unit.width) * 2), target.y - (@_unit.height), "explode")
  #   explode.animations.add "exploding"
  #   explode.animations.play "exploding", 10, false
  #   explode.events.onAnimationComplete.add @completedExplode , @

  # completedExplode: (explode, animation)->
  #   explode.kill()

  setCoordinates: (coordsX, coordsY) ->
    @_posX = coordsX
    @_posY = coordsY

  getCoordinates: ->
    {x: @_posX, y: @_posY}

  @create = (name, unitId ,game)->
    switch name
      when "Commander" then new Commander({game: game, unitId: unitId})
      when "Sniper" then new Sniper({game: game, unitId: unitId})
      when "Specialist" then new Specialist({game: game, unitId: unitId})
      when "Drone" then new Drone({game: game, unitId: unitId})

