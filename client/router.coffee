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
