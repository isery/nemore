Template.preSetting.events
  'click #ready': (e)->
    console.log "clicked: ready"
    GameTeam.find(gameTeamId)
    Router.getData().currentGame.setReady(Meteor.userId())

  'click .choose_ability': (e)->
    specialAbilityId = $(e.target).data('id')
    gameTeamId = $(e.target).parent().data('id')
    GameTeam.update(gameTeamId, {specialAbilityId: specialAbilityId})


