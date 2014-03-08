class @BaseGame
  @_instance: undefined

  constructor: (data) ->
    BaseGame._instance = @
    @_id = data.game._id
    @playerOne =
      hero: data.heroOne
      team: data.gameTeamOne

    @playerTwo =
      hero: data.heroTwo
      team: data.gameTeamTwo

    @actions = data.actions
    @game = new Phaser.Game(1024, 768, Phaser.AUTO, "base-game",
      preload: @preload.bind(@)
      create: @create.bind(@)
    )


  preload: ->
    @preloadTeam(@playerOne)
    @preloadTeam(@playerTwo)

    @game.load.atlasJSONHash("defenseBuff_drone", "/sprites/autoattack_drone.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("defenseAll_drone", "/sprites/autoattack_drone.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("damageBuff_drone", "/sprites/autoattack_drone.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("damageAll_drone", "/sprites/autoattack_drone.png", "/sprites/autoattack.json");

    @game.load.atlasJSONHash("attack_sniper", "/sprites/autoattack_sniper.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("steadyShot_sniper", "/sprites/autoattack_sniper.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("executeShot_sniper", "/sprites/autoattack_sniper.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("critBuff_sniper", "/sprites/autoattack_sniper.png", "/sprites/autoattack.json");

    @game.load.atlasJSONHash("heal_commander", "/sprites/autoattack_commander.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("hotBuff_commander", "/sprites/autoattack_commander.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("hitBuff_commander", "/sprites/autoattack_commander.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("attack_commander", "/sprites/autoattack_commander.png", "/sprites/autoattack.json");

    @game.load.atlasJSONHash("attack_specialist", "/sprites/autoattack_specialist.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("heal_specialist", "/sprites/autoattack_specialist.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("burstShot_specialist", "/sprites/autoattack_specialist.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("burnAll_specialist", "/sprites/autoattack_specialist.png", "/sprites/autoattack.json");

    @game.load.image "buff", "/sprites/buff.png"

    @game.load.image "dot", "/sprites/fire.png"
    @game.load.image "hot", "/sprites/pot.png"
    @game.load.image "crit", "/sprites/crit.png"
    @game.load.image "hit", "/sprites/hit.png"
    @game.load.image "armor", "/sprites/armor.png"
    @game.load.image "dmg", "/sprites/poison.png"

    @game.load.image "ball", "/sprites/aqua_ball.png"
    @game.load.spritesheet "mummy", "/sprites/metalslug_monster39x40.png", 39, 40,10
    @game.load.image "healthbar", "/sprites/healthbar.png"
    @game.load.spritesheet "explode", "/sprites/explode1.png", 128, 128, 16

  create: ->
    @game.stage.backgroundColor = '#124184'
    @createTeam(@playerOne)
    @createTeam(@playerTwo)

    @initObserver()

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
    xPos = if isPlayerOne then 200 else 650
    for member, i in player.team
      @[member._id].addSprite(xPos, (100 * i) + 100)
      @[member._id].initLife(xPos, (100 * i) + 100, member.life)
      @[member._id].addAnimation("standing", 30, true)
      @[member._id].setCoordinates(xPos, (100 * i) + 100)
      @[member._id]._unit.anchor.setTo(0.9, 0) unless isPlayerOne
      @[member._id]._unit.scale.x *= -1 unless isPlayerOne

    heroXPos = if isPlayerOne then -100 else 100

    @[player.hero._id].addSprite(xPos + heroXPos, 200)
    @[player.hero._id].addAnimation("standing", 30, true)
    @[player.hero._id].setCoordinates(xPos + heroXPos, 200)
    @[player.hero._id].initLife(xPos + heroXPos, 200, player.hero.life)
    @[player.hero._id]._unit.anchor.setTo(0.9, 0) unless isPlayerOne
    @[player.hero._id]._unit.scale.x *= -1 unless isPlayerOne
