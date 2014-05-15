delay = (ms, func) -> setTimeout func, ms

Template.heroSelection.rendered = ->
  $(".heroRowUl li:not(.active) .heroStatsTable").css({"width": "100%"})

Template.heroSelection.events
  'click .hero-selection': (e)->

  'click .heroRowUl li': (e) ->
    if $(e.target).hasClass "chooseHero"
      unitId = $(e.target).data('chooseid')
      new Team({userId: Meteor.userId(), unitId: unitId, hero: true}).save()
      Router.go 'crewSelection'

    else
      $(".heroRowUl li").removeClass "active"
      $(e.currentTarget).addClass "active"
      $("body").addClass "show-x"
      $(e.currentTarget).find(".heroStatsTable").animate({"width": "auto"})
      $(e.currentTarget).find(".chooseHero").css({"width": "100%"})
      $(e.currentTarget).find(".heroStatsTable tr:not(:first-child) div").each (index, element) =>
        $(element).slideDown()
      $(e.currentTarget).find(".heroAbilityTable").delay(500).animate({width: 'toggle'}, ->
        $("li.active").find(".heroAbilityTable tr:not(:first-child) div").each (index, element) =>
          $(element).css("visibility", "visible");
          $(element).slideDown()
      )

  'click span.close' :(e) ->
    $ref = $(".heroRowUl li.active")
    delay 150, ->
      $ref.find(".heroAbilityTable").hide()
      $ref.find(".heroStatsTable").animate({"width": "100%"})
      $ref.find(".heroStatsTable tr:not(:first-child) div, .heroAbilityTable tr:not(:first-child) div").each (index, element) =>
        $(element).slideUp()
      $ref.find(".heroAbilityTable tr:not(:first-child) div").each (index, element) =>
          $(element).css("visibility", "hidden");

    $(".heroRowUl li.active").removeClass "active"
    $("body").removeClass "show-x"