class @BaseAbility
  _parts: 1
  _doneParts: 0

  constructor: (data) ->
    @_action = data.action
    @_game = data.baseGame.game
    @_baseUnit = data.baseGame[data.action.from]
    @_abilityData = SpecialAbilities.findOne({_id: data.action.abilityId})
    @_statesArr = @_abilityData.states
    @_from = data.action.from

    # init targets here
    @_targets = []
    for target in data.action.to
      target.gameTeam = data.baseGame[target.gameTeamId]
      @_targets.push target

  play: ->
    console.log "Play"
    if @_statesArr[0]
      @[@_statesArr[0]]()
    else
      @finishAnimation()

  finishPart: ->
    console.log "finishPart"
    if @_parts == @_doneParts
      @_doneParts = 0
      @_statesArr.shift()
      @play()

  finishAnimation: ->
    console.log "Finish Animation"
    player = GamePlayers.findOne
      gameId: @_action.gameId
      userId: Meteor.userId()
    GamePlayers.update
      _id: player._id
    ,
      $set:
        state: 'waiting'
        lastIndex: @_action.index

    console.log "Updated at: " + new Date()

  pullweapon: ->
    console.log "Pullweapon"
    @_parts = 1
    @_baseUnit._unit.animations.play "pullweapon", 20, false
    @_baseUnit._unit.events.onAnimationComplete.add (anim)->
      @_baseUnit._unit.events.onAnimationComplete.removeAll()
      @_doneParts++
      @finishPart()
    , @

  downweapon: ->
    console.log "Downweapon"
    @_parts = 1
    @_baseUnit._unit.animations.play "downweapon", 20, false
    @_baseUnit._unit.events.onAnimationComplete.add (anim)->
      @_baseUnit._unit.events.onAnimationComplete.removeAll()
      @_doneParts++
      @finishPart()
    , @

  shoot: ->
    @_parts = @_targets.length
    for target, index in @_targets
      ability = @_game.add.sprite(@_baseUnit._posX, @_baseUnit._posY, @_abilityData.name)
      ability.animations.add("shooting_" + index)
      ability.animations.play("shooting_" + index, 20, true)
      tween = @_game.add.tween(ability).to({x: target.gameTeam._unit.center.x - 20, y: target.gameTeam._unit.center.y }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
      tween.onComplete.add (tween)->
        target.x = tween.x
        target.y = tween.y
        @displayText(target)
        if target.hit
          @hit({x: tween.x, y: tween.y, damage: target.damage, hit: target.hit, crit: target.crit, gameTeam: target.gameTeam})
        else
          @_doneParts++
          @finishPart()
        tween.kill()
      , @

  hit: (target)->
    explode = @_game.add.sprite(target.gameTeam.getCoordinates().x - 25, target.gameTeam.getCoordinates().y - 20, "explode")
    explode.animations.add "exploding"
    explode.animations.play "exploding", 10, false
    explode.events.onAnimationComplete.add (explode)->
      @_doneParts++
      explode.kill()
      @finishPart()
    , @

  buff: ->
    @_parts = @_targets.length
    for target, index in @_targets
      ability = @_game.add.sprite(target.gameTeam.getCoordinates().x, target.gameTeam.getCoordinates().y, "buff")
      tween = @_game.add.tween(ability).to({x: target.gameTeam.getCoordinates().x, y: target.gameTeam.getCoordinates().y + 20}, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
      tween.onComplete.add (tween)->
        @_doneParts++
        tween.kill()
        @finishPart()
      , @

  displayText: (target) ->
    console.log "displayText"
    text = if target.hit then target.damage.toString() else "Miss!"
    text += " " + "Crit!" if target.crit
    style =
      font: "28px Arial bold"
      fill: "#ff0044"
      align: "center"

    t = @_game.add.text(target.gameTeam._unit.center.x - 15,  target.gameTeam._unit.center.y, text, style);

    tween = @_game.add.tween(t).to({x: target.gameTeam._unit.center.x - 15, y: target.gameTeam._unit.center.y - 75}, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
    tween.onComplete.add (tween) ->
      setTimeout ->
        tween.text = ""
        tween.destroy()
      , 2000
    , @
