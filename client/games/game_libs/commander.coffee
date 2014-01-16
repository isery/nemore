class @Commander extends BaseUnit
  _name: 'commander'
  _image: '/sprites/commander.png'
  _json: '/sprites/commander.json'

  constructor: (data) ->
    data.name = @_name
    data.image = @_image
    data.json = @_json
    super(data)
