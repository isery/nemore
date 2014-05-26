@GamePlayers = new Meteor.Collection 'gamePlayers'

class @GamePlayer
  constructor: (options) ->
    for key, value of options
      @[key] = value

  @all = (gameId) ->
    GamePlayers.find({gameId: gameId})

  @find = (options = {})->
    players = GamePlayers.find(options).fetch()
    new GamePlayer(player) for player in players

  @findOne = (options = {})->
    player = GamePlayers.findOne(options)
    new GamePlayer(player)

  @update = (_id, options) ->
    GamePlayers.update
      _id: _id
    ,
      $set:
        options

  @bothReady = (gameId) ->
    Players = GamePlayers.find({gameId:gameId}).fetch();
    if Players.length < 2
        return false
    else if Players[0].state is "waiting" and Players[1].state is "waiting"
        return true
    else
        return false
