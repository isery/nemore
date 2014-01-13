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
    data: ->
      currentOpenGames: Games.find({player2: {$exists: false}}).fetch()
      users: Meteor.users.find({}).fetch()
  @route 'preSetting',
    path: '/preSetting/:_id'
  @route 'games',
    path: '/games/:_id'
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: -> Meteor.subscribe 'allGames'
    data: ->
      game: Games.findOne _id: @params._id
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
