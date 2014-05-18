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

  'click .open-sub': (e) ->
    if $(e.target).hasClass("selectBar")
      return
    $('li.dropdown').removeClass('open')
    specialAbilityId = $(e.target).data('id')
    Session.set "open-sub", specialAbilityId
    $(e.target).addClass("open")

    element = e.target.parentNode
    offset = $(element).offset()
    posY = offset.top - $(window).scrollTop()
    posX = offset.left - $(window).scrollLeft()
    elemWidth = $(element).width()
    $(".selectBar").css "visibility", "hidden"
    $(e.target.children[2]).css "visibility", "visible"
    elem2Width = $(".middleList").width()
    $(".middleList").attr "style", "top: 20px; left: "+parseInt(elemWidth+20)+"px !important;"
    $(".selectBar").css "top", 80
    $(".selectBar").css "left", elemWidth + 80 + elem2Width

Template.preSetting.created = ->
  Deps.autorun (deps) ->
    game = Games.findOne
      _id: Router.getData().currentGame?._id
      state:
        $in: ["ready", "playing"]

    if game?
      Router.go 'games', _id: game._id
      deps.stop()

Template.preSetting.checkHeroOrRandom = ->
  if (@unitId is "Hero") or (@unitId is "Random")
    return true
  else
    return false

Template.preSetting.rendered = ->
  $('li[data-id='+Session.get("open-sub")+']').addClass("open")
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

      model =  el.getAttribute("data-model")
      modelId = el.getAttribute("data-id")
      movedObject = window[model].update(modelId, {priority : newRank})
      if model is "TargetPriority"
        id = window[model].find(modelId)[0].abilityPriorityId
        modelItems = window[model].find({abilityPriorityId:id},{sort: {priority: 1}})
      else if model is "GameTeam"
        id = window[model].find(modelId)[0].gameId
        modelItems = window[model].find({gameId:id},{sort: {priority: 1}})
      else if model is "AbilityPriority"
        id = window[model].find(modelId)[0].teamId
        modelItems = window[model].find({teamId:id},{sort: {priority: 1}})
      for i of modelItems
        modelId = modelItems[i]._id
        window[model].update(modelId, {priority : parseInt(i)})
  )

SimpleRationalRanks =
  beforeFirst: (firstRank) ->
    return parseFloat(firstRank)-1
  between: (beforeRank, afterRank) ->
    return ( parseFloat(beforeRank) + parseFloat(afterRank) ) / 2
  afterLast: (lastRank) ->
    return parseFloat(lastRank)+1


