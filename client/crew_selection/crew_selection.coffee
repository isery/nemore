Template.crewSelection.events
  'click .crew-selection': (e)->
    unitId = $(e.target).prop('id')
    new Team({userId: Meteor.userId(), unitId: unitId}).save()

  'click .crew-selected': (e)->
    _id = $(e.target).prop('id')
    Team.remove(_id)

  'click #ready': (e)->
    Router.go 'summary'
