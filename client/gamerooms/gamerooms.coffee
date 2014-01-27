Template.gamerooms.events
  'click .joinGame': (e)->
    _id = $(e.target).data("id")
    currentGame = Game.findById(_id)
    currentGame.setPlayer2 Meteor.userId()
    newTeam = new GameTeam({gameId: currentGame._id}).init()
    console.log "created newTeam"
    console.log newTeam
    Router.go 'preSetting', _id: _id

  'click #createGame': ->
    _id = new Game({userId: Meteor.userId(),gameName: Meteor.userId(), state: "createdGame"}).save()
    console.log "-----"
    console.log _id
    newTeam = new GameTeam({gameId: _id}).init()
    console.log "created newTeam"
    console.log newTeam
    console.log "created game with id: "+_id
    Router.go 'preSetting', _id: _id

Template.gamerooms.findUser = () ->
  userId = GamePlayers.findOne({gameId: @_id, player: "1"})?.userId
  Meteor.users.findOne({_id: userId})?.profile?.name

Template.gamerooms.findImage = () ->
  userId = GamePlayers.findOne({gameId: @_id, player: "1"})?.userId
  Meteor.users.findOne({_id: userId})?.profile?.picture


