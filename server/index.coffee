Accounts.onCreateUser (options, user) ->
  if (options.profile)
    options.profile.picture = getFbPicture( user.services.facebook.accessToken )

    user.profile = options.profile;
  return user

getFbPicture = (accessToken) ->
  result = Meteor.http.get "https://graph.facebook.com/me",
    params:
      access_token: accessToken
      fields: 'picture'
  if(result.error)
    throw result.error
  return result.data.picture.data.url

startGame = (_id)->
  console.log "Started Game with id: " + _id
  new BaseGameLogic(_id)

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
