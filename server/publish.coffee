Meteor.publish "allGames", ->
  Game.find()

Meteor.publish "allHeroes", ->
  Heroe.find()

Meteor.publish "allCrewmembers", ->
  Crewmember.all()

Meteor.publish "userData", ->
  Meteor.users.find({_id: this.userId},
    {fields: {'heroe': 1}});
