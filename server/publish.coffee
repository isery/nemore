Meteor.publish "allGames", ->
  Games.find()

Meteor.publish "currentGame", (_id) ->
  Games.find({_id: _id})

Meteor.publish "allUnits", ->
  Unit.all()

Meteor.publish "allTeams", ->
  Team.all(this.userId)

Meteor.publish "userData", ->
  Meteor.users.find({},
    {fields: {'username': 1, 'profile': 1}});

Meteor.publish "allSpecialAbilities", ->
  SpecialAbilities.find({})
