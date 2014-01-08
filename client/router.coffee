Router.configure
	layoutTemplate: 'layout',
	notFoundTemplate: 'notFound',
	loadingTemplate: 'loading'

Router.map ->
  @isLoggedIn = (that)->
    that.subscribe('userData').wait()
    if !Meteor.user()
      Router.go 'home'
      that.stop()

  @route 'home',
    path: '/'
    waitOn: ->
      Meteor.subscribe 'userData'
  @route 'gamerooms',
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allGames'
    data: ->
      currentOpenGames: Games.find({playing: false}).fetch()
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
    waitOn: -> Meteor.subscribe 'allHeroes'
    data: ->
      heroes: Hero.find({})
  @route 'crewSelection',
    path: '/crew_selection'
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      Meteor.subscribe 'allHeroes'
      Meteor.subscribe 'allCrewmembers'
    data: ->
      heroes: Heroes.find()
      crewmembers: Crewmember.find()
  @route 'summary',
    before: ->
      Router.isLoggedIn(@) if @ready()
    waitOn: ->
      [
        Meteor.subscribe 'allHeroes'
        Meteor.subscribe 'allCrewmembers'
        Meteor.subscribe 'userData'
      ]
    data: ->
      hero: Hero.findOne({_id: Meteor.user().hero})
      crewmembers: Crewmember.find({userId: Meteor.userId()})
