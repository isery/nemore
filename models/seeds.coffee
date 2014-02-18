
if Meteor.isServer
	Meteor.startup ->
		if Units.find().count() < 4
			Units.remove()
			droneId = Units.insert name: "Drone", fraction: "Police", life: 1000, damage: 75, crit: 0.1, accuracy: 0.6, armor: 0.8
			sniperId = Units.insert name: "Sniper", fraction: "Police", life: 1000, damage: 150, crit: 0.1, accuracy: 0.8, armor: 0.8
			commanderId = Units.insert name: "Commander", fraction: "Terrorist", life: 1000, damage: 100, crit: 0.1, accuracy: 0.7, armor: 0.4
			specialistId = Units.insert name: "Specialist", fraction: "Terrorist", life: 1000, damage: 125, crit: 0.1, accuracy: 0.75, armor: 0.6

		droneId = Units.findOne(name: "Drone")._id
		sniperId = Units.findOne(name: "Sniper")._id
		commanderId = Units.findOne(name: "Commander")._id
		specialistId = Units.findOne(name: "Specialist")._id

		if SpecialAbilities.find().count() < 16
			SpecialAbilities.remove()
			SpecialAbilities.insert unit_id: droneId, name: "autoattack_drone", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unit_id: droneId, name: "defense_drone", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: droneId, name: "armorAll_drone", type: "defence", factor: "0.2", target_count: 5, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: droneId, name: "armorSelf_drone", type: "defence", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: droneId, name: "armorTarget_drone", type: "defence", factor: "0.8", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: sniperId, name: "autoattack_sniper", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: sniperId, name: "defense_sniper", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: sniperId, name: "buffAccuracy_sniper", type: "improve", factor: "1.25", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: sniperId, name: "buffDamage_sniper", type: "improve", factor: "1.1667", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: sniperId, name: "buffCrit_sniper", type: "improve", factor: "1.25", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: commanderId, name: "autoattack_commander", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unit_id: commanderId, name: "defense_commander", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: commanderId, name: "buffAllCrit_commander", type: "improve all", factor: "2", target_count: 5, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: commanderId, name: "buffAllAccuracy_commander", type: "improve all", factor: "0.2", target_count: 5, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: commanderId, name: "buffAllDamage_commander", type: "improve all", factor: "2", target_count: 5, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: specialistId, name: "autoattack_specialist", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: specialistId, name: "defense_specialist", type: "attack", factor: "1.0", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: specialistId, name: "multiShot_specialist", type: "attack three", factor: "0.5", target_count: 3, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: specialistId, name: "burstShot_specialist", type: "attack three", factor: "0.5", target_count: 1, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unit_id: specialistId, name: "disableSpecialAbility_specialist", type: "attack one tree times", factor: "0.5", target_count: 3, states: ["pullweapon", "shoot", "downweapon"]
