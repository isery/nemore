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

    if endGame
      hero = GameTeam.findOne({userId: Meteor.userId(), gameId: @_action.gameId, hero: true})
      if hero.life <= 0
        text = 'Defeat'
      else
        text = 'Victory'
      $('#base-game').append('<div id="end-game" class="' + text.toLowerCase() + '""><div>' + text + '</div><div id="finish-game">Continue</div> </div>')

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

      # shoot start position
      abilityOffsetX = 40
      abilityOffsetX = (abilityOffsetX - 50) * -1 unless GameTeam.findOne({_id: @_from}).userId == Meteor.userId()
      abilityOffsetY = 50

      ability = @_game.add.sprite(@_baseUnit._posX + abilityOffsetX, @_baseUnit._posY + abilityOffsetY, @_abilityData.name)
      ability.anchor.setTo(0.5,0.5)
      # Flip
      ability.scale.x *= -1
      # Scale
      ability.scale.x *= 0.7
      ability.scale.y *= 0.7

      ability.anchor.setTo(0,0)

      # Angle calc
      v1 =
        x: target.gameTeam._posX - @_baseUnit._posX
        y: target.gameTeam._posY + 40 - @_baseUnit._posY
      p1 = 1 * v1.x + 0 * v1.y
      p2 = Math.sqrt(Math.pow(1,2) + Math.pow(0, 2))
      p3 = Math.sqrt(Math.pow(v1.x,2) + Math.pow(v1.y, 2))
      p4 = p1/(p2*p3)
      p5 = Math.acos(p4) * (180/Math.PI)
      p5 = 360 - p5 if target.gameTeam._posY < @_baseUnit._posY
      ability.angle = p5

      ability.animations.add("shooting")
      ability.animations.play("shooting", 20, true)

      a1 = 0
      a1 = 40 unless @_baseGame.playerOne.hero.userId == Meteor.userId()
      tween = @_game.add.tween(ability).to({x: target.gameTeam._posX + a1, y: target.gameTeam._posY + 60 }, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)

      @_baseGame.sound_shot.play()

      tween.onComplete.add (tween)->
        this.scope.displayText(this.target, this.target.damage.toString())
        if this.target.hit
          if this.target.life <= 0
            target.gameTeam._unit.events.onAnimationComplete.removeAll()

            this.scope._baseGame.sound_death.play()

            target.gameTeam._unit.animations.play "death", 5, false
          else

            this.scope._baseGame.sound_hit.play()

            target.gameTeam._unit.animations.play "hit", 5, false
            target.gameTeam._unit.events.onAnimationComplete.add (anim) ->
              target.gameTeam._unit.animations.play "idle"
          this.scope.hit(this.target)

          this.target.gameTeam.setLifeLine(this.target.life)
        else

          this.scope._baseGame.sound_miss.play()

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
    # explode = @_game.add.sprite(target.gameTeam._lifePosX - 35, target.gameTeam._lifePoxY - 20, "explode")
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
      ability = @_game.add.sprite(target.gameTeam._posX - 20, target.gameTeam._posY, "buff")
      ability.animations.add("buffing")
      ability.animations.play("buffing", 30, false)

      @_baseGame.sound_buff.play()

      ability.events.onAnimationComplete.add (anim) ->
        conditionName = Conditions.findOne({_id: this.scope._abilityData.conditionId}).name
        this.target.gameTeam._conditions.add(conditionName)
        anim.kill()
        this.scope._doneParts++
        this.scope.finishPart()
      , {target: target, scope: @}

  heal: ->
    @_parts = @_targets.length
    for target, index in @_targets
      ability = @_game.add.sprite(@_baseUnit._posX - 20, @_baseUnit._posY, "heal")
      ability.animations.add("healing")
      ability.animations.play("healing", 30, false)

      @_baseGame.sound_heal.play()

      ability.events.onAnimationComplete.add (anim) ->
        this.scope.displayText(this.target, this.target.heal.toString())
        if this.target.hit
          this.scope.hit(this.target)
          this.target.gameTeam.setLifeLine(this.target.life)
        else
          this.scope._doneParts++
          this.scope.finishPart()
        anim.kill()
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

    t = @_game.add.text(target.gameTeam._posX,  target.gameTeam._posY, text.toString(), style)

    tween = @_game.add.tween(t).to({x: target.gameTeam._posX + 30, y: target.gameTeam._posY - 35}, 500, Phaser.Easing.Quadratic.In, true, 0, false, false)
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
