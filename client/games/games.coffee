startGame = (_id)->
  preload = ->
    @game.load.image "logo", "/img/logo_new.png"
    @game.load.spritesheet "mummy", "/img/metalslug_monster39x40.png", 39, 40, 16
  create = ->
    @logo = @game.add.sprite(0, 0, "logo")
    @mummy = @game.add.sprite(300, 200, "mummy")
    @mummy.animations.add "walk"
    @mummy.animations.play "walk", 30, true
  update = ->
    currentGame = Game.findOne({_id: _id})
    if currentGame
      @mummy.x = currentGame.x
      @mummy.y = currentGame.y
  @logo = undefined
  @mummy = undefined
  console.log "HOW MANY TIMES ?"
  @game = new Phaser.Game(800, 600, Phaser.AUTO, "",
    preload: preload
    create: create
    update: update
  )

Template.games.created = ->
  startGame(@data.game._id)

Template.games.destroyed = ->
  delete @game
  $("canvas")?.hide()
