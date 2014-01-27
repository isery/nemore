Router.configure
	layoutTemplate: 'layout',
	notFoundTemplate: 'templateNotFound',
	loadingTemplate: 'loading'

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
    before: ->
      Router.hasHero(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'userData'
      Meteor.subscribe 'allTeams'
  @route 'gamerooms',
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allGames'
      Meteor.subscribe 'allGamePlayers'
    data: ->
      currentOpenGames: Games.find({state: 'createdGame'}).fetch()
      users: Meteor.users.find({}).fetch()
  @route 'preSetting',
    path: '/preSetting/:_id'
  @route 'games',
    path: '/games/:_id'
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allGames'
      Meteor.subscribe 'allGameTeams', @params._id
      Meteor.subscribe 'allGamePlayers'
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'currentActions', @params._id
      Meteor.subscribe 'allSpecialAbilities'
    data: ->
      game: Game.findOne _id: @params._id
      actions: Action.find()
      gameTeamOne: GameTeam.find userId: GamePlayers.findOne({gameId: @params._id, player: "1"}).userId, hero: {$exists: false}
      gameTeamTwo: GameTeam.find userId: GamePlayers.findOne({gameId: @params._id, player: "2"}).userId, gameId: @params._id, hero: {$exists: false}
      heroOne: GameTeam.findOne userId: GamePlayers.findOne({gameId: @params._id, player: "1"}).userId, hero: true
      heroTwo: GameTeam.findOne userId: GamePlayers.findOne({gameId: @params._id, player: "2"}).userId, gameId: @params._id, hero: true
  @route 'heroSelection',
    path: '/hero_selection'
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'allTeams'
    data: ->
      units: Unit.find({})
  @route 'crewSelection',
    path: '/crew_selection'
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'allTeams'
    data: ->
      units: Unit.find()
      teams: Team.find({hero: {$exists: false}})
      hero: Team.findOne({userId: Meteor.userId(), hero: true})
  @route 'summary',
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allUnits'
      Meteor.subscribe 'allTeams'
      Meteor.subscribe 'userData'
    data: ->
      hero: Team.findOne({userId: Meteor.userId(), hero: true})
      teams: Team.find({hero: {$exists: false}})
