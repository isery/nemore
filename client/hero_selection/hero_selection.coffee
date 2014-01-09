Template.heroSelection.events
  'click .hero-selection': (e)->
    heroId = $(e.target).prop('id')
    Meteor.users.update({_id: Meteor.userId()}, {$set: {hero: heroId}})
    Router.go 'crewSelection'
