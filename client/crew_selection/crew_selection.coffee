Template.crewSelection.events
  'click .crewMemberAvatar': (e)->
    unitId = $(e.target).prop('id')
    new Team({userId: Meteor.userId(), unitId: unitId}).save()


  'click .removeCrewMember': (e)->
    _id = $(e.currentTarget).prop('id')
    Team.remove(_id)

  'click #ready': (e)->
    Router.go 'summary'

  'click .btn-8g': (e)->
    $(e.currentTarget).addClass 'btn-success3d'
    #setTimeout (->
    #  $(e.currentTarget).removeClass 'btn-success3d'
    #), 1000

Template.crewSelection.rendered = ->
  $('.container').addClass("georgcontainer")
	$('.crewMemberData').perfectScrollbar
		suppressScrollX: true

Template.showSelectedCrewLeft.heroImage = ->
  Router.getData().hero?.unit().name