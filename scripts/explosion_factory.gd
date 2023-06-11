class_name ExplosionFactory

const ExplosionScene = preload("res://scenes/effects/explosion.tscn")
const PlayerDeathSound = preload("res://assets/audio/player-death.wav")
const EnemyDeathSound = preload("res://assets/audio/enemy-death.wav")


## Create a red explosion for an enemy
static func enemy(args) -> void:
	var explosion = ExplosionScene.instantiate()
	explosion.position = args.position
	var audio_player = explosion.get_node("AudioStreamPlayer")
	audio_player.stream = EnemyDeathSound

	args.root.call_deferred("add_child", explosion)


## Create a blue explosion for the player
static func player(args) -> void:
	var explosion = ExplosionScene.instantiate()
	explosion.position = args.position
	explosion.is_blue = true

	var audio_player = explosion.get_node("AudioStreamPlayer")
	audio_player.stream = PlayerDeathSound

	args.root.call_deferred("add_child", explosion)
