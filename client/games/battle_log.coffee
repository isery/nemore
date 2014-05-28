Template.battlelog.getActions = ->
  Actions.find({},{sort:{index: -1}}).fetch()

Template.battlelog.getFrom = ->
  GameTeam.findOne({_id: @from}).unit().name

Template.battlelog.getGameTeam = ->
  GameTeam.findOne({_id: @gameTeamId}).unit().name

Template.battlelog.getAbility = ->
  SpecialAbilities.findOne({_id: @abilityId}).specialName

Template.battlelog.getValue = ->
  if @damage >= 0
    return '(' + @damage + ' damage)'

  if Math.abs(@heal) >= 0
    return '(' + Math.abs(@heal) + ' healing)'

  '(buff)'

Template.battlelog.getValueClass = ->
  if @damage >= 0
    return 'damage'

  if Math.abs(@heal) >= 0
    return 'heal'

  'buff'

Template.battlelog.rendered = ->
  $(".battlelog").perfectScrollbar
    suppressScrollX: true