if Meteor.isServer
	Meteor.startup ->
		if Units.find().count() <= 0
			droneId = Units.insert name: "Drone", fraction: "Police", life: 1000, damage: 50, crit: 0.05, accuracy: 0.90, armor: 0.4, critFactor: 1.75
			sniperId = Units.insert name: "Sniper", fraction: "Police", life: 1000, damage: 150, crit: 0.2, accuracy: 0.95, armor: 0.8, critFactor: 1.75
			commanderId = Units.insert name: "Commander", fraction: "Terrorist", life: 1000, damage: 125, crit: 0.1, accuracy: 0.9, armor: 0.4, critFactor: 1.75
			specialistId = Units.insert name: "Specialist", fraction: "Terrorist", life: 1000, damage: 120, crit: 0.1, accuracy: 0.85, armor: 0.6, critFactor: 1.75

		droneId = Units.findOne(name: "Drone")._id
		sniperId = Units.findOne(name: "Sniper")._id
		commanderId = Units.findOne(name: "Commander")._id
		specialistId = Units.findOne(name: "Specialist")._id

		if Conditions.find().count() <= 0
			conditionArr = []
			critId = Conditions.insert name: 'crit'
			hitId = Conditions.insert name: 'hit'
			armorId = Conditions.insert name: 'armor'
			dmgId = Conditions.insert name: 'dmg'
			conditionArr.push critId, hitId, armorId, dmgId
		if SpecialAbilities.find().count() <= 0
			SpecialAbilities.insert unitId: droneId, name: "defenseAll_drone", specialName: "Crystal Armor", description: "Increases defense of allies",target_type: "team", value: 0.4, target_count: 5, duration: 2, cooldown: 11, conditionId: armorId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: droneId, name: "damageAll_drone", specialName: "Devastating Blow", description: "Deals damage to all enemies", target_type: "enemies", value: 1.0, target_count: 5, cooldown: 9, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: droneId, name: "damageBuff_drone", specialName: "Raise Morale", description: "Increases damage", target_type: "team", value: 0.2, target_count: 1, duration: -1, cooldown: 5, conditionId: dmgId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: droneId, name: "defenseBuff_drone", specialName: "Bulwark", description: "Increases defense of allies", target_type: "team", value: 0.1, target_count: 2, duration: 2, cooldown: 0, conditionId: armorId, states: ["pullweapon", "buff", "downweapon"]

			SpecialAbilities.insert unitId: sniperId, name: "executeShot_sniper", specialName: "Ace in the Hole", description: "Executes an enemy below 50% health", target_type: "enemies", value: 2.0, target_count: 1, cooldown: 11, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: sniperId, name: "steadyShot_sniper", specialName: "Steady Shot", description: "Deals massive damage to an enemy", target_type: "enemies", value: 1.75, target_count: 1, cooldown: 9, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: sniperId, name: "critBuff_sniper", specialName: "Blood Rush", description: "Increases critical hit chance of the unit", target_type: "self", value: 1.0, target_count: 1, duration: -1, cooldown: 5, conditionId: critId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: sniperId, name: "attack_sniper", specialName: "Headshot", description: "Deals decent damage to an enemy", target_type: "enemies", value: 1.0, target_count: 1, cooldown: 0, states: ["pullweapon", "shoot", "downweapon"]

			SpecialAbilities.insert unitId: commanderId, name: "trueDamage_commander", specialName: "Piercing Shot", description: "Ignores enemy armor", target_type: "enemies", value: 1, target_count: 1, cooldown: 11, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: commanderId, name: "hitBuff_commander", specialName: "Iron Sights", description: "Increases accuracy of multiple allies", target_type: "team", value: 1, target_count: 2, duration: -1, cooldown: 9, conditionId: hitId, states: ["pullweapon", "buff", "downweapon"]
			SpecialAbilities.insert unitId: commanderId, name: "attack_commander", specialName: "Mercury Cannon", description: "Deals damage to an enemy", target_type: "enemies", value: 1, target_count: 1, cooldown: 2,  states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: commanderId, name: "heal_commander", specialName: "Divine Blessing", description: "Heals an allied unit", target_type: "team", value: 0.65, target_count: 1, cooldown: 0, states: ["pullweapon", "heal", "downweapon"]


			SpecialAbilities.insert unitId: specialistId, name: "attackAll_specialist", specialName: "Living Artillery", description: "Damages all enemies", target_type: "enemies", value: 0.8, target_count: 5, cooldown: 11, states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "burstShot_specialist", specialName: "Impure Shots", description: "Bursts one enemy", target_type: "enemies", value: 1.8, target_count: 1, cooldown:6,  states: ["pullweapon", "shoot", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "heal_specialist", specialName: "Astral Blessing", description: "Heals the unit", target_type: "self", value: 0.8, target_count: 1, cooldown: 5, states: ["pullweapon", "heal", "downweapon"]
			SpecialAbilities.insert unitId: specialistId, name: "attack_specialist", specialName: "Phosphorus Bomb", description: "Damages multiple enemies", target_type: "enemies", value: 0.75, target_count: 2, cooldown: 0, states: ["pullweapon", "shoot", "downweapon"]

		if Terms.find().count() <= 0
			Terms.insert name: 'always', operator: '∞'
			Terms.insert name: '< 100 %', operator: '<', value: 1
			Terms.insert name: '< 75 %', operator: '<', value: 0.75
			Terms.insert name: '< 50 %', operator: '<', value: 0.50
			Terms.insert name: '< 25 %', operator: '<', value: 0.25


		if Colors.find().count() <= 0
			colorArr = []
			colorArr.push Colors.insert name: "Red", hex: "#ff0000"
			colorArr.push Colors.insert name: "Green", hex: "#00ff00"
			colorArr.push Colors.insert name: "Blue", hex: "#0000ff"
		if Keys.find().count() <= 0
			keyArr = []
			keyArr.push Keys.insert name: "q", inputkey: 81
			keyArr.push Keys.insert name: "w", inputkey: 87
			keyArr.push Keys.insert name: "e", inputkey: 69
			keyArr.push Keys.insert name: "r", inputkey: 82
		if ColorKeys.find().count() <= 0
			for color in colorArr
				for key, i in keyArr
					ColorKeys.insert colorId: color, keyId: key, conditionId: conditionArr[i], value: 1, duration: 1


		for ki in @Ki
			unless Meteor.users.findOne({username: ki})
				Accounts.createUser({username: ki, password: ki})
