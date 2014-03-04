class @BaseCondition
  constructor: (data) ->
    @_conditions = {}
    @_game = data.game
    @_gameTeamId = data.gameTeamId

  add: (ability) ->
    condition = Conditions.findOne({_id: ability.conditionId})
    if @_conditions[condition.name]
      @_conditions[condition.name].leftDuration = ability.duration
    else
      @_conditions[condition.name] =
        conditionId: condition._id
        leftDuration: ability.duration
        gameTeamId: @_gameTeamId

      @_conditions[condition.name]._id = @save(@_conditions[condition.name])

#TOOO add remove

  save: (options) ->
    GameTeamConditions.insert(options)

  @update = (game, gameTeamId) ->
    userId = GameTeam.findOne({_id: gameTeamId}).userId
    gameTeams = GameTeam.find({userId: userId, gameId: game._gameId})
    for gameTeam in gameTeams
      gameTeamConditions = gameTeam.conditions()._gameTeamConditions
      for gameTeamCondition in gameTeamConditions
        leftDuration = game[gameTeam._id]._conditions._conditions[gameTeamCondition.condition.name].leftDuration -= 1
        if leftDuration == 0
          delete game[gameTeam._id]._conditions._conditions[gameTeamCondition.condition.name]
          GameTeamConditions.remove({_id: gameTeamCondition._id})
        else
          GameTeamConditions.update
            _id: gameTeamCondition._id
          ,
            $set:
              leftDuration: leftDuration
