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

Template.preSetting.rendered = ->
  $('.list').sortable(
    stop: (event,ui) ->
      el = ui.item.get(0)
      before = ui.item.prev().get(0)
      after = ui.item.next().get(0)

      unless before
        newRank = SimpleRationalRanks.beforeFirst after.getAttribute("data-prio")
      else if !after
        newRank = SimpleRationalRanks.afterLast before.getAttribute("data-prio")
      else
        newRank = SimpleRationalRanks.between before.getAttribute("data-prio"), after.getAttribute("data-prio")

      console.log newRank

      el.setAttribute("data-prio",newRank);
  )

SimpleRationalRanks =
  beforeFirst: (firstRank) ->
    console.log "beforeFirst"
    console.log parseInt(firstRank)-1
    return parseInt(firstRank)-1
  between: (beforeRank, afterRank) ->
    console.log "between"
    console.log ( parseInt(beforeRank) + parseInt(afterRank) ) / 2
    return ( parseInt(beforeRank) + parseInt(afterRank) ) / 2
  afterLast: (lastRank) ->
    console.log "lastrank"
    console.log parseInt(lastRank)+1
    return parseInt(lastRank)+1