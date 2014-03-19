@Colors = new Meteor.Collection 'colors'
@Keys = new Meteor.Collection 'keys'
@ColorKeys  = new Meteor.Collection 'colorkeys'

class @Color
  constructor: (options) ->
    for key, value of options
      @[key] = value

  colorKeys: ->
    ColorKey.find
      colorId: @_id

  @find = (options = {})->
    colors = Colors.find(options).fetch()
    new Color(color) for color in colors

  @findOne = (options = {})->
    color = Colors.findOne(options)
    new Color(color)

class @Key
  constructor: (options) ->
    for key, value of options
      @[key] = value

  colorKeys: ->
    ColorKey.find
      keyId: @_id

  @find = (options = {})->
    keys = Keys.find(options).fetch()
    new Key(key) for key in keys

  @findOne = (options = {})->
    key = Keys.findOne(options)
    new Key(key)

class @ColorKey
  constructor: (options) ->
    for key, value of options
      @[key] = value

  condition: ->
    Conditions.findOne
      _id: @conditionId

  color: ->
    Color.findOne
      _id: @colorId
  key: ->
    Key.findOne
      _id: @keyId

  @find = (options = {})->
    colorKeys = ColorKeys.find(options).fetch()
    new ColorKey(colorKey) for colorKey in colorKeys

  @findOne = (options = {})->
    colorKey = ColorKeys.findOne(options)
    new ColorKey(colorKey)
