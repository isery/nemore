class @BaseGame
  constructor: (data) ->
    @playerOne =
      hero: data.heroOne
      team: data.gameTeamOne

    @playerTwo =
      hero: data.heroTwo
      team: data.gameTeamTwo

    @game = new Phaser.Game(1024, 768, Phaser.AUTO, "base-game",
      preload: @preload.bind(@)
      create: @create.bind(@)
      update: @update.bind(@)
    )

  preload: ->
    @preloadTeam(@playerOne)
    @preloadTeam(@playerTwo)

    @game.load.spritesheet "mummy", "/sprites/metalslug_monster39x40.png", 39, 40,10
    @game.load.image "ball", "/sprites/aqua_ball.png"
    @game.load.image "healthbar", "/sprites/healthbar.png"
    @game.load.spritesheet "explode", "/sprites/explode1.png", 128, 128, 16

  create: ->
    @createTeam(@playerOne)
    @createTeam(@playerTwo)



  update: ->
    # @game.physics.collide @balls, @mummy2, collisionHandler, null, this
    if @game.input.keyboard.isDown(Phaser.Keyboard.ENTER)
      @[@playerOne.hero._id].fireSpecialAbility(@[@playerTwo.hero._id].getCoordinates())
      @[@playerTwo.hero._id].fireSpecialAbility(@[@playerOne.hero._id].getCoordinates())

  preloadTeam: (player) ->
    for member in player.team
      name = member.unit().name
      @[member._id] = BaseUnit.create(name, @game)

    name = player.hero.unit().name
    @[player.hero._id] = BaseUnit.create(name, @game)

  createTeam: (player) ->
    isPlayerOne = (Meteor.userId() == player.hero.userId)
    xPos = if isPlayerOne then 200 else 650
    for member, i in player.team
      @[member._id].addSprite(xPos, 50 * i)
      @[member._id].addAnimation("standing", 30, true)
      @[member._id].initShots()
      @[member._id].setCoordinates(xPos, 50 * i)

    heroXPos = if isPlayerOne then -100 else 100

    @[player.hero._id].addSprite(xPos + heroXPos, 100)
    @[player.hero._id].addAnimation("standing", 30, true)
    @[player.hero._id].initShots()
    @[player.hero._id].setCoordinates(xPos + heroXPos, 100)


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





