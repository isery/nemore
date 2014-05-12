Template.games.created = ->
  new BaseGame(@data)

Template.games.destroyed = ->
  delete @game
  $("canvas")?.hide()

Template.games.events
  'click #end-game': ->
    Router.go 'gamerooms'
