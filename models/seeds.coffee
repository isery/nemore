
if Meteor.isServer
	Meteor.startup ->
		if Units.find().count() <= 4
			droneId = Units.insert name: "Drone", fraction: "Police", life: 1000, damage: 50, crit: 0.05, accuracy: 0.90, armor: 0.4, critFactor: 1.75
			sniperId = Units.insert name: "Sniper", fraction: "Police", life: 1000, damage: 150, crit: 0.2, accuracy: 0.95, armor: 0.8, critFactor: 1.75
			commanderId = Units.insert name: "Commander", fraction: "Terrorist", life: 1000, damage: 125, crit: 0.1, accuracy: 0.9, armor: 0.4, critFactor: 1.75
			specialistId = Units.insert name: "Specialist", fraction: "Terrorist", life: 1000, damage: 120, crit: 0.1, accuracy: 0.85, armor: 0.6, critFactor: 1.75

		droneId = Units.findOne(name: "Drone")._id
		sniperId = Units.findOne(name: "Sniper")._id
		commanderId = Units.findOne(name: "Commander")._id
		specialistId = Units.findOne(name: "Specialist")._id

		if Conditions.find().count() <= 0
			dotId = Conditions.insert name: 'dot'
			hotId = Conditions.insert name: 'hot'
			critId = Conditions.insert name: 'crit'
			hitId = Conditions.insert name: 'hit'
			armorId = Conditions.insert name: 'armor'
			dmgId = Conditions.insert name: 'dmg'

		if SpecialAbilities.find().count() <= 0
			SpecialAbilities.insert unitId: droneId, name: "defenseBuff_drone", value: 0.1, target_count: 2, duration: 2, cooldown: 0, conditionId: armorId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: droneId, name: "defenseAll_drone", value: 0.4, target_count: 5, duration: 2, cooldown: 11, conditionId: armorId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: droneId, name: "damageBuff_drone", value: 0.2, target_count: 1, duration: -1, cooldown: 5, conditionId: dmgId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: droneId, name: "damageAll_drone", value: 1.0, target_count: 5, cooldown: 9, states: ["pullweapon", "shoot", "downweapon"]

			SpecialAbilities.insert unitId: sniperId, name: "attack_sniper", value: 1.0, target_count: 1, cooldown: 0, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: sniperId, name: "steadyShot_sniper", value: 1.75, target_count: 1, cooldown: 9, states: ["pullweapon", "shoot", "downweapon"]
			#executeShot value: 2.0 || 0.8
			SpecialAbilities.insert unitId: sniperId, name: "executeShot_sniper", value: 2.0, target_count: 1, cooldown: 11, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: sniperId, name: "critBuff_sniper", value: 1.0, target_count: 1, duration: -1, cooldown: 5, conditionId: critId, states: ["pullweapon", "buff", "downweapon"]

			SpecialAbilities.insert unitId: commanderId, name: "heal_commander", value: 0.65, target_count: 1, cooldown: 0, states: ["pullweapon", "heal", "downweapon"]
			SpecialAbilities.insert unitId: commanderId, name: "hotBuff_commander", value: 50, target_count: 3, duration: 2, cooldown: 11, conditionId: hotId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: commanderId, name: "hitBuff_commander", value: 1, target_count: 2, duration: -1, cooldown: 9, conditionId: hitId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: commanderId, name: "attack_commander", value: 1, target_count: 1, cooldown: 2,  states: ["pullweapon", "shoot", "downweapon"]


			SpecialAbilities.insert unitId: specialistId, name: "attack_specialist", value: 0.75, target_count: 2, cooldown: 0, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "burnAll_specialist", value: 20, target_count: 5, duration:2, cooldown: 11, conditionId: dotId, states: ["pullweapon", "buff", "downweapon"]
			#burstShot wird über Sprite geregelt; am Server nur 1 Target - 180% dmg
			SpecialAbilities.insert unitId: specialistId, name: "burstShot_specialist", value: 1.8, target_count: 1, cooldown:6,  states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "heal_specialist", value: 0.8, target_count: 1, cooldown: 5, states: ["pullweapon", "heal", "downweapon"]

		if Terms.find().count() <= 0
			Terms.insert name: 'always'
			Terms.insert name: '< 100', operator: '<', value: 100
			Terms.insert name: '< 75', operator: '<', value: 75
			Terms.insert name: '< 50', operator: '<', value: 50
			Terms.insert name: '< 25', operator: '<', value: 25




