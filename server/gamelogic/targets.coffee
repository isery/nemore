class @Targets
  _flag = false
  constructor: (data) ->
    @_id = data

  generateTo: (numTargets) ->

    _playerNumber = if @_flag then "2" else "1"

    @_player2 = GamePlayers.findOne({gameId: @_id, player: _playerNumber}).userId
    @_player2Units = GameTeam.find({gameId: @_id, userId: @_player2})

    @_numberOfTargets = numTargets
    @_targets = []

    @_randomTarget = Math.floor(Math.random() * (@_player2Units.length-1 ))

    for i in [0...@_numberOfTargets]
      @_targets.push
        gameTeamId: @_player2Units[@_randomTarget]._id
        armor: @_player2Units[@_randomTarget].armor

    @_targets

  generateFrom: () ->

    _playerNumber = if @_flag then "1" else "2"

    @_flag = !@_flag

    @_player = GamePlayers.findOne({gameId: @_id, player: _playerNumber}).userId
    @_playerUnits = GameTeam.find({gameId: @_id, userId: @_player})

    @_playerUnits[Math.floor(Math.random() * @_playerUnits.length)]._id
