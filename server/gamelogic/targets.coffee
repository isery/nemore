class @Targets
  @generateTo: (data) ->
    @_player2 = GamePlayers.findOne({gameId: data.gameId, player: "2"}).userId
    @_player2Units = GameTeam.find({gameId: data.gameId, userId: @_player2})

    @_numberOfTargets = data.numTargets
    @_damageToTarget = data.damage
    @_hitTarget = data.hit
    @_targets = []

    for i in [0...@_numberOfTargets]
      @_targets.push {hit: @_hitTarget, gameTeamId: @_player2Units[Math.floor(Math.random() * @_player2Units.length)]._id, damage: @_damageToTarget}

    @_targets

  @generateFrom: (_gameId) ->
    @_player1 = GamePlayers.findOne({gameId: _gameId, player: "1"}).userId
    @_player1Units = GameTeam.find({gameId: _gameId, userId: @_player1})

    @_player1Units[Math.floor(Math.random() * @_player1Units.length)]._id
