class @PreSettingController extends RouteController

  before: ->
    if @getData().currentGame
      Router.isLoggedIn(@)
      _id = @params._id
      currentGame = @getData().currentGame
      userId = Meteor.userId()
      gamePlayers = GamePlayer.find({gameId: currentGame._id})
      if gamePlayers.length <= 1
        unless gamePlayers[0].userId is userId
          currentGame.setPlayer2(userId)
          newTeam = new GameTeam({gameId: currentGame._id}).init()
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
    gamePlayers: GamePlayer.find({userId: Meteor.userId()})
    currentGame: Game.findById(@params._id),
    gameTeams: GameTeam.find({userId: Meteor.userId()})


