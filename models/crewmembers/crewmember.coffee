Crewmembers = new Meteor.Collection 'crewmembers'


class @Crewmember
  _maxCount: 10
  constructor: (options) ->
    @validate options
    @userId = options.userId
    @heroeId = options.heroeId
    @_id = options._id || null

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options
    throw new Meteor.Error 490, 'Undefined userId' unless options.userId
    throw new Meteor.Error 490, 'Undefined heroeId' unless options.heroeId

  validateSave: ->
    if Crewmembers.find({userId: @userId}).fetch().length + 1 > @_maxCount
      throw new Meteor.Error 490, 'Already enough heroes'

  user: ->
    Meteor.users.findOne({_id: @userId})

  heroe: ->
    Heroes.findOne({_id: @heroeId})

  save: ->
    @validateSave()
    @_id = Crewmembers.insert
      userId: @userId
      heroeId: @heroeId

  # For Meteor publish
  @all = ->
    crewmembers = Crewmembers.find()

  @findOne = (options = {}) ->
    crewmember = Crewmembers.findOne(options)
    new Crewmember(crewmember) if crewmember?

  @find = (options = {})->
    crewmembers = Crewmembers.find(options).fetch()
    new Crewmember(crewmember) for crewmember in crewmembers

  @count: ->
    Crewmembers.find({userId: Meteor.userId()}).fetch().length

  @remove: (_id)->
    Crewmembers.remove({_id: _id}) if _id?
