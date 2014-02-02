
if Meteor.isServer
	Meteor.startup ->
		if Units.find().count() < 4
			Units.remove()
			droneId = Units.insert name: "Drone", fraction: "Police", live: 1000, damage: 75, crit: 0.1, accuracy: 0.6, armor: 0.8
			sniperId = Units.insert name: "Sniper", fraction: "Police", live: 1000, damage: 150, crit: 0.1, accuracy: 0.8, armor: 0.8
			commanderId = Units.insert name: "Commander", fraction: "Terrorist", live: 1000, damage: 100, crit: 0.1, accuracy: 0.7, armor: 0.4
			specialistId = Units.insert name: "Specialist", fraction: "Terrorist", live: 1000, damage: 125, crit: 0.1, accuracy: 0.75, armor: 0.6

		droneId = Units.findOne(name: "Drone")._id
		sniperId = Units.findOne(name: "Sniper")._id
		commanderId = Units.findOne(name: "Commander")._id
		specialistId = Units.findOne(name: "Specialist")._id

		if SpecialAbilities.find().count() < 16
			SpecialAbilities.remove()
			SpecialAbilities.insert unit_id: droneId, name: "autoattack", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: droneId, name: "defence", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: droneId, name: "armor all", type: "defence", factor: "0.2", target_count: 5
			SpecialAbilities.insert unit_id: droneId, name: "armor me", type: "defence", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: droneId, name: "armor someone", type: "defence", factor: "0.8", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "autoattack", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "defence", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "increase accuracy", type: "improve", factor: "1.25", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "increase damage", type: "improve", factor: "1.1667", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "increase accuracy", type: "improve", factor: "1.25", target_count: 1
			SpecialAbilities.insert unit_id: commanderId, name: "autoattack", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: commanderId, name: "defence", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: commanderId, name: "increase for all crit", type: "improve all", factor: "2", target_count: 5
			SpecialAbilities.insert unit_id: commanderId, name: "increase for all accuracy", type: "improve all", factor: "0.2", target_count: 5
			SpecialAbilities.insert unit_id: commanderId, name: "increase for all damage", type: "improve all", factor: "2", target_count: 5
			SpecialAbilities.insert unit_id: specialistId, name: "autoattack", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: specialistId, name: "defence", type: "attack", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: specialistId, name: "attack three 50% Damage", type: "attack three", factor: "-0.5", target_count: 3
			SpecialAbilities.insert unit_id: specialistId, name: "attack three 50% reset special", type: "attack three", factor: "0.5", target_count: 3
			SpecialAbilities.insert unit_id: specialistId, name: "increase for three accuracy", type: "attack one tree times", factor: "0.5", target_count: 3
