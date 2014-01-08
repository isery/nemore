Meteor.publish "allGames", ->
  Games.find()

Meteor.publish "allHeroes", ->
  Hero.all()

Meteor.publish "allCrewmembers", ->
  Crewmember.all()

Meteor.publish "userData", ->
  Meteor.users.find({_id: this.userId},
    {fields: {'hero': 1}});
