class @Action
  constructor: (data, doc)->
    @_game = data

    @from(doc)
    @getAbility()
    @to()
    @calculateAbility()
    @save(doc)


  from : (doc) ->
    @_game._playerFlag = !@_game._playerFlag
    _playerNumber = if @_game._playerFlag then "1" else "2"
    @_player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId

    _currentIndex = doc.lastIndex + 1

    #PriorityList 1 (eigene Units)
    @_team = GameTeam.find({gameId: @_game._gameId, userId: @_player, life: {$gt: 0}}, {sort: {priority: 1}})

    @_from = @getNext(_currentIndex)


  getNext: (idx) ->
    _fromPriority = Math.floor((idx/2)) % @_team.length

    unless @_team[_fromPriority]
      getNext(_fromPriority+1)

    if(@_game._lastPriority[@_player._id] == _fromPriority)
      _fromPriority++

    @_game._lastPriority[@_player._id] = _fromPriority
    @_team[_fromPriority]

  getAbility: () ->
    @_randomAbility = @_game[@_from._id].generateRandomAbility()

  to: () ->
    _playerNumber = if @_game._playerFlag then "2" else "1"

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
    @_game[@_from._id][@_randomAbility.name](@_randomAbility,@_targets)

  save: (doc) ->
    actionId = Actions.insert
      gameId: @_game._gameId
      from: @_from._id
      to: @_targets
      abilityId: @_randomAbility._id
      index: parseInt(doc.lastIndex) + 1
    console.log "Added Actions with id: " + actionId




