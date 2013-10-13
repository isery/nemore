Router.configure
  layout: 'layout',
  notFoundTemplate: 'notFound',
  loadingTemplate: 'loading'

Router.map ->
  @route 'home', path: '/'
  @route 'gamerooms',
    waitOn: -> Meteor.subscribe 'allGames',
    data: ->
      currentOpenGames: Game.find().fetch()
  @route 'games',
    path: '/games/:_id',
    waitOn: -> Meteor.subscribe 'allGames',
    data: ->
      game: Game.findOne _id: @params._id
  @route 'heroeSelection',
    path: '/heroe_selection'
    waitOn: -> Meteor.subscribe 'allHeroes',
    data: ->
      heroes: Heroe.find()
  @route 'crewSelection',
    path: '/crew_selection'
    waitOn: -> Meteor.subscribe 'allHeroes',
    data: ->
      heroes: Heroe.find()
