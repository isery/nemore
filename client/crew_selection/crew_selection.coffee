Template.crewSelection.events
  'click .crew-selection': (e)->
   	heroId = $(e.target).prop('id')
    new Crewmember({userId: Meteor.userId(), heroId: heroId}).save()

  'click .crew-selected': (e)->
    _id = $(e.target).prop('id')
    Crewmember.remove(_id)

  'click #ready': (e)->
    Router.go 'summary'
