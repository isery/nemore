class @BaseGame
  @_instance: undefined

  constructor: (data) ->
    BaseGame._instance = @
    @_playerOneSpriteOffset = 50;
    @_id = data.game._id
    @allUnits = []
    @playerOne =
      hero: data.heroOne
      team: data.gameTeamOne

    @playerTwo =
      hero: data.heroTwo
      team: data.gameTeamTwo

    @actions = data.actions

    @canvasSize =
      x: 1024
      y: 724

    @game = new Phaser.Game(@canvasSize.x, @canvasSize.y, Phaser.CANVAS, "base-game",
      preload: @preload.bind(@)
      create: @create.bind(@)
      update: @update.bind(@)
    )


  initColorHighlight: ->
    allKeys = Key.find()
    @keys = []
    for i of allKeys
      @keys.push allKeys[i].name.toUpperCase()
    @keyListener = []
    @timer = 60
    @durationOfColorHighlight = 700
    @frameRate = 60
    @colorHighlight = new ColorHighlight({game:@game, allUnits:@allUnits, baseGame: @})


  update: ->
    @timer--
    if @timer <= 0
      @colorHighlight.create()
      that = @
      removeColorHighlight = setTimeout(->
        that.colorHighlight.destroy()
        that.colorHighlight.setState(false)
      , that.durationOfColorHighlight)
      @timer = @frameRate
    for i of @keyListener
      if @keyListener[i].isDown
        if @colorHighlight.colorHighlightState
          colorId = Color.findOne({hex:@colorHighlight.activeColor})._id
          keyId = Key.findOne({inputkey:@keyListener[i].keyCode})._id
          colorKey = ColorKey.findOne({colorId:colorId,keyId:keyId})
          condition = colorKey.condition()
          conditionName = condition.name
          conditionId = condition._id
          unitId = @colorHighlight.activeUnitId
          gameTeamId = GameTeam.findOne({_id:unitId})._id
          @[gameTeamId]._conditions.add(conditionName)
          Meteor.call "addCondition", @_id,unitId, {conditionId:conditionId,value: colorKey.value, duration: colorKey.duration}
          clearTimeout removeColorHighlight
          @colorHighlight.setState(false)
          @timer = @frameRate
          @colorHighlight.animateSuccess()



  preload: ->
    # Prepreload stuff

  startLoadingAssets: ->
    @preloadTeam(@playerOne)
    @preloadTeam(@playerTwo)

    @game.load.image "background", "/sprites/background.png"
    @game.load.atlasJSONHash("defenseBuff_drone", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("defenseAll_drone", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("damageBuff_drone", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("damageAll_drone", "/sprites/shot.png", "/sprites/shot.json");

    @game.load.atlasJSONHash("attack_sniper", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("steadyShot_sniper", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("executeShot_sniper", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("critBuff_sniper", "/sprites/shot.png", "/sprites/shot.json");

    @game.load.atlasJSONHash("trueDamage_commander", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("hitBuff_commander", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("attack_commander", "/sprites/shot.png", "/sprites/shot.json");

    @game.load.atlasJSONHash("attack_specialist", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("burstShot_specialist", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("attackAll_specialist", "/sprites/shot.png", "/sprites/shot.json");

    @game.load.image "crit", "/sprites/crit.png"
    @game.load.image "hit", "/sprites/hit.png"
    @game.load.image "armor", "/sprites/armor.png"
    @game.load.image "dmg", "/sprites/dmg.png"

    @game.load.image "ball", "/sprites/aqua_ball.png"
    @game.load.image "smoke", "/sprites/smoke.png"
    @game.load.image "spark", "/sprites/spark.png"

    @game.load.spritesheet "heal", "/sprites/heal.png", 128, 128, 28
    @game.load.spritesheet "buff", "/sprites/buff.png", 128, 128, 28
    @game.load.spritesheet "explode", "/sprites/explode1.png", 128, 128, 16

    @game.load.image "sound", "/sprites/sound.png"
    @game.load.image "mute", "/sprites/mute.png"

    @game.load.audio("background", ['/sounds/bodenstaendig_2000_in_rock_4bit.mp3', '/sounds/bodenstaendig_2000_in_rock_4bit.ogg'])
    @game.load.audio("shot", '/sounds/shot.wav')
    @game.load.audio("miss", '/sounds/miss.ogg')
    @game.load.audio("hit", '/sounds/hit.wav')
    @game.load.audio("death", '/sounds/death.wav')
    @game.load.audio("heal", '/sounds/buff.wav')
    @game.load.audio("buff", '/sounds/buff.wav')

    @game.load.start()

  create: ->
    @game.load.onLoadStart.add(@loadStart, @);
    @game.load.onFileComplete.add(@fileComplete, @);
    @game.load.onLoadComplete.add(@loadComplete, @);

    @text = @game.add.text(@canvasSize.x * 0.40, @canvasSize.y * 0.40, 'Loading...', { fill: '#ffffff' });

    @startLoadingAssets()

  loadStart: ->
    color = 0xffffff
    @_progressBackgroundBig
    @_progressBackgroundBig = @game.add.graphics(0, 0)
    @_progressBackgroundBig.beginFill(color)
    @_progressBackgroundBig.lineStyle(22, color, 1)
    @_progressBackgroundBig.moveTo(@canvasSize.x * 0.35 - 2, @canvasSize.y * 0.45)
    @_progressBackgroundBig.lineTo(@canvasSize.x * 0.35 + 2 + 100 * @canvasSize.x * 0.003, @canvasSize.y * 0.45)
    @_progressBackgroundBig.endFill()


    color = 0x000000
    @_progressBackgroundSmall
    @_progressBackgroundSmall = @game.add.graphics(0, 0)
    @_progressBackgroundSmall.beginFill(color)
    @_progressBackgroundSmall.lineStyle(20, color, 1)
    @_progressBackgroundSmall.moveTo(@canvasSize.x * 0.35, @canvasSize.y * 0.45)
    @_progressBackgroundSmall.lineTo(@canvasSize.x * 0.35 + 100 * @canvasSize.x * 0.003, @canvasSize.y * 0.45)
    @_progressBackgroundSmall.endFill()

  fileComplete: (progress, cacheKey, success, totalLoaded, totalFiles)->
    @text.setText("Loading: " + progress + "%");

    color = 0xffffff

    @_progressBar.destroy() if @_progressBar
    @_progressBar = @game.add.graphics(0, 0)
    @_progressBar.beginFill(color)
    @_progressBar.lineStyle(20, color, 1)
    @_progressBar.moveTo(@canvasSize.x * 0.35, @canvasSize.y * 0.45)
    @_progressBar.lineTo(@canvasSize.x * 0.35 + progress * @canvasSize.x * 0.003, @canvasSize.y * 0.45)
    @_progressBar.endFill()

  loadComplete: ->
    background =  @game.add.sprite(0, 0, 'background')
    @initAudio()
    @createTeam(@playerOne)
    @createTeam(@playerTwo)
    @createKeyboardListener()

    @initSmoke(@game.world.centerX + 200, 380, 0.3, 0.5, -50, -20)
    @initSmoke(@game.world.centerX + 525, 500, 0.3, 0.5, -30, -10)

    @initSparks()
    @initColorHighlight()

    @initObserver()


  initAudio: ->
    @sound_background = @game.add.audio('background')
    @sound_background.play('', 0.2, true)

    @sound_shot = @game.add.audio('shot')
    @sound_miss = @game.add.audio('miss')
    @sound_hit = @game.add.audio('hit')
    @sound_death = @game.add.audio('death')
    @sound_heal = @game.add.audio('heal')
    @sound_buff = @game.add.audio('buff')

    @addSoundButton()

  addSoundButton: ->
    @soundButton = @game.add.button(@canvasSize.x * 0.9, @canvasSize.y * 0.05, 'sound', @click, @, 0, 1, 2)
    @soundButton.scale.set(0.4, 0.4)

  addMuteButton: ->
    @soundButton = @game.add.button(@canvasSize.x * 0.9, @canvasSize.y * 0.05, 'mute', @click, @, 0, 1, 2)
    @soundButton.scale.set(0.4, 0.4)

  click: ->
    @soundButton.kill()
    volume = @game.sound.volume
    if volume
      @game.sound.volume = 0
      @addMuteButton()
    else
      @game.sound.volume = 1
      @addSoundButton()


  initSmoke: (posX, posY, scaleFrom, scaleTo, xSpeedFrom, xSpeedTo) ->
    emitter = @game.add.emitter(posX, posY, 100)
    emitter.makeParticles('smoke')
    emitter.setXSpeed(xSpeedFrom, xSpeedTo)
    emitter.setYSpeed(0, 0)
    emitter.setRotation(0,40)
    emitter.setAlpha(0.8, 0.2, 3000)
    emitter.setScale(scaleFrom, scaleTo, scaleFrom, scaleTo, 6000, Phaser.Easing.Quintic.Out)
    emitter.gravity = -100
    emitter.start(false, 5000, 300)

  initSparks: ->
    emitter = @game.add.emitter(360, 385, 1000)
    emitter.makeParticles('spark')
    emitter.setYSpeed(-100, -150)
    emitter.setAlpha(1.0, 0.0, 1700, Phaser.Easing.Quintic.Out)
    emitter.setScale(0.1, 0.05, 0.2, 0.1, 1000, Phaser.Easing.Quintic.Out)
    setInterval =>
      tmp = setInterval =>
        emitter.start(true, 1000, null, @randomNumber(20, 40))
      , @randomNumber(200, 400)
      setTimeout =>
        clearInterval(tmp)
      , @randomNumber(1400, 1700)
    , @randomNumber(2000, 5000)

  randomNumber: (min, max) ->
    Math.floor(Math.random() * (max - min + 1) + min)

  initObserver: ->
    that = @
    Actions.find({gameId: @_id}).observe({
      added: (action) ->
        player = GamePlayers.findOne({gameId: action.gameId, userId: Meteor.userId()})
        if action.index > player.lastIndex
          GamePlayers.update
            _id: player._id
          ,
            $set:
              state: "animating"

          player2 = GamePlayers.findOne({gameId: action.gameId, player: '2'})
          player2User = Meteor.users.findOne({_id: player2.userId})
          if window.Ki.indexOf(player2User.username) >= 0
            GamePlayers.update
              _id: player2._id
            ,
              $set:
                state: 'waiting'
                lastIndex: action.index

          new BaseAbility({action: action, baseGame: that}).play()
          BaseCondition.update({action: action, baseGame: that})
    })

  createKeyboardListener: ->
    for i of @keys
      keyLetter = @keys[i]
      @keyListener.push @game.input.keyboard.addKey(Phaser.Keyboard[keyLetter])

  preloadTeam: (player) ->
    for member in player.team
      name = member.unit().name
      unitId = member.unit()._id
      @[member._id] = BaseUnit.create(name, unitId, @game)

    name = player.hero.unit().name
    unitId = player.hero.unit()._id
    @[player.hero._id] = BaseUnit.create(name, unitId, @game)

  createTeam: (player) ->
    isPlayerOne = (Meteor.userId() == player.hero.userId)

    p1Positions = [
        x: @canvasSize.x * 0.20
        y: @canvasSize.y * 0.50
      ,
        x: @canvasSize.x * 0.15
        y: @canvasSize.y * 0.60
      ,
        x: @canvasSize.x * 0.20
        y: @canvasSize.y * 0.70
      ,
        x: @canvasSize.x * 0.15
        y: @canvasSize.y * 0.80
    ]

    p1HeroPosition =
      x: @canvasSize.x * 0.05
      y: @canvasSize.y * 0.65

    p2Positions = [
        x: @canvasSize.x * 0.75
        y: @canvasSize.y * 0.50
      ,
        x: @canvasSize.x * 0.70
        y: @canvasSize.y * 0.60
      ,
        x: @canvasSize.x * 0.75
        y: @canvasSize.y * 0.70
      ,
        x: @canvasSize.x * 0.70
        y: @canvasSize.y * 0.80
    ]

    p2HeroPosition =
      x: @canvasSize.x * 0.85
      y: @canvasSize.y * 0.65

    pArr = if isPlayerOne then p1Positions else p2Positions
    # init units
    for member, i in player.team
      @[member._id].addSprite(pArr[i].x, pArr[i].y)
      if isPlayerOne
        @[member._id].initLife(pArr[i].x + @_playerOneSpriteOffset, pArr[i].y, member.unit().life * 0.75)
        @[member._id].setCoordinates(pArr[i].x + @_playerOneSpriteOffset, pArr[i].y)
      else
        @[member._id].initLife(pArr[i].x, pArr[i].y, member.unit().life * 0.75)
        @[member._id].setCoordinates(pArr[i].x, pArr[i].y)

      @[member._id].setLifeLine(member.life)
      @[member._id].addAnimation()

      # Rotate enemies
      @[member._id]._unit.anchor.setTo(0.9, 0) unless isPlayerOne
      @[member._id]._unit.scale.x *= -1 unless isPlayerOne

      # Colorhighlight units init
      object = {}
      object[member._id] = @[member._id]
      @allUnits.push object if isPlayerOne

    # init Hero
    heroPos = if isPlayerOne then p1HeroPosition else p2HeroPosition

    @[player.hero._id].addSprite(heroPos.x, heroPos.y)
    @[player.hero._id].addAnimation()
    if isPlayerOne
      @[player.hero._id].initLife(heroPos.x + @_playerOneSpriteOffset, heroPos.y, player.hero.unit().life)
      @[player.hero._id].setCoordinates(heroPos.x + @_playerOneSpriteOffset, heroPos.y)
    else
      @[player.hero._id].initLife(heroPos.x, heroPos.y, player.hero.unit().life)
      @[player.hero._id].setCoordinates(heroPos.x, heroPos.y)

    @[player.hero._id].setLifeLine(player.hero.life)

    # Rotate enemy hero
    @[player.hero._id]._unit.anchor.setTo(0.9, 0) unless isPlayerOne
    @[player.hero._id]._unit.scale.x *= -1 unless isPlayerOne
