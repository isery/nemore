class @Sniper extends BaseUnit
  _name: 'sniper'
  _image: '/sprites/sniper.png'
  _json: '/sprites/sniper.json'

  constructor: (data) ->
    data.name = @_name
    data.image = @_image
    data.json = @_json
    super(data)

  addAnimation: ->
    @_unit.animations.add "idle", ["idle_1.png", "idle_2.png"], 2, true
    @_unit.animations.add "miss", ["miss_1.png", "miss_2.png", "miss_1.png"], 10, true
    @_unit.animations.add "hit", ["death_1.png", "death_2.png", "death_3.png", "death_2.png", "death_1.png"], 10, true
    @_unit.animations.add "death", ["death_1.png", "death_2.png", "death_3.png", "death_4.png", "death_5.png"], 10, true
    @_unit.animations.add("pullweapon", ["pullweapon_1.png", "pullweapon_2.png", "pulleweapon_3.png"], 30, false)
    @_unit.animations.add("downweapon", ["pullweapon_3.png", "pulleweapon_2.png", "pullweapon_1.png"], 30, false)
    @_unit.animations.add("idle_weapon", ["pullweapon_3.png"])

    @_unit.animations.play "idle"

