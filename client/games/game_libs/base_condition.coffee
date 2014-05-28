class @BaseCondition

  constructor: (data) ->
    @_game = data.game
    @_baseUnit = data.baseUnit
    @_conditions = {}

  add: (conditionName) ->
    if @_conditions[conditionName]
      @_conditions[conditionName].destroy()
      delete @_conditions[conditionName]

      keys = Object.keys(@_conditions)

      for key in keys
        @_conditions[key].destroy()
        delete @_conditions[key]
      keys.push conditionName

      @init(keys)
    else
      @init([conditionName])

  init: (keys)->
    for key in keys
      conditionsCount = Object.keys(@_conditions).length
      @_conditions[key] = @_game.add.sprite(@_baseUnit._lifePosX + 7 + (13 * conditionsCount), @_baseUnit._lifePosY - 30, key)
      @_conditions[key].scale.x *= 0.4
      @_conditions[key].scale.y *= 0.4

  @update: (data) ->
    _baseGame = data.baseGame
    _game = data.baseGame.game
    _action = data.action
    _conditions = []
    userId = GameTeam.findOne({_id: _action.from}).userId
    gameTeam = GameTeam.find({userId: userId, gameId: _baseGame._id})
    for member in gameTeam
      gameTeamConditions = member.conditions()._gameTeamConditions
      for k, v of _baseGame[member._id]._conditions._conditions
        _baseGame[member._id]._conditions._conditions[k].destroy()
        delete _baseGame[member._id]._conditions._conditions[k]

      for gameTeamCondition in gameTeamConditions
        condition = gameTeamCondition.condition
        _baseGame[member._id]._conditions.add(condition.name)
