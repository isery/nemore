class @PreSettingController extends RouteController

  before: ->
    if @ready()
      Router.isLoggedIn(@)
      _id = @params._id
      currentGame = Game.findById _id
      userId = Meteor.userId()
      if currentGame and !currentGame.player2 and userId is not currentGame.player1
        console.log "is 2nd player"
        currentGame.setPlayer2(userId)
  waitOn: ->
    Meteor.subscribe 'currentGame', @params._id
  data: ->
    currentGame: Game.findById @params._id