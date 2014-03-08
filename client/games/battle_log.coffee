Template.battlelog.getActions = ->
  tmp = Actions.find({},{sort:{index: -1}}).fetch()
  console.log tmp
  tmp

Template.battlelog.getFrom = ->
  BaseGame._instance[@from]?._name

Template.battlelog.getGameTeam = ->
  BaseGame._instance[@gameTeamId]?._name

Template.battlelog.getAbility = ->
  SpecialAbilities.findOne({_id: @abilityId}).name

