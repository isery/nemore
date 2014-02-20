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
    console.log abilities
    for ability, index in abilities
      @_abilityId = ability._id
      @_priority = index
      @_id = AbilityPriorities.insert
        abilityId: ability._id
        teamId: @team._id
        priority: index

      new TargetPriority({abilityPriority: @}).init()
      new AbilityCondition({abilityPriority: @}).init()

# for every unit ability
# teamId
# abilityId
# priority

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

# for every unit
# abilityPriorityId
# unitId
# priority

class @AbilityCondition
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    condition = Conditions.findOne({name: 'always'})
    AbilityConditions.insert
      abilityPriorityId: @abilityPriority._id
      conditionId: condition._id


# targetPriorityId
# conditionId

class @Condition
  constructor: (options) ->
    for key, value of options
      @[key] = value

# possible Conditions
