Meteor.publish "allGames", ->
  Game.find()
