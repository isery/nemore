class @BaseAbility

  constructor: (data) ->
    @_parts = 1
    @_doneParts = 0
    @_action = data.action
    @_game = data.baseGame.game
    @_baseGame = data.baseGame
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


    # TODO handle end game
    endGame = Games.findOne
      _id: @_baseGame._id
      state: 'finished'

    console.log "END GAME" if endGame

  pullweapon: ->
    @_parts = 1
    @_baseUnit._unit.animations.play "pullweapon", 20, false
    @_baseUnit._unit.events.onAnimationComplete.add (anim)->
      @_baseUnit._unit.events.onAnimationComplete.removeAll()
      @_doneParts++
      @idle_weapon()
      @finishPart()
    , @

  downweapon: ->
    @_parts = 1
    @_baseUnit._unit.animations.play "downweapon", 20, false
    @_baseUnit._unit.events.onAnimationComplete.add (anim)->
      @_baseUnit._unit.events.onAnimationComplete.removeAll()
      @_doneParts++
      @idle()
      @finishPart()
    , @

  shoot: ->
    @_parts = @_targets.length
    for target, index in @_targets
      ability = @_game.add.sprite(@_baseUnit._posX, @_baseUnit._posY, @_abilityData.name)
      ability.anchor.setTo(0.5,0.5)
      # Flip
      ability.scale.x *= -1
      # Scale
      ability.scale.x *= 0.7
      ability.scale.y *= 0.7

      # Angle calc
      v1 =
        x: target.gameTeam._unit.x - @_baseUnit._posX
        y: target.gameTeam._unit.y + 40 - @_baseUnit._posY
      p1 = 1 * v1.x + 0 * v1.y
      p2 = Math.sqrt(Math.pow(1,2) + Math.pow(0, 2))
      p3 = Math.sqrt(Math.pow(v1.x,2) + Math.pow(v1.y, 2))
      p4 = p1/(p2*p3)
      p5 = Math.acos(p4) * (180/Math.PI)
      p5 = 360 - p5 if target.gameTeam._unit.y < @_baseUnit._posY
      ability.angle = p5

      ability.animations.add("shooting")
      ability.animations.play("shooting", 20, true)

      a1 = 0
      a1 = 40 unless @_baseGame.playerOne.hero.userId == Meteor.userId()
      tween = @_game.add.tween(ability).to({x: target.gameTeam._unit.x + a1, y: target.gameTeam._unit.y + 40 }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)

      tween.onComplete.add (tween)->
        this.scope.displayText(this.target, this.target.damage.toString())
        if this.target.hit
          if this.target.life <= 0
            target.gameTeam._unit.events.onAnimationComplete.removeAll()
            target.gameTeam._unit.animations.play "death", 5, false
          else
            target.gameTeam._unit.animations.play "hit", 5, false
            target.gameTeam._unit.events.onAnimationComplete.add (anim) ->
              target.gameTeam._unit.animations.play "idle"
          this.scope.hit(this.target)

          if (Meteor.userId() == GameTeam.findOne({_id: target.gameTeamId}).userId)
            this.target.gameTeam.setLifeLine(this.target.gameTeam.getCoordinates().x + this.scope._baseGame._playerOneSpriteOffset, this.target.gameTeam.getCoordinates().y, this.target.life)
          else
            this.target.gameTeam.setLifeLine(this.target.gameTeam.getCoordinates().x, this.target.gameTeam.getCoordinates().y, this.target.life)
        else
          target.gameTeam._unit.animations.play "miss", 5, false
          target.gameTeam._unit.events.onAnimationComplete.add (anim) ->
            target.gameTeam._unit.animations.play "idle"
          this.scope._doneParts++
          this.scope.finishPart()

        tween.kill()
      , {target: target, scope: @}

  hit: (target)->
    @_doneParts++
    @finishPart()
    # explode = @_game.add.sprite(target.gameTeam.getCoordinates().x - 35, target.gameTeam.getCoordinates().y - 20, "explode")
    # explode.animations.add "exploding"
    # explode.animations.play "exploding", 20, false
    # explode.events.onAnimationComplete.add (explode)->
    #   @_doneParts++
    #   explode.kill()
    #   @finishPart()
    # , @

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
      tween = @_game.add.tween(ability).to({x: target.gameTeam._unit.x - 20, y: target.gameTeam._unit.y }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
      tween.onComplete.add (tween)->
        this.scope.displayText(this.target, this.target.heal.toString())
        if this.target.hit
          this.scope.hit(this.target)
          if (Meteor.userId() == GameTeam.findOne({_id: target.gameTeamId}).userId)
            this.target.gameTeam.setLifeLine(this.target.gameTeam.getCoordinates().x + this.scope._baseGame._playerOneSpriteOffset, this.target.gameTeam.getCoordinates().y, this.target.life)
          else
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

    t = @_game.add.text(target.gameTeam._unit.x,  target.gameTeam._unit.y, text.toString(), style)

    tween = @_game.add.tween(t).to({x: target.gameTeam._unit.x + 30, y: target.gameTeam._unit.y - 35}, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
    tween.onComplete.add (tween) ->
      setTimeout ->
        tween.text = ""
        tween.destroy()
      , 1500
    , @

  idle: ->
    @_baseUnit._unit.animations.play "idle"

  idle_weapon: ->
    @_baseUnit._unit.animations.play "idle_weapon"
