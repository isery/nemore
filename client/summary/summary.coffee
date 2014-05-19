Template.summary.heroImage = ->
  Router.getData().hero?.unit().name

Template.summary.events
  'click .continue': (e)->
    Router.go 'gamerooms'

  'click .heroSelection': (e)->
    Router.go 'heroSelection'

  'click .crewSelection': (e)->
    Router.go 'crewSelection'
