@Units = new Meteor.Collection 'unit'

class @Unit
  constructor: (options) ->
    for key, value of options
      @[key] = value

  specialAbilities: ->
    abilities = SpecialAbilities.find({unitId: @_id}).fetch()

  # For Meteor publish
  @all = ->
    Units.find({})

  @findOne = (options = {}) ->
    unit = Units.findOne(options)
    new Unit(unit)

  @find = (options = {})->
    Units.find(options).fetch()
