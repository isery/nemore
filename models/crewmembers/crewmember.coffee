Crewmembers = new Meteor.Collection 'crewmembers'


class @Crewmember
  _max_count: 10
  constructor: (options) ->
    @validate options
    @userId = options.userId
    @heroeId = options.heroeId
    @create

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options
    throw new Meteor.Error 490, 'Undefined userId' unless options.userId
    throw new Meteor.Error 490, 'Undefined heroeId' unless options.heroeId
    if Crewmembers.find({userId: options.userId}).fetch().length >= @_max_count
      throw new Meteor.Error 490, 'Already enough heroes'

  create: ->
    Crewmembers.insert
      userId: @userId
      heroeId: @heroeId

  user: ->
    Meteor.users.findOne({_id: @userId})

  heroe: ->
    Heroes.findOne({_id: @heroeId})

  # For Meteor publish
  @all = ->
    crewmembers = Crewmembers.find()

  @findOne = (options) ->
    crewmember = Crewmembers.findOne(options)
    new Crewmember(crewmember) if crewmember?


  @find = (options)->
    crewmembers = Crewmembers.find(options).fetch()
    new Crewmember(crewmember) for crewmember in crewmembers
