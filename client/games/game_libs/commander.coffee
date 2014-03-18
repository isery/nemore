class @Commander extends BaseUnit
  _name: 'commander'
  _image: '/sprites/commander.png'
  _json: '/sprites/commander.json'

  constructor: (data) ->
    data.name = @_name
    data.image = @_image
    data.json = @_json
    super(data)

  addAnimation: ->
    @_unit.animations.add "idle", ["a.png"], 30, true
    @_unit.animations.add("pullweapon", ["a.png", "b.png", "c.png"], 30, false)
    @_unit.animations.add("downweapon", ["c.png", "b.png", "a.png"], 30, false)
    @_unit.animations.add("idle_weapon", ["c.png"])

    @_unit.animations.play "idle"
