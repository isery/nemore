Template.crewSelection.events
  'click .crew-selection': (e)->
    heroeId = $(e.target).prop('id')
    new Crewmember({userId: Meteor.userId(), heroeId: heroeId}).create()

  'click #ready': (e)->
    Router.go 'summary'
