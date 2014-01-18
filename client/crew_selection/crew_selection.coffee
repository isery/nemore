Template.crewSelection.events
  'click .crewMemberAvatar': (e)->
    unitId = $(e.target).prop('id')
    new Team({userId: Meteor.userId(), unitId: unitId}).save()

  'click .removeCrewMember': (e)->
    _id = $(e.currentTarget).prop('id')
    Team.remove(_id)

  'click #ready': (e)->
    Router.go 'summary'

Template.crewSelection.rendered = ->
	$('.crewMemberData').perfectScrollbar
		suppressScrollX: true