class @Sniper extends BaseUnit
  _name: 'sniper'
  _image: '/sprites/sniper.png'
  _json: '/sprites/sniper.json'

  constructor: (data) ->
    data.name = @_name
    data.image = @_image
    data.json = @_json
    super(data)
