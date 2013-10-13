startGame = (_id)->
  Meteor.setInterval( ->
    game = Game.findOne({_id: _id})
    if game
      _id = game._id
      x = game.x + 5
      y = game.y + 0
      # Game.update({_id: _id},{$set: {"x": x, "y": y}})
  ,200)

Meteor.startup ->
  lastCheckedTime = new Date()
  Game.find({created_at : {$gt: lastCheckedTime}, player2 : {$exists: true}}).observe({
    added: (game)->
      lastCheckedTime = new Date()
      console.log "Observer: New game initialized at " + lastCheckedTime
      startGame(game._id)
  })
