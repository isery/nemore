Template.gamerooms.events
  'click .joinGame': (e)->
    _id = $(e.target).data("id")
    Router.go 'preSetting', _id: _id

  'click #createGame': ->
    _id = new Game({userId: Meteor.userId(),gameName: Meteor.userId(), state: "createdGame"}).save()
    newTeam = new GameTeam({gameId: _id}).init()
    Router.go 'preSetting', _id: _id

Template.gamerooms.gameTeam = ->
  GameTeam.find({gameId: @_id})

Template.gamerooms.unitName = ->
  @unit().name

Template.gamerooms.unitThumb = ->
  unitname = @unit().name
  unitname.toLowerCase() + '_thumb.jpg'

Template.gamerooms.heroClass = ->
  return "hero" if @hero
  "crew"

Template.gamerooms.findUser = () ->
  userId = GamePlayers.findOne({gameId: @_id, player: "1"})?.userId
  Meteor.users.findOne({_id: userId})?.username

Template.gamerooms.findImage = () ->
  userId = GamePlayers.findOne({gameId: @_id, player: "1"})?.userId
  Meteor.users.findOne({_id: userId})?.profile?.picture
