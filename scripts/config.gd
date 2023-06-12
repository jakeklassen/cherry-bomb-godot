extends Node

const entities = {
	enemies = {
		green_alien = {
			id = 1,
			score = 100,
			starting_health = 3
		},
		red_flame_guy = {
			id = 2,
			score = 200,
			starting_health = 2
		},
		spinning_ship = {
			id = 3,
			score = 300,
			starting_health = 4
		},
		yellow_ship = {
			id = 4,
			score = 500,
			starting_health = 20
		},
		boss = {
			id = 5,
			score = 10_000,
			starting_health = 130
		}
	},
	player = {
		projectiles = {
			bullet = {
				damage = 1,
			},
			big_bullet = {
				damage = 3
			},
			bomb = {
				damage = 1000
			}
		},
		spawn_position = Vector2(64, 110),
	}
}

const waves = {
	# space invaders
	1: {
		attack_frequency = 60.0 / 30.0,
		fire_frequency = 20.0 / 30.0,
		enemies = [
			[0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
			[0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
			[0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
			[0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
			# [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			# [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			# [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
			# [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		]
	},

	# red tutorial
	2: {
		# 60: Originally based on 30 FPS - so 2 seconds
		attack_frequency = 60.0 / 30.0,
		# 20: Originally based on 30 FPS - so 2 / 3 second
		fire_frequency = 20.0 / 30.0,
		enemies = [
			[1, 1, 2, 2, 1, 1, 2, 2, 1, 1],
			[1, 1, 2, 2, 1, 1, 2, 2, 1, 1],
			[1, 1, 2, 2, 2, 2, 2, 2, 1, 1],
			[1, 1, 2, 2, 2, 2, 2, 2, 1, 1],
		],
	},

	# wall of red
	3: {
		attack_frequency = 50.0 / 30.0,
		fire_frequency = 20.0 / 30.0,
		enemies = [
			[1, 1, 2, 2, 1, 1, 2, 2, 1, 1],
			[1, 1, 2, 2, 2, 2, 2, 2, 1, 1],
			[2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
			[2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		],
	},

	# spin tutorial
	4: {
		attack_frequency = 50.0 / 30.0,
		fire_frequency = 15.0 / 30.0,
		enemies = [
			[3, 3, 0, 1, 1, 1, 1, 0, 3, 3],
			[3, 3, 0, 1, 1, 1, 1, 0, 3, 3],
			[3, 3, 0, 1, 1, 1, 1, 0, 3, 3],
			[3, 3, 0, 1, 1, 1, 1, 0, 3, 3],
		],
	},

	# chess
	5: {
		attack_frequency = 50.0 / 30.0,
		fire_frequency = 15.0 / 30.0,
		enemies = [
			[3, 1, 3, 1, 2, 2, 1, 3, 1, 3],
			[1, 3, 1, 2, 1, 1, 2, 1, 3, 1],
			[3, 1, 3, 1, 2, 2, 1, 3, 1, 3],
			[1, 3, 1, 2, 1, 1, 2, 1, 3, 1],
		],
	},

	# yellow tutorial
	6: {
		attack_frequency = 40.0 / 30.0,
		fire_frequency = 10.0 / 30.0,
		enemies = [
			[2, 2, 2, 0, 4, 0, 0, 2, 2, 2],
			[2, 2, 0, 0, 0, 0, 0, 0, 2, 2],
			[1, 1, 0, 1, 1, 1, 1, 0, 1, 1],
			[1, 1, 0, 1, 1, 1, 1, 0, 1, 1],
		],
	},

	# double yellow
	7: {
		attack_frequency = 40.0 / 30.0,
		fire_frequency = 10.0 / 30.0,
		enemies = [
			[3, 3, 0, 1, 1, 1, 1, 0, 3, 3],
			[4, 0, 0, 2, 2, 2, 2, 0, 4, 0],
			[0, 0, 0, 2, 1, 1, 2, 0, 0, 0],
			[1, 1, 0, 1, 1, 1, 1, 0, 1, 1],
		],
	},

	# hell
	8: {
		attack_frequency = 30.0 / 30.0,
		fire_frequency = 10.0 / 30.0,
		enemies = [
			[0, 0, 1, 1, 1, 1, 1, 1, 0, 0],
			[3, 3, 1, 1, 1, 1, 1, 1, 3, 3],
			[3, 3, 2, 2, 2, 2, 2, 2, 3, 3],
			[3, 3, 2, 2, 2, 2, 2, 2, 3, 3],
		],
	},

	# boss
	9: {
		attack_frequency = 60.0 / 30.0,
		fire_frequency = 20.0 / 30.0,
		enemies = [
			[0, 0, 0, 0, 5, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		],
	}
}

