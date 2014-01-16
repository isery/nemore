@Actions = new Meteor.Collection 'actions'

class @Action
  constructor: (options) ->
    @validate options
    for key, value of options
      @[key] = value

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options

  validateSave: ->
    # ToDo

  save: ->
    # ToDo

  # For Meteor publish
  @all = ->
    actions = Actions.find({})

  @findOne = (options = {}) ->
    action = Actions.findOne(options)
    new Action(action) if action?

  @getId = ->
    @_id

  @findById = (id) ->
    action = Actions.findOne({_id:id})
    new Action(action) if action?

  @find = (options = {})->
    actions = Actions.find(options).fetch()
    new Action(action) for action in actions

  @count: ->
    Actions.find({}).fetch().length


  @remove: (options)->
    # ToDo