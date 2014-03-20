class @BaseGameLogic
  constructor: (gameId, reInitializeFlag) ->
    @_gameId = gameId
    @_playerFlag = false

    @initGameTeam()
    @reInitializeBaseGame() if reInitializeFlag
    @initGame()

  initGame: ->
    GamePlayers.find({
      gameId: @_gameId
      state: "waiting"
    }).observe({
      added: (doc) =>
        lastAction = Actions.find({gameId: doc.gameId}, {sort: {index:-1},limit:1}).fetch()[0]?.index or 0
        players = GamePlayers.find({gameId: doc.gameId, state: 'waiting', lastIndex: lastAction}).fetch()
        actions = Actions.find({gameId: doc.gameId, index: {$gt: doc.lastIndex}}).fetch()

        deadHero = @check_end()
        isEnd = Object.keys(deadHero).length > 0

        unless actions && players.length < 2 || isEnd
          @_lastPriority = {}
          @_lastPriority[players[0]._id] = undefined
          @_lastPriority[players[1]._id] = undefined
          new Action(@, doc)

    })

  initGameTeam: ->
    @_gameTeams = GameTeam.find({gameId: @_gameId})

    for member in @_gameTeams
      name = member.unit().name + "Logic"
      @[member._id] = new global[name]({game: @, gameTeamId: member._id})

  check_end: ->
    GameTeam.findOne({gameId: @_gameId, hero: true, life: {$lte: 0}})

  end: ->
    Game.findOne({_id: @_gameId}).end()

  reInitializeBaseGame:() ->
    BaseCondition.reInitializeConditions(@)

    _lastAction = Actions.find({gameId: @_gameId}, {sort: {index:-1},limit:1}).fetch()[0]
    _userId = GameTeam.findOne({_id: _lastAction.from}).userId

    _playerNumber = parseInt(GamePlayers.findOne({gameId: @._gameId, userId: _userId})?.player)
    @_playerFlag = if _playerNumber is 1 then true else false


Meteor.methods
  # conditionsObj: conditionId, value, duration
  addCondition: (gameId, gameTeamId, conditionObj) ->
    BaseGameManager.get(gameId)[gameTeamId]._conditions.add(conditionObj)
