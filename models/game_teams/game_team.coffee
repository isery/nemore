GameTeams = new Meteor.Collection 'gameTeams'

class @GameTeam
  constructor: (options) ->
    @gameId = options.gameId

  init: ->
    team = Team.find({userId: Meteor.userId()})
    for member in team
      GameTeams.insert
        gameId: @gameId
        userId: member.userId
        unitId: member.unitId
        hero: member.hero

  save: (options) ->
    GameTeams.update
      gameId: @gameId
    ,
      options
