Template.games.created = ->
  new BaseGame(@data)

Template.games.destroyed = ->
  BaseGame._instance.game.sound.setMute(true)
  delete BaseGame._instance
  $("canvas")?.hide()

Template.games.events
  'click #end-game': ->
    Router.go 'gamerooms'
