Template.summary.heroImage = ->
  Router.getData().hero?.unit().name

Template.summary.events
  'click #ready': (e)->
    Router.go 'gamerooms'
