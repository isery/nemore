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
    console.log "here"
    console.log abilities
    for ability, index in abilities
      @_abilityId = ability._id
      @_priority = index
      @_id = AbilityPriorities.insert
        abilityId: ability._id
        teamId: @team._id
        priority: index

      new TargetPriority({abilityPriority: @}).init()
      new AbilityTerm({abilityPriority: @}).init()

  ability: ->
    SpecialAbilities.findOne({_id: @abilityId})

  targetPriority: ->
    TargetPriority.find({abilityPriorityId: @_id})

  abilityTerm: ->
    AbilityTerm.findOne({abilityPriorityId: @_id})

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
    Terms.findOne({_id: @termId})

  @findOne = (options = {}) ->
    abilityTerm = AbilityTerms.findOne(options)
    new AbilityTerm(abilityTerm)

class @Term
  constructor: (options) ->
    for key, value of options
      @[key] = value

