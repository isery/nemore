Crewmembers = new Meteor.Collection 'crewmembers'


class @Crewmember
  _maxCount: 10
  constructor: (options) ->
    @validate options
    for key, value of options
      @[key] = value

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options
    throw new Meteor.Error 490, 'Undefined userId' unless options.userId
    throw new Meteor.Error 490, 'Undefined heroId' unless options.heroId

  validateSave: ->
    if Crewmembers.find({userId: @userId}).fetch().length + 1 > @_maxCount
      throw new Meteor.Error 490, 'Already enough heroes'

  user: ->
    Meteor.users.findOne({_id: @userId})

  hero: ->
    Heroes.findOne({_id: @heroId})

  special_abilities: ->
    SpecialAbilities.find({hero_id: @heroId}).fetch()

  save: ->
    @validateSave()
    @_id = Crewmembers.insert
      userId: @userId
      heroId: @heroId

  # For Meteor publish
  @all = (userId)->
    crewmembers = Crewmembers.find({userId: userId})

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
