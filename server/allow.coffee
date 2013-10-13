Meteor.startup ->
  Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
      if Meteor.userId() ==  doc._id
        return true
      return false
