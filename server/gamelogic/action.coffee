class @Action
  constructor: (data, doc)->
    @_game = data
    @_doc = doc

    @from() #P1
    @updateConditions()
    @_priorityLists = @getPriorityLists()
    @getAbility() #P2
    @to()
    @calculateAbility()
    @save()

    @_operators =
      '<': (obj1,obj2) -> obj1 < obj2
      '>': (obj1,obj2) -> obj1 > obj2

  from : () ->
    @_game._playerFlag = !@_game._playerFlag
    _playerNumber = if @_game._playerFlag then "1" else "2"
    @_player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId

    _currentIndex = @_doc.lastIndex + 1

    #PriorityList 1 (own Units)
    @_gameTeam = GameTeam.find({gameId: @_game._gameId, userId: @_player, life: {$gt: 0}}, {sort: {priority: 1}})

    @_from = @getNextFrom(_currentIndex)

  updateConditions: ->
    BaseCondition.update(@_game, @_from._id)

  getPriorityLists: () ->
    _playerNumber = if @_game._playerFlag then "1" else "2"

    _player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId
    _priorityList = Team.priorityList(_player)

    for item in _priorityList
      if @_from.unitId is item.team.unitId
        return item

  getAbility: (index = 0) ->
    #PriorityList 2 (Abilities)
    for i in [index...@_priorityLists.abilityPriority.length]
      _abilityId = @_priorityLists.abilityPriority[i].abilityPriority.abilityId
      @_ability = SpecialAbilities.findOne({_id: _abilityId})
      _lastAbility = Actions.find({gameId: @_game._gameId, abilityId: _abilityId}, {sort: {index:-1}}).fetch()[0] || null

      if _lastAbility?
        _indexOfLastAbility = _lastAbility.index
        _currentIndex = @_doc.lastIndex + 1
        if _currentIndex - _indexOfLastAbility > @_ability.cooldown
          return @_ability
      else
        return @_ability

  to: () ->

    _typeOfTarget = @_ability.target_type
    _currentAbilityPriority = AbilityPriorities.findOne({abilityId: @_ability._id, teamId: @_from.teamId}).priority
    @_targetCounter = 0
    @_targets = []

    if _typeOfTarget is "self"
      @pushTargetSelf(_currentAbilityPriority)
    else
      _gameTeam = @getGameTeamTo(_typeOfTarget, _currentAbilityPriority)
      @walkThroughTargetPriorityList(_gameTeam, _currentAbilityPriority)

    @_targets

  calculateAbility: () ->
    @_game[@_from._id][@_ability.name](@_ability,@_targets)

  save: () ->
    debugger
    actionId = Actions.insert
      gameId: @_game._gameId
      from: @_from._id
      to: @_targets
      abilityId: @_ability._id
      index: parseInt(@_doc.lastIndex) + 1
    console.log "Added Actions with id: " + actionId

  getNextFrom: (idx) ->
    _fromPriority = Math.floor((idx/2)) % @_gameTeam.length

    unless @_gameTeam[_fromPriority]
      @getNextFrom(_fromPriority+1)

    if(@_game._lastPriority[@_player._id] == _fromPriority)
      _fromPriority++

    @_game._lastPriority[@_player._id] = _fromPriority
    @_gameTeam[_fromPriority]

  getGameTeamTo: (typeOfTarget, currentAbilityPriority) ->
    switch typeOfTarget
      when "team"
        _playerNumber = if @_game._playerFlag then "1" else "2"
        _player = GamePlayers.findOne({gameId: @_game._gameId, player: _playerNumber}).userId
        return GameTeam.find({gameId: @_game._gameId, userId: _player})
      when "enemies"
        _otherPlayerNumber = if @_game._playerFlag then "2" else "1"
        _otherPlayer = GamePlayers.findOne({gameId: @_game._gameId, player: _otherPlayerNumber}).userId
        return GameTeam.find({gameId: @_game._gameId, userId: _otherPlayer})

  pushTargetSelf: (currentAbilityPriority) ->
    for _item in @_priorityLists.abilityPriority
      if _item.abilityPriority.abilityId is @_ability._id
        _term = @getTerm(_item)

        #Prioritylist3 + Prioritylist4 (Target + Abilityterm)
        if _term.operator is "∞" or @checkAbilityTerms(@_from, _term)
          @_targets.push({
            gameTeamId: @_from._id
            armor: @_from.unit().armor
          })
        else
          @getAbility(currentAbilityPriority + 1)
          @to()

  getTerm: (item) ->
    return Terms.findOne({_id: item.abilityTerm[0].termId})


  walkThroughTargetPriorityList: (gameTeam, currentAbilityPriority) ->
    for _item in @_priorityLists.abilityPriority
      if _item.abilityPriority.abilityId isnt @_ability._id
        _term = @getTerm(_item)
        for _targetPriority in _item.targetPriorities
          #Prioritylist3(Random Targets)
          _random = "Random"
          if( _random is _targetPriority.unitId )
            _otherTeamUnit = gameTeam[Math.floor(Math.random() * (gameTeam.length))]
            @pushTarget({otherTeamUnit: _otherTeamUnit, term: _term, currentAbilityPriority: currentAbilityPriority, gameTeam: gameTeam})
          else
            for _otherTeamUnit in gameTeam
              #Prioritylist3(Targets)
              _hero = if _otherTeamUnit.hero then "Hero" else "NoHero"
              if ((_otherTeamUnit.unitId is _targetPriority.unitId) or (_hero is _targetPriority.unitId))
                @pushTarget({otherTeamUnit: _otherTeamUnit, term: _term, currentAbilityPriority: currentAbilityPriority, gameTeam: gameTeam})


  pushTarget: (data) ->
      switch data.term.operator
        when "<"
          #Prioritylist4(Abilityterms)
          if @checkAbilityTerms(data.otherTeamUnit, data.term) and @checkNumberOfTargets(data.gameTeam) and @checkTargetHealth(data.otherTeamUnit)
            @_targetCounter++
            @_targets.push({
              gameTeamId: data.otherTeamUnit._id
              armor: data.otherTeamUnit.unit().armor
            })
          else
            @getAbility(data.currentAbilityPriority + 1)
            @to()
        when "∞"
          if @checkNumberOfTargets(data.gameTeam) and @checkTargetHealth(data.otherTeamUnit)
            @_targetCounter++
            @_targets.push({
              gameTeamId: data.otherTeamUnit._id
              armor: data.otherTeamUnit.unit().armor
            })

  checkAbilityTerms: (target, term) ->
    @_operators[term.operator](@_game[target._id]._unitLife, @_game[target._id]._unitMaxLife * term.value)

  checkTargetHealth: (target) ->
    @_game[target._id]._unitLife > 0

  checkNumberOfTargets: (gameTeam) ->
    @_targetCounter < @_ability.target_count and @_targetCounter < gameTeam.length