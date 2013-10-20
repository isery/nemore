Crewmembers = new Meteor.Collection 'crewmembers'


class @Crewmember
  constructor: (options) ->
    @validate options
    @userId = options.userId
    @heroeId = options.heroeId
    @create

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options
    throw new Meteor.Error 490, 'Undefined userId' unless options.userId
    throw new Meteor.Error 490, 'Undefined heroeId' unless options.heroeId
    throw new Meteor.Error 490, 'Already enough heroes' if Crewmembers.find({userId: options.userId}).fetch().length >= 9

  create: ->
    Crewmembers.insert
      userId: Meteor.userId()
      heroeId: @heroeId

  user: ->
    Meteor.users.findOne({_id: @userId})

  heroe: ->
    Heroe.findOne({_id: @heroeId})

  @all = ->
    crewmembers = Crewmembers.find()

  @findOne = (options) ->
    crewmember = Crewmembers.find(options).fetch()
    new Crewmember(crewmember) if crewmember?


  @find = (options) ->
    crewmembers = Crewmembers.find(options).fetch()
    new Crewmember(crewmember) for crewmember in crewmembers
