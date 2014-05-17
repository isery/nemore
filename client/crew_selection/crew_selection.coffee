Template.crewSelection.events
  'click .chooseUnit': (e)->
    unitId = $(e.target).data('chooseid')
    new Team({userId: Meteor.userId(), unitId: unitId}).save()


  'click .overlay': (e)->
    _id = $(e.currentTarget).data('removeid')
    Team.remove(_id)

  'click .crewMemberData': (e) ->
    if($(e.currentTarget).find(".crewMemberAbilities").hasClass("hideToggle"))
      $(e.currentTarget).prev().add($(e.currentTarget).prev().prev()).each (index, element) =>
        $(element).stop().animate
          right: $(element).parents(".crewMember").width()-$(element).width()

      $(e.currentTarget).find(".crewMemberTable").stop().animate
        right: ($(e.currentTarget).parents(".crewMember").width() - $(e.currentTarget).prev().height() - $(e.currentTarget).prev().prev().height() - $(e.currentTarget).find(".crewMemberTable").width() + 5)
      , ->
        $(e.currentTarget).find(".crewMemberTable").css
          "z-index": 20

      $(e.currentTarget).find(".abilityTable tr").each (index, element) ->
        $(element).toggleClass("visibilityToggle")

      $(e.currentTarget).find(".crewMemberAbilities").toggleClass("hideToggle");

    else
      $(e.currentTarget).prev().add($(e.currentTarget).prev().prev()).each (index, element) =>
        $(element).stop().animate
          right: 0

      $(e.currentTarget).find(".crewMemberTable").css
        "z-index": 0

      $(e.currentTarget).find(".crewMemberTable").stop().animate
        right: $(e.currentTarget).find(".crewMemberTable").data('initial')


      $(e.currentTarget).find(".abilityTable tr").each (index, element) ->
        $(element).toggleClass("visibilityToggle")

      $(e.currentTarget).find(".crewMemberAbilities").toggleClass("hideToggle");

  'click .readyButton': (e)->
    Router.go 'summary'

Template.crewSelection.rendered = ->
  $(".unitData, .crewMemberAvatar").each (idx, element) =>
    $(element).css
      height: $(element).parents(".crewMember").height()

  $(".crewMemberTable").each (idx, element) =>
    initialRightValue = 0 - $(element).find(".unitData").width() - $(element).find(".crewMemberAbilities").height() - $(element).find(".abilityTable").width() + $(element).next().width() - 24
    $(element).attr('data-initial', initialRightValue);
    $(element).css
      right: initialRightValue

Template.showSelectedCrewLeft.heroImage = ->
  Router.getData().hero?.unit().name
