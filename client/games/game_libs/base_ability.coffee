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

    @_targets = []
    for target in data.action.to
      target.gameTeam = data.baseGame[target.gameTeamId]
      @_targets.push target

  play: ->
    if @_statesArr[0]
      @[@_statesArr[0]]()
    else
      @finishAnimation()

  finishPart: ->
    if @_parts == @_doneParts
      @_doneParts = 0
      @_statesArr.shift()
      @play()

  finishAnimation: ->
    player = GamePlayers.findOne
      gameId: @_action.gameId
      userId: Meteor.userId()
    GamePlayers.update
      _id: player._id
    ,
      $set:
        state: 'waiting'
        lastIndex: @_action.index

  pullweapon: ->
    @_parts = 1
    @_baseUnit._unit.animations.play "pullweapon", 20, false
    @_baseUnit._unit.events.onAnimationComplete.add (anim)->
      @_baseUnit._unit.events.onAnimationComplete.removeAll()
      @_doneParts++
      @finishPart()
    , @

  downweapon: ->
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
      tween = @_game.add.tween(ability).to({x: target.gameTeam._unit.center.x - 20, y: target.gameTeam._unit.center.y }, 400, Phaser.Easing.Quadratic.In, true, 0, false, false)
      tween.onComplete.add (tween)->
        this.scope.displayText(this.target, this.target.damage.toString())
        if this.target.hit
          this.scope.hit(this.target)
          this.target.gameTeam.setLifeLine(this.target.gameTeam.getCoordinates().x, this.target.gameTeam.getCoordinates().y, this.target.life)
        else
          this.scope._doneParts++
          this.scope.finishPart()
        tween.kill()
      , {target: target, scope: @}

  hit: (target)->
    explode = @_game.add.sprite(target.gameTeam.getCoordinates().x - 35, target.gameTeam.getCoordinates().y - 20, "explode")
    explode.animations.add "exploding"
    explode.animations.play "exploding", 20, false
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
        conditionName = Conditions.findOne({_id: this.scope._abilityData.conditionId}).name
        this.target.gameTeam._conditions.add(conditionName)
        this.scope._doneParts++
        tween.kill()
        this.scope.finishPart()
      , {target: target, scope: @}

  heal: ->
    @_parts = @_targets.length
    for target, index in @_targets
      ability = @_game.add.sprite(@_baseUnit._posX, @_baseUnit._posY, @_abilityData.name)
      ability.animations.add("shooting_" + index)
      ability.animations.play("shooting_" + index, 20, true)
      tween = @_game.add.tween(ability).to({x: target.gameTeam._unit.center.x - 20, y: target.gameTeam._unit.center.y }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
      tween.onComplete.add (tween)->
        this.scope.displayText(this.target, this.target.heal.toString())
        if this.target.hit
          this.scope.hit(this.target)
          this.target.gameTeam.setLifeLine(this.target.gameTeam.getCoordinates().x, this.target.gameTeam.getCoordinates().y, this.target.life)
        else
          this.scope._doneParts++
          this.scope.finishPart()
        tween.kill()
      , {target: target, scope: @}

  displayText: (target, value) ->
    style =
      font: "28px Arial bold"
      align: "center"

    if !target.hit
      style.fill = "#F28816"
    else if value > 0
      style.fill = "#ff0044"
    else
      style.fill = "#1CE81F"

    value = Math.abs(value)

    text = if target.hit then value else "Miss!"
    text += " " + "Crit!" if target.crit

    t = @_game.add.text(target.gameTeam._unit.center.x + 30,  target.gameTeam._unit.center.y, text, style);

    tween = @_game.add.tween(t).to({x: target.gameTeam._unit.center.x + 30, y: target.gameTeam._unit.center.y - 75}, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
    tween.onComplete.add (tween) ->
      setTimeout ->
        tween.text = ""
        tween.destroy()
      , 1500
    , @
