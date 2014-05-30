@Teams = new Meteor.Collection 'teams'

class @Team
  _maxCount: 5
  _priorityIndex = 0
  constructor: (options) ->
    @validate options
    for key, value of options
      @[key] = value

  validate: (options) ->
    throw new Meteor.Error 490, 'No options passed' unless options
    throw new Meteor.Error 490, 'Undefined userId' unless options.userId
    throw new Meteor.Error 490, 'Undefined unitId' unless options.unitId

  validateSave: ->
    if Teams.find({userId: @userId}).fetch().length + 1 > @_maxCount && !@hero
      throw new Meteor.Error 490, 'Already enough units'

  user: ->
    Meteor.users.findOne({_id: @userId})

  unit: ->
    Unit.findOne({_id: @unitId})

  special_abilities: ->
    SpecialAbilities.find({unitId: @unitId}).fetch()

  abilityPriorities: ->
    AbilityPriority.find({teamId: @_id}, {sort: {priority: 1}})

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
          priority: _priorityIndex
      _priorityIndex++
      oldAbilities = AbilityPriority.find({teamId:@_id})
      AbilityPriority.delete(abilityPriority._id) for abilityPriority in oldAbilities
      new AbilityPriority({team: @}).init()
    else
      @_id = Teams.insert
        userId: @userId
        unitId: @unitId
        hero: @hero
        priority: _priorityIndex
      _priorityIndex++
      new AbilityPriority({team: @}).init()

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
    _priorityIndex--
    Teams.remove({_id: _id}) if _id?

  @priorityList = (userId) ->
    team = Team.find({userId: userId})
    team.map (member)->
      abilityPriorities = AbilityPriorities.find({teamId: member._id}, {sort: {priority: 1}})
      abilityPriority = abilityPriorities.map (abilityPriority) ->
        tmp =
          abilityPriority: abilityPriority
          targetPriorities: TargetPriorities.find({abilityPriorityId: abilityPriority._id}, {sort: {priority: 1}}).fetch()
          abilityTerm: AbilityTerms.find({abilityPriorityId: abilityPriority._id}).fetch()
      tmp =
        team: member
        abilityPriority: abilityPriority
