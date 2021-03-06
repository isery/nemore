class @ColorHighlight
  constructor: (data) ->
    @spriteSize = 64
    @game = data.game
    @baseGame = data.baseGame
    @backgroundColor = "#FFFFFFFF"
    @randomColors = []
    colors = Color.find()
    for i of colors
      @randomColors.push colors[i].hex
    @allSprites = data.allUnits
    @colorHighligtState = false
    @activeSprite = null
    @activeColor = null
    @probability = 66
    @successAnimationDuration = 500
    @successBlinkingDuration = 80
    @currentColorHighlight = null
    @activeUnitId = null
    @colorHighlightState = null

  firstElement: (object)->
    for i of object
      return object[i]

  create: ->
    if @probabilityOfOccurance()
      randomSpriteIndex = @createRandomNumber(0, @allSprites.length)
      randomColorIndex = @createRandomNumber(0, @randomColors.length)
      @activeUnitId = Object.keys(@allSprites[randomSpriteIndex])[0]
      @activeUnit =  @firstElement(@allSprites[randomSpriteIndex])
      @activeColor = @randomColors[randomColorIndex]
      x = @activeUnit._posX - @spriteSize / 2
      y = @activeUnit._posY + 15 - @spriteSize / 2
      bmd = @createBitMap(@spriteSize, @activeColor, @backgroundColor)
      @currentColorHighlight = @baseGame[@activeUnitId]._group.create x, y, bmd
      @baseGame[@activeUnitId].bringToTop()
      @setState(true)

  setState:  (state) ->
    @colorHighlightState = state

  destroy: ->
    @currentColorHighlight.kill()  if @currentColorHighlight?

  animateSuccess: ->
    that = @
    blinking = setInterval(->
      that.currentColorHighlight.visible = not that.currentColorHighlight.visible
    , that.successBlinkingDuration)
    setTimeout (->
      clearInterval blinking
      that.currentColorHighlight.kill()
    ), that.successAnimationDuration

  probabilityOfOccurance: ->
    randomNumber = @createRandomNumber(0, 100)
    if randomNumber <= @probability
      true
    else
      false

  createBitMap: (spriteSize, color, backgroundColor) ->
    bmd = @game.add.bitmapData(@spriteSize * 2, @spriteSize * 2)
    bmd.context.beginPath()
    grd = bmd.context.createRadialGradient(@spriteSize, @spriteSize, 0, @spriteSize, @spriteSize, @spriteSize)
    grd.addColorStop 0, color
    grd.addColorStop 1, 'rgba(0,0,0,0)'
    bmd.context.rect 0, 0, @spriteSize * 2, @spriteSize * 2
    bmd.context.fillStyle = grd
    bmd.context.fill()
    bmd

  createRandomNumber: (from, to) ->
    number = Math.floor((Math.random() * to) + from)
    number
