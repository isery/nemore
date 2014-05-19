Meteor.startup ->
  Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
      if Meteor.userId() ==  doc._id
        return true
      return false

  Games.allow
    remove: (userId, doc) ->
      if GamePlayers.findOne({gameId: doc._id, player: '1'}).userId == Meteor.userId()
        return true
      return false

    insert: ->
      return true

    update: ->
      return true

  GamePlayers.allow
    remove: (userId, doc) ->
      if doc.userId == Meteor.userId()
        return true
      return false

    insert: ->
      return true

    update: ->
      return true

  GameTeams.allow
    remove: (userId, doc) ->
      if GamePlayers.findOne({gameId: doc.gameId, player: '1'}).userId == Meteor.userId()
        return true
      return false

    insert: ->
      return true

    update: ->
      return true
