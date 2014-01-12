Teams = new Meteor.Collection 'teams'

class @Team
  _maxCount: 10
  constructor: (options) ->
    @validate options
    for key, value of options
      @[key] = value

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options
    throw new Meteor.Error 490, 'Undefined userId' unless options.userId
    throw new Meteor.Error 490, 'Undefined unitId' unless options.unitId

  validateSave: ->
    if Teams.find({userId: @userId}).fetch().length + 1 > @_maxCount
      throw new Meteor.Error 490, 'Already enough units'

  user: ->
    Meteor.users.findOne({_id: @userId})

  unit: ->
    Units.findOne({_id: @unitId})

  special_abilities: ->
    SpecialAbilities.find({unit_id: @unitId}).fetch()

  save: ->
    @validateSave()
    @_id = Team.findOne({userId: @userId, hero: true})?._id
    if @hero && @_id
      Teams.update
        _id: @_id
      ,
        $set:
          userId: @userId
          unitId: @unitId
          hero: @hero
    else
      @_id = Teams.insert
        userId: @userId
        unitId: @unitId
        hero: @hero

  # For Meteor publish
  @all = (userId)->
    Teams.find({userId: userId})

  @findOne = (options = {}) ->
    team = Teams.findOne(options)
    new Team(team) if team?

  @find = (options = {})->
    teams = Teams.find(options).fetch()
    new Team(team) for team in teams

  @count: ->
    Teams.find({userId: Meteor.userId()}).fetch().length

  @remove: (_id)->
    Teams.remove({_id: _id}) if _id?


