GameTeams = new Meteor.Collection 'gameTeams'

class @GameTeam
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    team = Team.find({userId: Meteor.userId()})
    for member in team
      GameTeams.insert
        gameId: @gameId
        userId: member.userId
        unitId: member.unitId
        hero: member.hero

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

  @all = (userId) ->
    GameTeams.find({userId: userId})

  @find = (options = {})->
    teams = GameTeams.find(options).fetch()
    new GameTeam(team) for team in teams

  @update = (_id, options) ->
    GameTeams.update
      _id: _id
    ,
      $set:
        options
