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
      y: 768

    @game = new Phaser.Game(@canvasSize.x, @canvasSize.y, Phaser.CANVAS, "base-game",
      preload: @preload.bind(@)
      create: @create.bind(@)
      update: @update.bind(@)
    )

    @initColorHighlight()


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

    @game.load.atlasJSONHash("heal_commander", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("trueDamage_commander", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("hitBuff_commander", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("attack_commander", "/sprites/shot.png", "/sprites/shot.json");

    @game.load.atlasJSONHash("attack_specialist", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("heal_specialist", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("burstShot_specialist", "/sprites/shot.png", "/sprites/shot.json");
    @game.load.atlasJSONHash("attackAll_specialist", "/sprites/shot.png", "/sprites/shot.json");

    @game.load.image "buff", "/sprites/buff.png"

    @game.load.image "dot", "/sprites/fire.png"
    @game.load.image "hot", "/sprites/pot.png"
    @game.load.image "crit", "/sprites/crit.png"
    @game.load.image "hit", "/sprites/hit.png"
    @game.load.image "armor", "/sprites/armor.png"
    @game.load.image "dmg", "/sprites/poison.png"

    @game.load.image "ball", "/sprites/aqua_ball.png"
    @game.load.image "healthbar", "/sprites/healthbar.png"

    @game.load.spritesheet "explode", "/sprites/explode1.png", 128, 128, 16

  create: ->
    background =  @game.add.sprite(0, 0, 'background')
    @createTeam(@playerOne)
    @createTeam(@playerTwo)

    @initObserver()
    @createKeyboardListener()



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
    xPos = if isPlayerOne then @canvasSize.x * 0.25 else @canvasSize.x * 0.85
    for member, i in player.team
      @[member._id].addSprite(xPos - (i * @canvasSize.x * 0.05), (@canvasSize.y * 0.1 * i) + @canvasSize.y * 0.55)

      if isPlayerOne
        @[member._id].initLife(xPos - (i * @canvasSize.x * 0.05) + @_playerOneSpriteOffset, (@canvasSize.y * 0.1 * i) + @canvasSize.y * 0.55, member.life)
      else
        @[member._id].initLife(xPos - (i * @canvasSize.x * 0.05), (@canvasSize.y * 0.1 * i) + @canvasSize.y * 0.55, member.life)
      @[member._id].addAnimation()
      @[member._id].setCoordinates(xPos - (i * @canvasSize.x * 0.05), (@canvasSize.y * 0.1 * i) + @canvasSize.y * 0.55)
      @[member._id]._unit.anchor.setTo(0.9, 0) unless isPlayerOne
      @[member._id]._unit.scale.x *= -1 unless isPlayerOne
      object = {}
      object[member._id] = @[member._id]
      @allUnits.push object if isPlayerOne

    heroXPos = if isPlayerOne then @canvasSize.x *- 0.175 else 0

    @[player.hero._id].addSprite(xPos + heroXPos, @canvasSize.y * 0.7)
    @[player.hero._id].addAnimation()
    @[player.hero._id].setCoordinates(xPos + heroXPos, @canvasSize.y * 0.7)
    if isPlayerOne
      @[player.hero._id].initLife(xPos + heroXPos + @_playerOneSpriteOffset, @canvasSize.y * 0.7, player.hero.life)
    else
      @[player.hero._id].initLife(xPos + heroXPos, @canvasSize.y * 0.7, player.hero.life)
    @[player.hero._id]._unit.anchor.setTo(0.9, 0) unless isPlayerOne
    @[player.hero._id]._unit.scale.x *= -1 unless isPlayerOne
