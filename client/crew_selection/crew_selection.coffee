Template.crewSelection.events
  'click .chooseUnit': (e)->
    unitId = $(e.target).data('chooseid')
    new Team({userId: Meteor.userId(), unitId: unitId}).save()


  'click .overlay': (e)->
    _id = $(e.currentTarget).data('removeid')
    Team.remove(_id)

  'click .crewMemberData': (e) ->
    if($(e.currentTarget).find(".crewMemberAbilities").hasClass("hideToggle"))
      $(e.currentTarget).parents(".crewMember").animate({"margin-right": "55px"})
      $(e.currentTarget).find(".crewMemberTable").animate({width: 'toggle'}, ->
        $(e.currentTarget).find(".abilityTable tr").each (index, element) ->
          $(element).toggleClass("visibilityToggle")
      )
      $(e.currentTarget).find(".crewMemberAbilities").toggleClass("hideToggle");
    else
      $(e.currentTarget).find(".abilityTable tr").each (index, element) ->
        $(element).toggleClass("visibilityToggle")
      $(e.currentTarget).parents(".crewMember").animate({"margin-right": "100px"})
      $(e.currentTarget).find(".crewMemberTable").animate({width: 'toggle'})
      $(e.currentTarget).find(".crewMemberAbilities").toggleClass("hideToggle");

  #'click #ready': (e)->
  #  Router.go 'summary'

Template.crewSelection.rendered = ->
  $(".unitData, .crewMemberAvatar").each (idx, element) =>
    $(element).css
      height: $(element).parents(".crewMember").height()



Template.showSelectedCrewLeft.heroImage = ->
  Router.getData().hero?.unit().name
