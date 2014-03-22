@Conditions = new Meteor.Collection 'conditions'
@GameTeamConditions = new Meteor.Collection 'gameTeamConditions'

class @Condition
  constructor: (options) ->
    for key, value of options
      @[key] = value

  @find = (options = {})->
    conditions = Conditions.find(options).fetch()
    new Condition(condition) for condition in conditions

  @findOne = (options = {})->
    condition = Conditions.findOne(options)
    new Condition(condition)

class @GameTeamCondition
  constructor: (options) ->
    for key, value of options
      @[key] = value

  condition: ->
    {
      _id: @_id
      condition: Conditions.findOne({_id: @conditionId})
      leftDuration: @leftDuration
    }

  @find = (options = {})->
    gameTeamConditions = GameTeamConditions.find(options).fetch()
    new GameTeamCondition(gameTeamCondition) for gameTeamCondition in gameTeamConditions

