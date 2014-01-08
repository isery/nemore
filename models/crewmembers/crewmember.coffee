Crewmembers = new Meteor.Collection 'crewmembers'


class @Crewmember
  _max_count: 10
  constructor: (options) ->
    @validate options
    @userId = options.userId
    @heroId = options.heroId
    @create

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options
    throw new Meteor.Error 490, 'Undefined userId' unless options.userId
    throw new Meteor.Error 490, 'Undefined heroeId' unless options.heroId
    if Crewmembers.find({userId: options.userId}).fetch().length >= @_max_count
      throw new Meteor.Error 490, 'Already enough heroes'

  create: ->
    Crewmembers.insert
      userId: @userId
      heroId: @heroId

  user: ->
    Meteor.users.findOne({_id: @userId})

  hero: ->
    Heroes.findOne({_id: @heroId})

  # For Meteor publish
  @all = ->
    crewmembers = Crewmembers.find()

  @findOne = (options) ->
    crewmember = Crewmembers.findOne(options)
    new Crewmember(crewmember) if crewmember?


  @find = (options)->
    crewmembers = Crewmembers.find(options).fetch()
    new Crewmember(crewmember) for crewmember in crewmembers
