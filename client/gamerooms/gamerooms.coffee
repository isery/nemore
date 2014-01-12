Template.gamerooms.events
  'click .joinGame': (e)->
    _id = $(e.target).data("id")
    currentGame = Game.findById(_id)
    currentGame.setPlayer2 Meteor.userId()
    Router.go 'preSetting', _id: _id

  'click #createGame': ->
    _id = new Game({userId: Meteor.userId(),gameName: Meteor.userId()}).save()
    console.log "created game with id: "+_id
    Router.go 'preSetting', _id: _id

Template.gamerooms.findUser = () ->
  userId = Game.findById(@_id).player1
  Meteor.users.findOne({_id: userId}).profile.name

Template.gamerooms.findImage = () ->
  userId = Game.findById(@_id).player1
  console.log Meteor.users.findOne({_id:userId})
  Meteor.users.findOne({_id: userId}).profile.picture


