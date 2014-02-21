class @BaseGameLogic
  constructor: (data) ->
    @_gameId = data

    @_playerFlag = false

    @initGameTeam()
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


        unless actions && players.length < 2
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