UI.registerHelper 'formatPercent', (value) ->
  (value * 100) + '%'

UI.registerHelper 'toLowerCase', (value) ->
  value.toLowerCase()

UI.registerHelper 'toUpperCase', (value) ->
  value.toUpperCase()

UI.registerHelper 'numberSelectedMembers', () ->
  Team.find({userId: Meteor.userId()}).length - 1

UI.registerHelper 'addPercent', (value) ->
  value + ' %'
