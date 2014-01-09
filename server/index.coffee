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
  Meteor.setInterval( ->
    game = Games.findOne({_id: _id})
    if game
      _id = game._id
      x = game.x + 5
      y = game.y + 0
      Games.update({_id: _id},{$set: {"x": x, "y": y}})
  ,200)

Meteor.startup ->
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
