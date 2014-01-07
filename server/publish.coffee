Meteor.publish "allGames", ->
  Games.find()

Meteor.publish "allHeroes", ->
  Heroes.find()

Meteor.publish "allCrewmembers", ->
  Crewmember.all()

Meteor.publish "userData", ->
  Meteor.users.find({_id: this.userId},
    {fields: {'heroe': 1}});
