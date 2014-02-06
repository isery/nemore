class @SniperLogic extends BaseLogic
  
  constructor: (data)->
  	super(data)
  	
  	@_unit = Units.findOne(name:"Sniper")
  	
  	@_unitLife = @_unit.live
	@_unitArmor = @_unit.armor
	@_unitBaseDamage = @_unit.damage
	@_unitCritChance = @_unit.crit
	@_unitHitChance = @_unit.accuracy

	@_specialAbilities = SpecialAbilities.find({unit_id: @_unit._id})
  	
  	@_targets = data.targets

  autoattack_sniper: (data) ->
  	#if @_targets.length == @_specialAbilities.target_count
  	@_ability = SpecialAbilities.findOne({name: "autoattack_sniper"})

  	@_damageFactor = @_ability.factor

	@_damageToTargetWithoutArmor = parseFloat(@_damageFactor) * @_unitBaseDamage
  	if Math.random() <= @_unitCritChance
  		@_damageToTargetWithoutArmor = @_damageToTargetWithoutArmor * @_critFactor)
  	
  	@_damageToTarget = Math.floor(@_damageToTargetWithoutArmor * @_targets.armor)

  	@_targets.life -= @_damageToTarget

  defense_sniper: (data) ->

  buffAccuracy_sniper: (data) ->

  buffDamage_sniper: (data) ->

  buffCrit_sniper: (data) ->