UI.registerHelper 'formatPercent', (value) ->
  (value * 100) + '%'

UI.registerHelper 'toLowerCase', (value) ->
  value.toLowerCase()

UI.registerHelper 'numberSelectedMembers', () ->
  Team.find({userId: Meteor.userId()}).length - 1
