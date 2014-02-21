@AbilityPriorities = new Meteor.Collection 'abilityPriority'
@TargetPriorities = new Meteor.Collection 'targetPriority'
@AbilityConditions = new Meteor.Collection 'abilityCondition'
@Conditions = new Meteor.Collection 'conditions'

class @AbilityPriority
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    abilities = @team.unit().specialAbilities()
    @_teamId = @team._id
    for ability, index in abilities
      @_abilityId = ability._id
      @_priority = index
      @_id = AbilityPriorities.insert
        abilityId: ability._id
        teamId: @team._id
        priority: index

      new TargetPriority({abilityPriority: @}).init()
      new AbilityCondition({abilityPriority: @}).init()

  ability: ->
    SpecialAbilities.findOne({_id: @abilityId})

  targetPriority: ->
    TargetPriority.find({abilityPriorityId: @_id})

  abilityCondition: ->
    AbilityCondition.findOne({abilityPriorityId: @_id})

  @find = (options = {})->
    abilityPriorities = AbilityPriorities.find(options).fetch()
    new AbilityPriority(abilityPriority) for abilityPriority in abilityPriorities

class @TargetPriority
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    units = Unit.find()
    for unit, index in units
      @_id = TargetPriorities.insert
        abilityPriorityId: @abilityPriority._id
        unitId: unit._id
        priority: index

  unit: ->
    Unit.findOne({_id: @unitId})

  @find = (options = {})->
    targetPriorities = TargetPriorities.find(options).fetch()
    new TargetPriority(targetPriority) for targetPriority in targetPriorities

class @AbilityCondition
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    condition = Conditions.findOne({name: 'always'})
    AbilityConditions.insert
      abilityPriorityId: @abilityPriority._id
      conditionId: condition._id

  condition: ->
    Conditions.findOne({_id: @conditionId})

  @findOne = (options = {}) ->
    abilityCondition = AbilityConditions.findOne(options)
    new AbilityCondition(abilityCondition)

class @Condition
  constructor: (options) ->
    for key, value of options
      @[key] = value

