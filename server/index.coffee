Accounts.onCreateUser (options, user) ->
  if (options.profile)
    options.profile.picture = getFbPicture( user.services.facebook.accessToken )

    # We still want the default hook's 'profile' behavior.
    user.profile = options.profile;
  return user

# get user picture from facebook api
getFbPicture = (accessToken) ->
  result = Meteor.http.get "https://graph.facebook.com/me",
    params:
      access_token: accessToken
      fields: 'picture'
  if(result.error)
    throw result.error
  return result.data.picture.data.url

startGame = (_id)->
  player1 = GamePlayers.findOne({gameId: _id, player: "1"}).userId
  player2 = GamePlayers.findOne({gameId: _id, player: "2"}).userId
  player1Units = GameTeam.find({gameId: _id, userId: player1})
  player2Units = GameTeam.find({gameId: _id, userId: player2})
  Actions.insert
    gameId: _id
    from: player1Units[Math.floor(Math.random() * player1Units.length)]._id
    to: player2Units[Math.floor(Math.random() * player2Units.length)]._id
    special: false
    hit: true
    damage: 200
    createdAt: new Date()

  GamePlayers.find({
    gameId: _id
    state: "waiting"
  }).observe({
    added: (doc) ->
      players = GamePlayers.find({gameId: doc.gameId, state: 'waiting', lastActionAt: doc.lastActionAt}).fetch()
      actions = Actions.find({gameId: doc.gameId, createdAt: {$gt: doc.lastActionAt}})
      unless actions && players.length < 2
        player1 = GamePlayers.findOne({gameId: doc.gameId, player: "1"}).userId
        player2 = GamePlayers.findOne({gameId: doc.gameId, player: "2"}).userId
        player1Units = GameTeam.find({gameId: doc.gameId, userId: player1})
        player2Units = GameTeam.find({gameId: doc.gameId, userId: player2})
        actionId = Actions.insert
          gameId: doc.gameId
          from: player1Units[Math.floor(Math.random() * player1Units.length)]._id
          to: player2Units[Math.floor(Math.random() * player2Units.length)]._id
          special: false
          hit: true
          damage: 200
          createdAt: new Date()
    # if flag then playerTwoUnit[Math.floor(Math.random() * playerTwoUnit.length)]._id else playerOneUnit[Math.floor(Math.random() * playerOneUnit.length)]._id
  })

Meteor.startup ->
  Games.find({
    state: "ready"
  }).observe({
    added: (game) ->
      console.log "Observer: New game initialized at " + new Date()
      startGame(game._id)
      Games.update({_id: game._id},{$set: {state: "playing"}})
  })

  # TODO Continue games with state playing on server restart
