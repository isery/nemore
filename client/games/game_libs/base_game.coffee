class @BaseGame
  constructor: (data) ->
    @playerOne =
      hero: data.heroOne
      team: data.gameTeamOne

    @playerTwo =
      hero: data.heroTwo
      team: data.gameTeamTwo

    @game = new Phaser.Game(600, 500, Phaser.AUTO, "base-game",
      preload: @preload
      create: @create
      update: @update
    )

  preload: ->
    #name, path, x, y, count of images -> how to find x + y ? try and error? error when to big for frame
    @game.load.atlasJSONHash("commander", "/sprites/commander.png", "/sprites/commander.json");
    @game.load.atlasJSONHash("sniper", "/sprites/sniper.png", "/sprites/sniper.json");
    @game.load.atlasJSONHash("specialist", "/sprites/specialist.png", "/sprites/specialist.json");
    @game.load.atlasJSONHash("drone", "/sprites/drone.png", "/sprites/drone.json");
    @game.load.atlasJSONHash("shoot", "/sprites/shoot.png", "/sprites/shoot.json");
    @game.load.atlasJSONHash("shield", "/sprites/shield.png", "/sprites/shield.json");
    @game.load.spritesheet "mummy", "/sprites/metalslug_monster39x40.png", 39, 40,10
    @game.load.image "ball", "/sprites/aqua_ball.png"
    @game.load.image "healthbar", "/sprites/healthbar.png"
    @game.load.spritesheet "explode", "/sprites/explode1.png", 128, 128, 16
  create: ->
    @balls = @game.add.group(null, "balls")
    i = 0
    while i < 10
      b = @balls.create(0, 0, "shoot")
      b.name = "ball" + i
      b.animations.add "walking"
      b.animations.play "walking", 20, true
      b.exists = false
      b.visible = false
      b.events.onOutOfBounds.add resetball, this
      i++
    @sniper = @game.add.sprite(140, 275, "sniper");
    @sniper.scale.x = -1
    @specialist = @game.add.sprite(140, 200, "specialist");
    @specialist.scale.x = -1
    @drone = @game.add.sprite(100, 125, "drone");
    @shield = @game.add.sprite(140, 350, "shield");
    @shield.scale.x = -1
    @healthbar = @game.add.sprite(400, 20, "healthbar")
    @mummy2 = @game.add.sprite(500, 125, "mummy")
    @mummy2.animations.add "walking"
    @mummy2.animations.play "walking", 30, true
    @mummy2.body.setSize 20, 20, 0, 0
    @mummy2.scale.x = -1
    @ballTime = 0
    @liveOfMummy2 = 100;
    @elem = document.getElementById("live");
  update: ->
    @game.physics.collide @balls, @mummy2, collisionHandler, null, this
    if @game.input.keyboard.isDown(Phaser.Keyboard.ENTER)
      @fireball = fireball.bind(@)
      @fireball()
  collisionHandler = (mummy, ball) ->
    @liveOfMummy2 -= 25
    #if you dont do it, the mummy inherates the velocity of the ball
    ball.velocity.x = 0
    mummy.velocity.x = 0
    if @liveOfMummy2 <= 0
      #here issue cant get the exact position -> i dont know why width * 2
      explode = @game.add.sprite(mummy.x - (Math.abs(mummy.width) * 2), mummy.y - (mummy.height), "explode")
      explode.animations.add "exploding"

      #name, framerate, loop
      explode.animations.play "exploding", 10, false
      explode.body.setSize 0, 0, 0, 0
      explode.events.onAnimationComplete.add completedAnimation, this
      mummy.kill()

    #remove the ball
    ball.kill()
  completedDroneAnimation = () ->
    ball = @balls.getFirstExists(false)
    if ball
      #start of ball
      ball.reset @drone.x + 6, @drone.y + 8
      #speed and direction
      ball.velocity.x = 600

  completedAnimation = (explode, animation) ->
    explode.reset()

  resetball = (ball) ->
    ball.kill()

  fireball = ()->
    if @game.time.now > @ballTime
      @sniper.animations.add "walking"
      @sniper.animations.play "walking", 20, false
      @specialist.animations.add "walking"
      @specialist.animations.play "walking", 20, false
      @shield.animations.add "walking"
      @shield.animations.play "walking", 20, false
      @drone.animations.add "walking"
      @drone.animations.play "walking", 20, false
      @drone.events.onAnimationComplete.add completedDroneAnimation, @
      @ballTime = @game.time.now + 250




