class @Action
  constructor: (data, doc)->
    @_game = data

    @from(doc)
    @updateConditions(@from)
    @getAbility(doc)
    @to()
    @calculateAbility()
    @save(doc)


  from : (doc) ->
    @_game._playerFlag = !@_game._playerFlag
    _playerNumber = if @_game._playerFlag then "1" else "2"
    @_player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId

    _currentIndex = doc.lastIndex + 1

    #PriorityList 1 (eigene Units)
    @_gameTeam = GameTeam.find({gameId: @_game._gameId, userId: @_player, life: {$gt: 0}}, {sort: {priority: 1}})

    @_from = @getNextFrom(_currentIndex)


  getNextFrom: (idx) ->
    _fromPriority = Math.floor((idx/2)) % @_gameTeam.length

    unless @_gameTeam[_fromPriority]
      @getNextFrom(_fromPriority+1)

    if(@_game._lastPriority[@_player._id] == _fromPriority)
      _fromPriority++

    @_game._lastPriority[@_player._id] = _fromPriority
    @_gameTeam[_fromPriority]

  getAbility: (doc) ->
    #useless For loop?
    for _abilityInPriorityList in @_from.team().abilityPriorities()
      _abilityId = _abilityInPriorityList.abilityId
      @_ability = SpecialAbilities.findOne({_id: _abilityId, unitId: @_from.unitId})

      _lastAbility = Actions.find({gameId: @_game._gameId, abilityId: _abilityId}, {sort: {index:-1}}).fetch()[0] || null

      if _lastAbility?
        _indexOfLastAbility = _lastAbility.index
        _currentIndex = doc.lastIndex + 1
        _cooldownOfAbility = @_ability.cooldown

        if _currentIndex - _indexOfLastAbility > _cooldownOfAbility or _lastAbility.length is 0
          return @_ability
        else
          @getNextAbility(doc)
      else
        return @_ability



  to: () ->
    _playerNumber = if @_game._playerFlag then "2" else "1"

    _player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId
    _gameTeam = GameTeam.find({gameId: @_game._gameId, userId: _player})

    #_numberOfTargets = @_randomAbility.target_count
    _numberOfTargets = @_ability.target_count

    @_targets = []

    for i in [0..._numberOfTargets]
      _randomTarget = Math.floor(Math.random() * _gameTeam.length)

      @_targets.push
        gameTeamId: _gameTeam[_randomTarget]._id
        armor: _gameTeam[_randomTarget].unit().armor

    @_targets

  calculateAbility: () ->
    #@_game[@_from._id][@_randomAbility.name](@_randomAbility,@_targets)
    @_game[@_from._id][@_ability.name](@_ability,@_targets)

  updateConditions: ->
    BaseCondition.update(@_game, @_from._id)

  save: (doc) ->
    ###
    actionId = Actions.insert
      gameId: @_game._gameId
      from: @_from._id
      to: @_targets
      abilityId: @_randomAbility._id
      index: parseInt(doc.lastIndex) + 1
    ###
    actionId = Actions.insert
      gameId: @_game._gameId
      from: @_from._id
      to: @_targets
      abilityId: @_ability._id
      index: parseInt(doc.lastIndex) + 1
    console.log "Added Actions with id: " + actionId




