@Games = new Meteor.Collection 'games'

class @Game
  @_maxCount = 1
  constructor: (options) ->
    @validate options
    for key, value of options
      @[key] = value

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options

  validateSave: ->
    throw new Meteor.Error 490, 'Undefined userId' unless @userId
    if Games.find({userId: @userId}).fetch().length + 1 > @_maxCount
      throw new Meteor.Error 490, 'Already enough open games'

  save: ->
    @validateSave()
    @_id = Games.insert
      created_at: new Date()

    GamePlayers.insert
      gameId: @_id
      userId: Meteor.userId()
      state: "creating"
      player: "1"
      lastActionAt: new Date()

    @_id

  setPlayer2: (userId)->
    GamePlayers.insert
      gameId: @_id
      userId: userId
      state: "joining"
      player: "2"
      lastActionAt: new Date()

    players = GamePlayers.find({gameId: @_id}).fetch()

    for player in players
      GamePlayers.update
        _id: player._id
      ,
        $set:
          state: "waiting"

  setReady: ->
    Games.update
      _id: @_id
    ,
      $set:
        state: "ready"


  # For Meteor publish
  @all = ->
    games = Games.find({})

  @findOne = (options = {}) ->
    game = Games.findOne(options)
    new Game(game) if game?

  @getId = ->
    @_id

  @findById = (id) ->
    game = Games.findOne({_id:id})
    new Game(game) if game?

  @find = (options = {})->
    games = Games.find(options).fetch()
    new Game(game) for game in games

  @count: ->
    Games.find({}).fetch().length

  @remove: (options)->
    Games.remove({_id: opions._id}) if opions_id? and options.userId is @userId
