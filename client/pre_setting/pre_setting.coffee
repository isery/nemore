Template.preSetting.events
  'click #ready': (e)->
    gameId = Router.getData().currentGame._id
    userId = Meteor.userId()
    gamePlayerId = GamePlayer.findOne({gameId: gameId,userId: userId})._id
    GamePlayer.update(gamePlayerId, {state: 'waiting'})
    bothReady = GamePlayer.bothReady(gameId)
    Router.getData().currentGame.setReady(Meteor.userId()) if bothReady

  'click .choose_ability': (e)->
    specialAbilityId = $(e.target).data('id')
    gameTeamId = $(e.target).parent().data('id')
    GameTeam.update(gameTeamId, {specialAbilityId: specialAbilityId})

Template.preSetting.created = ->
  Deps.autorun (deps) ->
    game = Games.findOne
      _id: Router.getData().currentGame._id
      state:
        $in: ["ready", "playing"]

    if game?
      Router.go 'games', _id: game._id
      deps.stop()