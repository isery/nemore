class BaseGameManager
  constructor: ->
    @_instances = {}

  set: (game) ->
    @_instances[game._gameId] = game

  get: (gameId) ->
    @_instances[gameId]

@BaseGameManager = new BaseGameManager()
