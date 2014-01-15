Template.games.created = ->
  new BaseGame(@data)

Template.games.destroyed = ->
  delete @game
  $("canvas")?.hide()
