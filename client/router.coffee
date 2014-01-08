Router.configure
	layout: 'layout',
	notFoundTemplate: 'notFound',
	loadingTemplate: 'loading'

Router.map ->
  @route 'home', path: '/'
  @route 'gamerooms',
    waitOn: -> Meteor.subscribe 'allGames',
    data: ->
      currentOpenGames: Games.find().fetch()
  @route 'games',
    path: '/games/:_id',
    waitOn: -> Meteor.subscribe 'allGames',
    data: ->
      game: Games.findOne _id: @params._id
  @route 'heroSelection',
    path: '/hero_selection'
    waitOn: -> Meteor.subscribe 'allHeroes',
    data: ->
      heroes: Hero.find({})
  @route 'crewSelection',
    path: '/crew_selection'
    waitOn: ->
      Meteor.subscribe 'allHeroes'
      Meteor.subscribe 'allCrewmembers'
    data: ->
      heroes: Heroes.find()
      crewmembers: Crewmember.find()
  @route 'summary',
    waitOn: ->
      Meteor.subscribe 'allHeroes'
      Meteor.subscribe 'allCrewmembers'
      Meteor.subscribe 'userData'
    data: ->
      hero: Meteor.user().hero,
      crewmembers: Crewmember.find({userId: Meteor.userId()})
