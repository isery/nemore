Meteor.publish "allGames", ->
  Games.find()

Meteor.publish "currentGame", (_id) ->
  Games.find({_id: _id})

Meteor.publish "currentActions", (gameId) ->
  Actions.find({gameId: gameId})

Meteor.publish "allUnits", ->
  Unit.all()

Meteor.publish "allTeams", ->
  Team.all(this.userId)

Meteor.publish "allGameTeams", (gameId)->
  GameTeam.all(gameId)

Meteor.publish "allGamePlayers", ->
  GamePlayers.find({})

Meteor.publish "userData", ->
  Meteor.users.find({},
    {fields: {'username': 1, 'profile': 1}});

Meteor.publish "allSpecialAbilities", ->
  SpecialAbilities.find({})

Meteor.publish "allTerms", ->
  Terms.find({})

Meteor.publish "priorityLists", ->
  [
    AbilityPriorities.find({}),
    TargetPriorities.find({}),
    AbilityTerms.find({}),
    Terms.find({})
  ]

Meteor.publish "conditions", ->
  [
    GameTeamConditions.find({}),
    Conditions.find({})
  ]
