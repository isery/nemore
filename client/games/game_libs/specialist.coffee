class @Specialist extends BaseUnit
  _name: 'specialist'
  _image: '/sprites/specialist.png'
  _json: '/sprites/specialist.json'

  constructor: (data) ->
    data.name = @_name
    data.image = @_image
    data.json = @_json
    super(data)
