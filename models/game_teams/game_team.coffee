@GamePlayers = new Meteor.Collection 'gamePlayers'
@GameTeams = new Meteor.Collection 'gameTeams'

class @GameTeam
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    team = Team.find({userId: Meteor.userId()})
    console.log "team.find "+Meteor.userId()
    console.log team
    for member in team
      GameTeams.insert
        gameId: @gameId
        userId: member.userId
        unitId: member.unitId
        hero: member.hero
        live: @initLive(member)

  special_abilities: ->
    SpecialAbilities.find({unit_id: @unitId}).fetch()

  special_ability: ->
    if @specialAbilityId
      specialAbility = SpecialAbilities.findOne({_id: @specialAbilityId})
    else
      specialAbility = SpecialAbilities.findOne({unit_id: @unitId})
    specialAbility

  unit: ->
    Units.findOne({_id: @unitId})

  initLive: (member) ->
    live = member.unit().live
    if member.hero then live else (live * 0.75)


  @all = (gameId) ->
    GameTeams.find({gameId: gameId})

  @find = (options = {})->
    teams = GameTeams.find(options).fetch()
    new GameTeam(team) for team in teams

  @findOne = (options = {})->
    team = GameTeams.findOne(options)
    new GameTeam(team)

  @update = (_id, options) ->
    GameTeams.update
      _id: _id
    ,
      $set:
        options
