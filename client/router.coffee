Router.configure
  layoutTemplate: 'layout',
	notFoundTemplate: 'templateNotFound'

Router.map ->
  @isLoggedIn = (that)->
    that.subscribe('userData').wait()
    if !Meteor.user()
      Router.go 'home'
      that.stop()

  @hasHero = (that)->
    if Meteor.userId() && !Team.findOne({userId: Meteor.userId(), hero: true})
      Router.go 'heroSelection'
      that.stop()

  @route 'home',
    path: '/'
    onBeforeAction: ->
      Router.hasHero(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'userData'
      Meteor.subscribe 'userTeams'
      # Meteor.subscribe 'colorKeys'
  @route 'gamerooms',
    onBeforeAction: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allGames'
      Meteor.subscribe 'allGameTeams'
      Meteor.subscribe 'allGamePlayers'
      Meteor.subscribe 'userTeams'
      Meteor.subscribe 'allUnits'
    data: ->
      currentOpenGames: Games.find({state: 'createdGame'}).fetch()
      users: Meteor.users.find({}).fetch()
  @route 'preSetting',
    path: '/preSetting/:_id'
    onBeforeAction: ->
      @subscribe('currentGame', @params._id).wait()
      @subscribe('allUnits').wait()
      @subscribe('userTeams').wait()
      @subscribe('allSpecialAbilities').wait()
      @subscribe('currentGameTeams', @params._id).wait()
      @subscribe('allGamePlayers', @params._id).wait()
      @subscribe('priorityLists').wait()

      if @data().currentGame
        Router.isLoggedIn(@)
        _id = @params._id
        currentGame = @data().currentGame
        userId = Meteor.userId()
        gamePlayers = GamePlayer.find({gameId: currentGame._id})
        if gamePlayers.length is 1
          unless gamePlayers[0].userId is userId
            currentGame.setPlayer2(userId)
            newTeam = new GameTeam({gameId: currentGame._id}).init()

    data: ->
      currentGame: Game.findById(@params._id),
      gameTeams: GameTeam.find({userId: Meteor.userId()}, {sort: {priority: 1}})
  @route 'games',
    path: '/games/:_id'
    onBeforeAction: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allGames'
      Meteor.subscribe 'gameGameTeams', @params._id
      Meteor.subscribe 'allGamePlayers'
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'currentActions', @params._id
      Meteor.subscribe 'allSpecialAbilities'
      Meteor.subscribe 'conditions'
      Meteor.subscribe 'colorKeys'
    data: ->
      game: Game.findOne _id: @params._id
      actions: Action.find()
      gameTeamOne: GameTeam.find userId: GamePlayers.findOne({gameId: @params._id, player: "1"}).userId, hero: {$exists: false}
      gameTeamTwo: GameTeam.find userId: GamePlayers.findOne({gameId: @params._id, player: "2"}).userId, gameId: @params._id, hero: {$exists: false}
      heroOne: GameTeam.findOne userId: GamePlayers.findOne({gameId: @params._id, player: "1"}).userId, hero: true
      heroTwo: GameTeam.findOne userId: GamePlayers.findOne({gameId: @params._id, player: "2"}).userId, gameId: @params._id, hero: true
  @route 'heroSelection',
    path: '/hero_selection'
    onBeforeAction: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'userTeams'
      Meteor.subscribe 'allSpecialAbilities'
      Meteor.subscribe 'allTerms'
      Meteor.subscribe 'priorityLists'
    data: ->
      units: Unit.find({}).map (unit) ->
        unit.abilities = unit.specialAbilities()
        unit
  @route 'crewSelection',
    path: '/crew_selection'
    onBeforeAction: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'userTeams'
      Meteor.subscribe 'allSpecialAbilities'
      Meteor.subscribe 'allTerms'
    data: ->
      units: Unit.find({}).map (unit) ->
        unit.abilities = unit.specialAbilities()
        unit
      teams: Team.find({hero: {$exists: false}})
      hero: Team.findOne({userId: Meteor.userId(), hero: true})
  @route 'summary',
    onBeforeAction: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'userTeams'
      Meteor.subscribe 'userData'
    data: ->
      hero: Team.findOne({userId: Meteor.userId(), hero: true})
      teams: Team.find({hero: {$exists: false}})
