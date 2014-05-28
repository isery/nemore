Meteor.publish "allGames", ->
  Games.find()

Meteor.publish "currentGame", (_id) ->
  Games.find({_id: _id})

Meteor.publish "currentActions", (gameId) ->
  Actions.find({gameId: gameId})

Meteor.publish "currentGamePlayers", (gameId) ->
  GamePlayers.find({gameId: gameId})

Meteor.publish "currentGameTeams", (gameId)->
  GameTeam.all(gameId)

Meteor.publish "allUnits", ->
  Unit.all()

Meteor.publish "userTeams", ->
  Team.all(this.userId)

Meteor.publish "allGameTeams", ->
  GameTeams.find({})

Meteor.publish "allTeams", ->
  Teams.find()

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

Meteor.publish "colorKeys", ->
  [
    Colors.find({}),
    Keys.find({}),
    ColorKeys.find({})
  ]

Meteor.publish 'allUsers', ->
  Meteor.users.find()
