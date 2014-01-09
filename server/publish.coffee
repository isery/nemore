Meteor.publish "allGames", ->
  Games.find()

Meteor.publish "currentGame", (_id) ->
  Games.find({_id: _id})

Meteor.publish "allHeroes", ->
  Hero.all()

Meteor.publish "allCrewmembers", ->
  Crewmember.all(this.userId)

Meteor.publish "userData", ->
  Meteor.users.find({},
    {fields: {'hero': 1,'username':1}});

Meteor.publish "allSpecialAbilities", ->
  SpecialAbilities.find({})
