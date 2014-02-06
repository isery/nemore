class @BaseLogic
	constructor: (data)->
    @_actions = data.actions
    @_gameID = data.game._id

    @_critFactor = 1.75

    ###
		@_targets = []
    for target in data.actions.to
      target.gameTeam = data.baseGame[target.gameTeamId]
      @_targets.push target
		###