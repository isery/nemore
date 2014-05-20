Template.summary.heroImage = ->
  Router.getData()?.hero?.unit().name

Template.summary.events
  'click .continue': (e)->
    Router.go 'gamerooms'

  'click .heroSelection': (e)->
    Router.go 'heroSelection'

  'click .crewSelection': (e)->
    Router.go 'crewSelection'

Template.summary.rendered = ->
  # Meteor.defer ->
  #   $(".drone").each (index, element) ->
  #     console.log $(element).width()
  #     $(element).css
  #       left: (($(element).width() / 100 * 20) * -1)

  #   $(".commander").each (index, element) ->
  #     console.log $(element).width()
  #     $(element).css
  #       left: (($(element).width() / 100 * 30) * -1)

  #   $(".specialist").each (index, element) ->
  #     console.log $(element).width()
  #     $(element).css
  #       left: (($(element).width() / 100 * 25) * -1)

  #   $(".sniper").each (index, element) ->
  #     console.log $(element).width()
  #     $(element).css
  #       left: (($(element).width() / 100 * 20) * -1)
  $(".crewMember img").load ->
    $(".drone").each (index, element) ->
      console.log $(element).width()
      $(element).css
        left: (($(element).width() / 100 * 20) * -1)
        visibility: "visible"

    $(".commander").each (index, element) ->
      console.log $(element).width()
      $(element).css
        left: (($(element).width() / 100 * 30) * -1)
        visibility: "visible"

    $(".specialist").each (index, element) ->
      console.log $(element).width()
      $(element).css
        left: (($(element).width() / 100 * 25) * -1)
        visibility: "visible"

    $(".sniper").each (index, element) ->
      console.log $(element).width()
      $(element).css
        left: (($(element).width() / 100 * 20) * -1)
        visibility: "visible"

    # $(".sniper, .specialist, .commander, .drone").each (index, element) ->
    #   $(element).toggleClass("visibleImageToggle")
