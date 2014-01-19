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
  flag = true
  game = Game.findOne({_id: _id})
  playerOne = game.player1
  playerTwo = game.player2
  playerTwoUnit = GameTeams.find({gameId: _id, userId: playerTwo}).fetch()
  playerOneUnit = GameTeams.find({gameId: _id, userId: playerOne}).fetch()
  Actions.find({
    gameId: _id, player1: true, player2: true
  }).observe({
    added: (doc) ->
      console.log "ADDED at: " + new Date()
      flag = !flag
      actionId = Actions.insert
        gameId: "1"
        from: if flag then playerOneUnit[Math.floor(Math.random() * playerOneUnit.length)]._id else playerTwoUnit[Math.floor(Math.random() * playerTwoUnit.length)]._id
        to: if flag then playerTwoUnit[Math.floor(Math.random() * playerTwoUnit.length)]._id else playerOneUnit[Math.floor(Math.random() * playerOneUnit.length)]._id
        special: false
        hit: true
        damage: 200
        player1: false
        player2: false
  })

Meteor.startup ->
  # TODO REMOVE startGame here
  startGame("1")

  Games.find({
    player1 : {$exists: true},
    player2 : {$exists: true},
    player1_ready: true,
    player2_ready: true,
    playing: false
  }).observe({
    added: (game)->
      console.log "Observer: New game initialized at " + new Date()
      Games.update({_id: game._id}, {$set: {playing: true}})
      startGame(game._id)
  })
