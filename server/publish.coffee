Meteor.publish "allGames", ->
  Game.find()

Meteor.publish "allHeroes", ->
  Heroe.find()
