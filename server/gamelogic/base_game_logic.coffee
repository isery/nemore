class @BaseGameLogic
  constructor: (data) ->
    @_gameId = data

    @_targets = new Targets(@_gameId)

    @_sniper = new SniperLogic(@)
    @_drone = new DroneLogic(@)
    @_commander = new CommanderLogic(@)
    @_specialist = new SpecialistLogic(@)

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
          gameUnit = @_targets.generateFrom()
          doc.gameTeam = gameUnit
          gameUnitName = "_"+gameUnit.unit().name.toLowerCase()
          randomAbility = @[gameUnitName].generateRandomAbility()
          @[gameUnitName][randomAbility.name](doc)
    })


  ###
    Jede Unit einzeln Instanzieren
  ###
  initGameTeam: ->
