class @Action
  _flag: false
  constructor: (data, doc)->
    @_game = data

    @from()
    @getAbility()
    @to()
    @calculateAbility()
    @save(doc)


  from : () ->
    @_flag = !@_flag
    _playerNumber = if @_flag then "1" else "2"

    _player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId
    @_gameTeam = GameTeam.find({gameId: @_game._gameId, userId: _player})

    @_randNumber = Math.floor(Math.random() * @_gameTeam.length)
    @_gameTeamId = @_gameTeam[@_randNumber]._id
    @_gameTeam[@_randNumber]

  getAbility: () ->
    @_randomAbility = @_game[@_gameTeamId].generateRandomAbility()

  to: () ->
    _playerNumber = if @_flag then "2" else "1"

    _player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId
    _gameTeam = GameTeam.find({gameId: @_game._gameId, userId: _player})

    _numberOfTargets = @_randomAbility.target_count

    @_targets = []

    for i in [0..._numberOfTargets]
      _randomTarget = Math.floor(Math.random() * _gameTeam.length)

      @_targets.push
        gameTeamId: _gameTeam[_randomTarget]._id
        armor: _gameTeam[_randomTarget].unit().armor

    @_targets

  calculateAbility: () ->
    @_game[@_gameTeamId][@_randomAbility.name](@_randomAbility,@_targets)

  save: (doc) ->
    actionId = Actions.insert
      gameId: @_game._gameId
      from: @_gameTeam[@_randNumber]._id
      to: @_targets
      abilityId: @_randomAbility._id
      index: parseInt(doc.lastIndex) + 1
    console.log "Added Actions with id: " + actionId