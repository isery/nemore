class @PreSettingController extends RouteController

  before: ->
    if @getData().currentGame
      Router.isLoggedIn(@)
      _id = @params._id
      currentGame = @getData().currentGame
      userId = Meteor.userId()

      # TODO: Set player 2 if he joins through the url
      # if currentGame and !currentGame.player2 and userId is not currentGame.player1
      #   currentGame.setPlayer2(userId)

      if currentGame.state == "ready"
        Router.go 'games', _id: _id

  waitOn: ->
    Meteor.subscribe 'currentGame', @params._id
    Meteor.subscribe 'allUnits'
    Meteor.subscribe 'allTeams'
    Meteor.subscribe 'allSpecialAbilities'
    Meteor.subscribe 'allGameTeams', @params._id
    Meteor.subscribe 'allGamePlayers'
  data: ->
    currentGame: Game.findById(@params._id),
    gameTeams: GameTeam.find({userId: Meteor.userId()})


