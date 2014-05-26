@AbilityPriorities = new Meteor.Collection 'abilityPriority'
@TargetPriorities = new Meteor.Collection 'targetPriority'
@AbilityTerms = new Meteor.Collection 'abilityTerm'
@Terms = new Meteor.Collection 'terms'

class @AbilityPriority
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    abilities = @team.unit().specialAbilities()
    @_teamId = @team._id
    for ability, index in abilities
      @_abilityId = ability._id
      @_id = AbilityPriorities.insert
        abilityId: ability._id
        teamId: @team._id
        priority: index

      new TargetPriority({abilityPriority: @}).init()
      new AbilityTerm({abilityPriority: @}).init()

  specialAbility: ->
    SpecialAbilities.findOne({_id: @abilityId})

  targetPriority: ->
    TargetPriority.find({abilityPriorityId: @_id}, {sort: {priority: 1}})

  abilityTerm: ->
    AbilityTerm.findOne({abilityPriorityId: @_id})

  @find = (options = {}, otherOptions = {})->
    abilityPriorities = AbilityPriorities.find(options, otherOptions).fetch()
    new AbilityPriority(abilityPriority) for abilityPriority in abilityPriorities

  @update = (_id, options) ->
    AbilityPriorities.update
      _id: _id
    ,
      $set:
        options
  @delete = (_id) ->
    AbilityPriorities.remove
      _id: _id

class @TargetPriority
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    units = Unit.find()
    lastIndex = 0
    for unit, index in units
      lastIndex = index
      @_id = TargetPriorities.insert
        abilityPriorityId: @abilityPriority._id
        unitId: unit._id
        priority: index

    @_id = TargetPriorities.insert
      abilityPriorityId: @abilityPriority._id
      unitId: "Hero"
      priority: lastIndex + 1

    @_id = TargetPriorities.insert
      abilityPriorityId: @abilityPriority._id
      unitId: "Random"
      priority: lastIndex + 2


  unit: ->
    Unit.findOne({_id: @unitId})

  @find = (options = {}, otherOptions = {})->
    targetPriorities = TargetPriorities.find(options, otherOptions).fetch()
    new TargetPriority(targetPriority) for targetPriority in targetPriorities

  @update = (_id, options) ->
    test = TargetPriorities.update
      _id: _id
    ,
      $set:
        options

class @AbilityTerm
  constructor: (options) ->
    for key, value of options
      @[key] = value

  init: ->
    term = Terms.findOne({name: 'always'})
    AbilityTerms.insert
      abilityPriorityId: @abilityPriority._id
      termId: term._id

  term: ->
    Terms.find({_id: @termId})

  @findOne = (options = {}) ->
    abilityTerm = AbilityTerms.findOne(options)
    new AbilityTerm(abilityTerm)

  @update = (_id, options) ->
    test = AbilityTerms.update
      _id: _id
    ,
      $set:
        options

class @Term
  constructor: (options) ->
    for key, value of options
      @[key] = value
