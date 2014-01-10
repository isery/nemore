@Units = new Meteor.Collection 'unit'

class @Unit
	# For Meteor publish
	@all = ->
		Units.find({})

	@findOne = (options = {}) ->
		Units.findOne(options)

	@find = (options = {})->
		Units.find(options).fetch()
