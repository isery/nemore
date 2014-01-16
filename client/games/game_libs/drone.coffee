class @Drone extends BaseUnit
  _name: 'drone'
  _image: '/sprites/drone.png'
  _json: '/sprites/drone.json'

  constructor: (data) ->
    data.name = @_name
    data.image = @_image
    data.json = @_json
    super(data)
