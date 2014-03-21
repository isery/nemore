class @ColorHighlight
  constructor: (data) ->
    @spriteSize = 64
    @x = 100
    @game = data.game
    @y = 100
    @backgroundColor = "#124184"
    @randomColors = ["#ff0000","#00ff00","#ffff00"]
    @allSprites = data.allSprites
    @colorHighligtState = false
    @activeSprite = null
    @activeColor = null
    @probability = 66
    @successAnimationDuration = 500
    @successBlinkingDuration = 80
    @currentColorHighlight = null
    @colorHighlightState = null


  create: ->
    if @probabilityOfOccurance()
      randomSpriteIndex = @createRandomNumber(0, @allSprites.length)
      randomColorIndex = @createRandomNumber(0, @randomColors.length)
      @activeSprite = @allSprites[randomSpriteIndex]
      @activeColor = @randomColors[randomColorIndex]
      x = @activeSprite.position.x - @spriteSize / 2
      y = @activeSprite.position.y - @spriteSize / 2
      bmd = @createBitMap(@spriteSize, @activeColor, @backgroundColor)
      @currentColorHighlight = @game.add.sprite(x, y, bmd)
      @activeSprite.bringToTop()
      @setState(true)

  setState: (state) ->
    @colorHighlightState = state

  destroy: ->
    currentColorHighlight.kill()  if currentColorHighlight?

  animateSuccess: ->
    blinking = setInterval(->
      @currentColorHighlight.visible = not @currentColorHighlight.visible
    , @successBlinkingDuration)
    setTimeout (->
      clearInterval blinking
      @currentColorHighlight.kill()
    ), @successAnimationDuration

  probabilityOfOccurance: ->
    randomNumber = @createRandomNumber(0, 100)
    if randomNumber <= @probability
      true
    else
      false

  createBitMap: (spriteSize, color, backgroundColor) ->
    bmd = @game.add.bitmapData(@spriteSize * 2, @spriteSize * 2)
    bmd.ctx.beginPath()
    grd = bmd.ctx.createRadialGradient(@spriteSize, @spriteSize, 0, @spriteSize, @spriteSize, @spriteSize)
    grd.addColorStop 0, color
    grd.addColorStop 1, backgroundColor
    bmd.ctx.rect 0, 0, @spriteSize * 2, @spriteSize * 2
    bmd.ctx.fillStyle = grd
    bmd.ctx.fill()
    bmd

  createRandomNumber: (from, to) ->
    number = Math.floor((Math.random() * to) + from)
    number
