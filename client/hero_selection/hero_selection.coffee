Template.heroSelection.events
  'click .hero-selection': (e)->
    unitId = $(e.target).prop('id')
    new Team({userId: Meteor.userId(), unitId: unitId, hero: true}).save()
    Router.go 'crewSelection'