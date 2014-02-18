class @Targets
  _flag = false
  constructor: (data) ->
    @_id = data

  generateTo: (numTargets) ->

    _playerNumber = if @_flag then "2" else "1"

    @_player = GamePlayers.findOne({gameId: @_id, player: _playerNumber}).userId
    @_playerUnits = GameTeam.find({gameId: @_id, userId: @_player})

    @_numberOfTargets = numTargets
    @_targets = []


    for i in [0...@_numberOfTargets]
      @_randomTarget = Math.floor(Math.random() * @_playerUnits.length)

      @_targets.push
        gameTeamId: @_playerUnits[@_randomTarget]._id
        armor: @_playerUnits[@_randomTarget].unit().armor

    @_targets

  generateFrom: () ->

    _playerNumber = if @_flag then "1" else "2"

    @_flag = !@_flag

    @_player = GamePlayers.findOne({gameId: @_id, player: _playerNumber}).userId
    @_playerUnits = GameTeam.find({gameId: @_id, userId: @_player})

    @_playerUnits[Math.floor(Math.random() * @_playerUnits.length)]