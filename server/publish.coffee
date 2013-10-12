Meteor.publish "allGames", ->
  Games.find()
