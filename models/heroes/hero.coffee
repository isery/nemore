@Heroes = new Meteor.Collection 'hero'

class @Hero
	# For Meteor publish
	@all = ->
		Heroes.find({})

	@findOne = (options = {}) ->
		Heroes.findOne(options)

	@find = (options = {})->
		Heroes.find(options).fetch()
