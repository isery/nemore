Template.gamerooms.events
  'click .joinGame': (e)->
    _id = $(e.target).data("id")
    currentGame = Game.findById(_id)
    currentGame.setPlayer2 Meteor.userId()
    Router.go 'preSetting', _id: _id

  'click #createGame': ->
    gameName = $('#newGameName').val()
    _id = new Game({userId: Meteor.userId(),gameName: gameName}).save()
    console.log "created game with id: "+_id
    Router.go 'preSetting', _id: _id


