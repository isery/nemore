class @BaseGame
  constructor: (data) ->
    @playerOne =
      hero: data.heroOne
      team: data.gameTeamOne

    @playerTwo =
      hero: data.heroTwo
      team: data.gameTeamTwo

    @game = new Phaser.Game(1024, 900, Phaser.AUTO, "base-game",
      preload: @preload
      create: @create
      update: @update
    )

  preload: ->
    @game.load.spritesheet "mummy", "/sprites/commander.gif", 125, 125
    @game.load.image "ball", "/sprites/aqua_ball.png"
    @game.load.image "healthbar", "/sprites/healthbar.png"
    #name, path, x, y, count of images -> how to find x + y ? try and error? error when to big for frame
    @game.load.spritesheet "explode", "/sprites/explode1.png", 128, 128, 16
  create: ->
    @balls = @game.add.group(null, "balls")
    i = 0
    while i < 10
      b = @balls.create(0, 0, "ball")
      b.name = "ball" + i
      b.exists = false
      b.visible = false
      b.events.onOutOfBounds.add resetball, this
      i++
    @healthbar = @game.add.sprite(400, 20, "healthbar")
    @mummy = @game.add.sprite(100, 100, "mummy")
    @mummy.animations.add "walking"
    @mummy.animations.play "walking", 30, true
    @mummy.body.setSize 20, 20, 0, 0
    @mummy2 = @game.add.sprite(500, 100, "mummy")
    @mummy2.animations.add "walking"
    @mummy2.animations.play "walking", 30, true
    @mummy2.body.setSize 20, 20, 0, 0
    @mummy2.scale.x = -1
    @ballTime = 0
    @liveOfMummy2 = 100;
    @elem = document.getElementById("live");
  update: ->
    @game.physics.collide @balls, @mummy2, collisionHandler, null, this
    fireball(@)  if @game.input.keyboard.isDown(Phaser.Keyboard.SPACEBAR)
  collisionHandler = (mummy, ball) ->
    console.log "collision"
    @liveOfMummy2 -= 25

    #healthbar.crop.left = 50;
    @elem.value = @liveOfMummy2

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
      console.log explode
      explode.events.onAnimationComplete.add completedAnimation, this
      mummy.kill()

    #remove the ball
    ball.kill()



  completedAnimation = (explode, animation) ->
    explode.reset()

  resetball = (ball) ->
    ball.kill()

  fireball = (that)->
    console.log that.game.time.now
    console.log that.ballTime
    if that.game.time.now > that.ballTime
      ball = that.balls.getFirstExists(false)
      console.log ball
      if ball
        #start of ball
        ball.reset that.mummy.x + 6, that.mummy.y + 8
        #speed and direction
        ball.velocity.x = 600
        # gap between balls -> has 10 at once
        that.ballTime = that.game.time.now + 250