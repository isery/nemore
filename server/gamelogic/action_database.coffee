class @ActionDatabase
  constructor: ->

  @add: (data) ->
    actionId = Actions.insert
      gameId: data.gameId
      from: data.from
      to: data.to
      abilityId: data.abilityId
      index: data.index
    console.log "Added Actions with id: " + actionId
