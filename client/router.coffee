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
	@route 'heroes',
		path: '/heroes',
		data: ->
			allHeroes: Heroe.find().fetch()


