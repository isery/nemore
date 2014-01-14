class @PreSettingController extends RouteController

  before: ->
    if @getData().currentGame
      Router.isLoggedIn(@)
      _id = @params._id
      currentGame = @getData().currentGame
      userId = Meteor.userId()
      if currentGame and !currentGame.player2 and userId is not currentGame.player1
        currentGame.setPlayer2(userId)

      if currentGame and currentGame.player1_ready and currentGame.player2_ready
        Router.go 'games', _id: _id

      if currentGame && !GameTeam.find({userId: Meteor.userId(), gameId: currentGame._id}).length > 0
        new GameTeam({gameId: currentGame._id}).init()

  waitOn: ->
    Meteor.subscribe 'currentGame', @params._id
    Meteor.subscribe 'allUnits'
    Meteor.subscribe 'allTeams'
    Meteor.subscribe 'allSpecialAbilities'
    Meteor.subscribe 'allGameTeams', @params._id
  data: ->
    currentGame: Game.findById(@params._id),
    hero: Team.findOne({userId: Meteor.userId(), hero: true})
    gameTeams: GameTeam.find({userId: Meteor.userId()})


