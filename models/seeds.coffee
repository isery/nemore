
if Meteor.isServer
	Meteor.startup ->
		Actions.insert game_id: 1, from: 2, to: 24, special: false, crit: false, hit: true, damage: 100  if Actions.find().count() is 0
		if Units.find().count() < 4
			Units.remove()
			droneId = Units.insert name: "Drone", fraction: "Police", live: 1000, damage: 75, crit: 0.1, accuracy: 0.6, armor: 0.8
			sniperId = Units.insert name: "Sniper", fraction: "Police", live: 1000, damage: 150, crit: 0.1, accuracy: 0.8, armor: 0.8
			commanderId = Units.insert name: "Commander", fraction: "Terrorist", live: 1000, damage: 100, crit: 0.1, accuracy: 0.7, armor: 0.4
			specialistId = Units.insert name: "Specialist", fraction: "Terrorist", live: 1000, damage: 125, crit: 0.1, accuracy: 0.75, armor: 0.6

		if SpecialAbilities.find().count() < 12
			SpecialAbilities.remove()
			SpecialAbilities.insert unit_id: droneId, name: "armor all", type: "defence", factor: "0.2", target_count: 5
			SpecialAbilities.insert unit_id: droneId, name: "armor me", type: "defence", factor: "1.0", target_count: 1
			SpecialAbilities.insert unit_id: droneId, name: "armor someone", type: "defence", factor: "0.8", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "increase accuracy", type: "improve", factor: "1.25", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "increase damage", type: "improve", factor: "1.1667", target_count: 1
			SpecialAbilities.insert unit_id: sniperId, name: "increase accuracy", type: "improve", factor: "1.25", target_count: 1
			SpecialAbilities.insert unit_id: commanderId, name: "increase for all crit", type: "improve all", factor: "2", target_count: 5
			SpecialAbilities.insert unit_id: commanderId, name: "increase for all accuracy", type: "improve all", factor: "0.2", target_count: 5
			SpecialAbilities.insert unit_id: commanderId, name: "increase for all damage", type: "improve all", factor: "2", target_count: 5
			SpecialAbilities.insert unit_id: specialistId, name: "attack three 50% Damage", type: "attack three", factor: "-0.5", target_count: 3
			SpecialAbilities.insert unit_id: specialistId, name: "attack three 50% reset special", type: "attack three", factor: "0.5", target_count: 3
			SpecialAbilities.insert unit_id: specialistId, name: "increase for three accuracy", type: "attack one tree times", factor: "0.5", target_count: 3
