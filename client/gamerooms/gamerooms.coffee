Template.gamerooms.events
  'click .joinGame': (e)->
    _id = $(e.target).data("id")
    console.log _id
    Games.update({_id: _id},{$set: {"player2": Meteor.userId()}})
    Router.go 'games', _id: _id

  'click #createGame': ->
    gamename = $('#newGameName').val()
    _id = Games.insert
      "name": gamename,
      "x": 0,
      "y": 0,
      "player1": Meteor.userId(),
      "playing": false
      "created_at": new Date()
    Router.go 'games', _id: _id


