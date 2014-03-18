# Accounts.onCreateUser (options, user) ->
#   if (options.profile)
#     options.profile.picture = getFbPicture( user.services.facebook.accessToken )

#     user.profile = options.profile;
#   return user

getFbPicture = (accessToken) ->
  result = Meteor.http.get "https://graph.facebook.com/me",
    params:
      access_token: accessToken
      fields: 'picture'
  if(result.error)
    throw result.error
  return result.data.picture.data.url

reInitializeOnStartup = () ->
  _games = Games.find({state: "playing"}).fetch()
  for _game in _games
    console.log "Reinitialized Observer on game with id: " + _game._id
    new BaseGameLogic(_game._id, true)

Meteor.startup ->
  Games.find({
    state: "ready"
  }).observe({
    added: (game) ->
      console.log "Observer: New game initialized at " + new Date()
      Games.update({_id: game._id},{$set: {state: "playing"}})

      console.log "Started Game with id: " + game._id
      new BaseGameLogic(game._id, false)
  })

  reInitializeOnStartup()