Template.heroeSelection.events
  'click .heroe-selection': (e)->
    heroeId = $(e.target).prop('id')
    Meteor.users.update({_id: Meteor.userId()}, {$set: {heroe: heroeId}})
    Router.go 'crewSelection'
