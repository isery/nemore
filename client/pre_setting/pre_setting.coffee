Template.preSetting.events
  'click #ready': (e)->
    gameId = Router.getData().currentGame._id
    userId = Meteor.userId()
    gamePlayerId = GamePlayer.findOne({gameId: gameId,userId: userId})._id
    GamePlayer.update(gamePlayerId, {state: 'waiting'})
    bothReady = GamePlayer.bothReady(gameId)
    Router.getData().currentGame.setReady(Meteor.userId()) if bothReady

  'click .unitDataAbilities > ul > li': (e) ->
    $this = $(e.currentTarget)
    $parentContainer = $this.parents(".oneUnitContainer")
    $unitAbilityTargetsList = $this.parents(".oneUnitContainer").find(".unitAbilityTargets > ul")
    $abilityConditionOptions = $this.parents(".oneUnitContainer").find(".selectAbilityTerm")
    $unitAbilityTargetsList.empty()
    $abilityConditionOptions.empty()

    if($this.hasClass("active"))
      $this.find(".arrow").stop().fadeOut()

      $parentContainer.find(".unitAbilityContainer, .unitAbilityCondition").each (index, element) ->
        $(element).stop().animate
          "width": "toggle"

      $this.removeClass("active")
    else
      $parentContainer.find(".active").each (index, element) ->
        $(element).removeClass("active")
        $parentContainerActive = $(element).parents(".oneUnitContainer")
        $parentContainerActive.find(".unitAbilityContainer, .unitAbilityCondition").each (index, element) ->
          $(element).stop(false, true).animate
            "width": "toggle"
        $(element).find(".arrow").stop(false, true).fadeOut()


      $this.addClass("active")

      $this.find(".arrow").css
        "border-width" : ""+($this.height() / 2)+"px 0px "+($this.height() / 2)+"px "+ ($parentContainer.width() / 100 * 2)+"px"
      .stop(false, true).fadeIn()

      for targetPriority in @targetPriority()
        targetListElement = UI.renderWithData(Template.preSettingTargetList, targetPriority)
        UI.insert(targetListElement, $unitAbilityTargetsList[0])

      for term in Terms.find().fetch()
        termOption = UI.renderWithData(Template.preSettingAbilityConditions, term)
        UI.insert(termOption, $abilityConditionOptions[0])

      $parentContainer.find(".unitAbilityContainer, .unitAbilityCondition").each (index, element) ->
        $(element).stop(false, true).animate
          "width": "toggle"

Template.preSetting.created = ->
  Deps.autorun (deps) ->
    Session.set 'currentGameId', Router.getData()?.currentGame?._id
    game = Games.findOne
      _id: Router.getData()?.currentGame?._id
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

  $('.selectAbilityTerm').change(->
      console.log "changed"
      console.log $(this).find(':selected').data('termId')
      console.log $(this).find(':selected').data('AbilityPriorityId')
      termId = $(this).find(':selected').data('termId')
      abilityPriorityId = $(this).find(':selected').data('abilityPriorityId')
      id = AbilityTerm.find({abilityPriorityId : abilityPriorityId})
      console.log window
      console.log id
      #AbilityTerm.update(id, {termId : termId})
    )

Template.preSetting.destroyed = ->
  gameId = Session.get('currentGameId')
  playerCount = GamePlayer.find({gameId: gameId}).length
  Game.findOne({_id: gameId}).destroy() if playerCount <= 1

Template.preSettingTargetList.checkHeroOrRandom = ->
  if (@unitId is "Hero") or (@unitId is "Random")
    return true
  else
    return false

SimpleRationalRanks =
  beforeFirst: (firstRank) ->
    return parseFloat(firstRank)-1
  between: (beforeRank, afterRank) ->
    return ( parseFloat(beforeRank) + parseFloat(afterRank) ) / 2
  afterLast: (lastRank) ->
    return parseFloat(lastRank)+1
