class @BaseGame
  constructor: (data) ->
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
      # update: @update.bind(@)
    )

  preload: ->
    @preloadTeam(@playerOne)
    @preloadTeam(@playerTwo)

    @game.load.atlasJSONHash("autoattack_commander", "/sprites/autoattack_commander.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("autoattack_sniper", "/sprites/autoattack_sniper.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("autoattack_specialist", "/sprites/autoattack_specialist.png", "/sprites/autoattack.json");
    @game.load.atlasJSONHash("autoattack_drone", "/sprites/autoattack_drone.png", "/sprites/autoattack.json");

    @game.load.image "ball", "/sprites/aqua_ball.png"
    @game.load.spritesheet "mummy", "/sprites/metalslug_monster39x40.png", 39, 40,10
    @game.load.image "healthbar", "/sprites/healthbar.png"
    @game.load.spritesheet "explode", "/sprites/explode1.png", 128, 128, 16

  create: ->
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
          #that[action.from][action.name].startAnimation(that[action.to].getCoordinates(), actionArr)
          new BaseAbility({action: action, baseGame: that}).play()
    })
  # update: ->
    # # @game.physics.collide @balls, @mummy2, collisionHandler, null, this
    # if @game.input.keyboard.isDown(Phaser.Keyboard.ENTER)
    #   #@[@playerOne.hero._id].activateAbility(@[@playerTwo.hero._id].getCoordinates())
    #   @[@actions[0].from].activateAbility(@[@actions[0].to].getCoordinates(), @actions[0].abilityId)

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
      @[member._id].addSprite(xPos, 50 * i)
      @[member._id].addAnimation("standing", 30, true)
      @[member._id].setCoordinates(xPos, 50 * i)
      # @[member._id].initAbilities()

    heroXPos = if isPlayerOne then -100 else 100

    @[player.hero._id].addSprite(xPos + heroXPos, 100)
    @[player.hero._id].addAnimation("standing", 30, true)
    @[player.hero._id].setCoordinates(xPos + heroXPos, 100)
    # @[player.hero._id].initAbilities()


  # collisionHandler = (mummy, ball) ->
  #   @liveOfMummy2 -= 25
  #   #if you dont do it, the mummy inherates the velocity of the ball
  #   ball.velocity.x = 0
  #   mummy.velocity.x = 0
  #   if @liveOfMummy2 <= 0
  #     #here issue cant get the exact position -> i dont know why width * 2
  #     explode = @game.add.sprite(mummy.x - (Math.abs(mummy.width) * 2), mummy.y - (mummy.height), "explode")
  #     explode.animations.add "exploding"

  #     #name, framerate, loop
  #     explode.animations.play "exploding", 10, false
  #     explode.body.setSize 0, 0, 0, 0
  #     explode.events.onAnimationComplete.add completedAnimation, this
  #     mummy.kill()

  #   #remove the ball
  #   ball.kill()
  # completedDroneAnimation = () ->
  #   ball = @balls.getFirstExists(false)
  #   if ball
  #     #start of ball
  #     ball.reset @drone.x + 6, @drone.y + 8
  #     #speed and direction
  #     ball.velocity.x = 600

  # completedAnimation = (explode, animation) ->
  #   explode.reset()





