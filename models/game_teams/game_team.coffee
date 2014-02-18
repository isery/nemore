@GameTeams = new Meteor.Collection 'gameTeams'

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
        life: @initLife(member)
        armor: member.unit().armor

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

  initLife: (member) ->
    life = member.unit().life
    if member.hero then life else (life * 0.75)


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
