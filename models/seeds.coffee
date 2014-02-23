
if Meteor.isServer
	Meteor.startup ->
		if Units.find().count() < 4
			Units.remove()
			droneId = Units.insert name: "Drone", fraction: "Police", life: 1000, damage: 75, crit: 0.1, accuracy: 0.8, armor: 0.8
			sniperId = Units.insert name: "Sniper", fraction: "Police", life: 1000, damage: 150, crit: 0.1, accuracy: 0.95, armor: 0.8
			commanderId = Units.insert name: "Commander", fraction: "Terrorist", life: 1000, damage: 100, crit: 0.1, accuracy: 0.9, armor: 0.4
			specialistId = Units.insert name: "Specialist", fraction: "Terrorist", life: 1000, damage: 125, crit: 0.1, accuracy: 0.85, armor: 0.6

		droneId = Units.findOne(name: "Drone")._id
		sniperId = Units.findOne(name: "Sniper")._id
		commanderId = Units.findOne(name: "Commander")._id
		specialistId = Units.findOne(name: "Specialist")._id

		if Conditions.find().count() <= 0
			fireId = Conditions.insert name: 'fire'
			poisonId = Conditions.insert name: 'poison'
			potId = Conditions.insert name: 'pot'
			critId = Conditions.insert name: 'crit'
			hitId = Conditions.insert name: 'hit'
			armorId = Conditions.insert name: 'armor'

		if SpecialAbilities.find().count() < 16
			SpecialAbilities.remove()
			SpecialAbilities.insert unitId: droneId, name: "autoattack_drone", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: droneId, name: "defense_drone", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: fireId
			SpecialAbilities.insert unitId: droneId, name: "armorAll_drone", type: "defence", factor: "0.2", target_count: 5, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: poisonId
			SpecialAbilities.insert unitId: droneId, name: "armorSelf_drone", type: "defence", factor: "1.0", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: potId
			SpecialAbilities.insert unitId: droneId, name: "armorTarget_drone", type: "defence", factor: "0.8", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: critId
			SpecialAbilities.insert unitId: sniperId, name: "autoattack_sniper", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: sniperId, name: "defense_sniper", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: hitId
			SpecialAbilities.insert unitId: sniperId, name: "buffAccuracy_sniper", type: "improve", factor: "1.25", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: fireId
			SpecialAbilities.insert unitId: sniperId, name: "buffDamage_sniper", type: "improve", factor: "1.1667", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: poisonId
			SpecialAbilities.insert unitId: sniperId, name: "buffCrit_sniper", type: "improve", factor: "1.25", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: potId
			SpecialAbilities.insert unitId: commanderId, name: "autoattack_commander", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: commanderId, name: "defense_commander", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: critId
			SpecialAbilities.insert unitId: commanderId, name: "buffAllCrit_commander", type: "improve all", factor: "2", target_count: 5, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: hitId
			SpecialAbilities.insert unitId: commanderId, name: "buffAllAccuracy_commander", type: "improve all", factor: "0.2", target_count: 5, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: poisonId
			SpecialAbilities.insert unitId: commanderId, name: "buffAllDamage_commander", type: "improve all", factor: "2", target_count: 5, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: potId
			SpecialAbilities.insert unitId: specialistId, name: "autoattack_specialist", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "defense_specialist", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: fireId
			SpecialAbilities.insert unitId: specialistId, name: "multiShot_specialist", type: "attack three", factor: "0.5", target_count: 3, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "burstShot_specialist", type: "attack three", factor: "0.5", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "disableSpecialAbility_specialist", type: "attack one tree times", factor: "0.5", target_count: 3, states: ["pullweapon", "buff", "downweapon"], duration: 2, conditionId: critId

		if Terms.find().count() <= 0
			Terms.insert name: 'always'




