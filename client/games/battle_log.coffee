Template.battlelog.getActions = ->
  Actions.find({},{sort:{index: -1}}).fetch()

Template.battlelog.getFrom = ->
  BaseGame._instance[@from]?._name

Template.battlelog.getGameTeam = ->
  BaseGame._instance[@gameTeamId]?._name

Template.battlelog.getAbility = ->
  SpecialAbilities.findOne({_id: @abilityId}).name

