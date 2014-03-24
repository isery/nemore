class @BaseUnit
  constructor: (data)->
    @_unitId = data.unitId
    @_game = data.game
    @_name = data.name
    @_image = data.image
    @_json = data.json
    @_conditions = new BaseCondition({game: @_game, baseUnit: @})
    @_group = @_game.add.group()
    @initSprites()

  initSprites: ->
    @_game.load.atlas(@_name, @_image, @_json)

  initAbilities: ->
    abilities = SpecialAbilities.find({unitId: @_unitId}).fetch()
    for ability in abilities
      @[ability.name] = new BaseAbility({baseUnit: @, ability: ability})

  addSprite: (x,y) ->
     @_unit = @_group.create x, y, @_name, "a.png"

  initLife: (x, y, life)->
    @_maxLife = life
    color = 0x000000
    @_lifeBackground = @_game.add.graphics(0,0)
    @_lifeBackground.beginFill(color)
    @_lifeBackground.lineStyle(12, color, 1)
    @_lifeBackground.moveTo(x + 9, y - 10)
    @_lifeBackground.lineTo(x + 51, y - 10)
    @_lifeBackground.endFill()
    @_group.add(@_lifeBackground)

    @setLifeLine(x,y, life)

  setLifeLine: (x, y, life) ->
    percent = life/@_maxLife
    if @_unitLife
      @_unitLife.destroy()

    if percent >= 0.80
      color = 0x1ADE00
    else if percent >= 0.60
      color = 0x73DE00
    else if percent >= 0.40
      color = 0xFFE100
    else if percent >= 0.20
      color = 0xFF7700
    else if percent >= 0
      color = 0xFF0000

    if life <= 0
      @_lifeBackground.destroy()
    unless life <= 0
      @_unitLife = @_game.add.graphics(0, 0)
      @_unitLife.beginFill(color)
      @_unitLife.lineStyle(10, color, 1)
      @_unitLife.moveTo(x + 10, y - 10)
      @_unitLife.lineTo(x + (50 * percent), y - 10)
      @_unitLife.endFill()
      @_group.add(@_unitLife)

  setCoordinates: (coordsX, coordsY) ->
    @_posX = coordsX
    @_posY = coordsY

  getCoordinates: ->
    {x: @_posX, y: @_posY}

  bringToTop: ->
    @_unit.bringToTop()
    @_group.bringToTop(@_lifeBackground)
    @_group.bringToTop(@_unitLife)

  @create = (name, unitId ,game)->
    switch name
      when "Commander" then new Commander({game: game, unitId: unitId})
      when "Sniper" then new Sniper({game: game, unitId: unitId})
      when "Specialist" then new Specialist({game: game, unitId: unitId})
      when "Drone" then new Drone({game: game, unitId: unitId})
