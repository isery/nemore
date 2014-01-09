Template.preSetting.events
  'click #ready': (e)->
    Router.getData().currentGame.setReady(Meteor.userId())
