class @BaseLogic
	constructor: (gameID)->
    @_gameID = gameID
    @_critFactor = 1.75

    @initializingObserver()

    ###
		@_targets = []
    for target in data.actions.to
      target.gameTeam = data.baseGame[target.gameTeamId]
      @_targets.push target
		###


  initializingObserver: ->
    GamePlayers.find({
      gameId: @_gameID
      state: "waiting"
    }).observe({
      added: (doc) ->
        lastAction = Actions.find({gameId: doc.gameId}, {sort: {index:-1},limit:1}).fetch()[0]?.index or 0
        players = GamePlayers.find({gameId: doc.gameId, state: 'waiting', lastIndex: lastAction}).fetch()
        actions = Actions.find({gameId: doc.gameId, index: {$gt: doc.lastIndex}}).fetch()

        unless actions && players.length < 2
          player1 = GamePlayers.findOne({gameId: doc.gameId, player: "1"}).userId
          player2 = GamePlayers.findOne({gameId: doc.gameId, player: "2"}).userId
          player1Units = GameTeam.find({gameId: doc.gameId, userId: player1})
          player2Units = GameTeam.find({gameId: doc.gameId, userId: player2})

          targets = []
          targets.push {hit: true, gameTeamId: player2Units[Math.floor(Math.random() * player2Units.length)]._id, damage: 100}
          targets.push {hit: true, gameTeamId: player2Units[Math.floor(Math.random() * player2Units.length)]._id, damage: 100}

          abilities = SpecialAbilities.find({name: {$in: ['autoattack_drone', 'autoattack_sniper', 'autoattack_commander', 'autoattack_specialist']}}).fetch()
          actionId = Actions.insert
            gameId: doc.gameId
            from: player1Units[Math.floor(Math.random() * player1Units.length)]._id
            to: targets
            abilityId: abilities[Math.floor(Math.random() * abilities.length)]._id
            index: parseInt(doc.lastIndex) + 1
          console.log "Added Actions with id: " + actionId
      # if flag then playerTwoUnit[Math.floor(Math.random() * playerTwoUnit.length)]._id else playerOneUnit[Math.floor(Math.random() * playerOneUnit.length)]._id
    })


