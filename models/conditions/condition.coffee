@Conditions = new Meteor.Collection 'conditions'
@GameTeamConditions = new Meteor.Collection 'gameTeamConditions'

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

