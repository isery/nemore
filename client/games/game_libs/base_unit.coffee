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

  initAbilities: ->
    abilities = SpecialAbilities.find({unitId: @_unitId}).fetch()
    for ability in abilities
      @[ability.name] = new BaseAbility({baseUnit: @, ability: ability})

  addSprite: (x,y) ->
    @_unit = @_game.add.sprite(x, y, @_name, "a.png")

  initLife: (x, y, life)->
    @_maxLife = life
    color = 0x000000
    @_lifeBackground = @_game.add.graphics(0,0)
    @_lifeBackground.beginFill(color)
    @_lifeBackground.lineStyle(12, color, 1)
    @_lifeBackground.moveTo(x + 9, y - 10)
    @_lifeBackground.lineTo(x + 51, y - 10)
    @_lifeBackground.endFill()

    @setLifeLine(x,y, life)

  setLifeLine: (x, y, life) ->
    percent = life/@_maxLife
    @_unitLife.destroy() if @_unitLife

    if life >= 700
      color = 0x39bd22
    else if life >= 400
      color = 0xffbb00
    else if life >= 100
      color = 0xff0011

    unless life <= 0
      @_unitLife = @_game.add.graphics(0, 0)
      @_unitLife.beginFill(color)
      @_unitLife.lineStyle(10, color, 1)
      @_unitLife.moveTo(x + 10, y - 10)
      @_unitLife.lineTo(x + (50 * percent), y - 10)
      @_unitLife.endFill()

  addAnimation: (name, frames, isLoop) ->
    @_unit.animations.add "idle"
    @_unit.animations.add("pullweapon", ["a.png", "b.png", "c.png"], 50, false, false)
    @_unit.animations.add("downweapon", ["c.png", "b.png", "a.png"], 50, false, false)

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
