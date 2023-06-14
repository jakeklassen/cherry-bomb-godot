extends Node2D

signal game_over

@onready var config = get_node("/root/Config")

const BlinkingText = preload("res://scenes/effects/blinking_text.tscn")
const Enemy = preload("res://scenes/entities/enemies/enemy.tscn")
const EnemyBullet = preload("res://scenes/entities/enemies/enemy_bullet.tscn")
const TitleScreenScene = preload("res://scenes/screens/title_screen.tscn")

var spawning_wave: bool = false
var current_wave = null

# highscore loading?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	get_tree().create_timer(1).connect("timeout", next_wave)
	GameState.connect(
		"score_changed",
		func(_old_score: int, new_score: int): update_score(new_score)
	)

	GameState.connect(
		"cherries_changed",
		func(_old_cherries: int, new_cherries: int): $HUD/CherriesText.text = "%d" % new_cherries
	)

	GameState.connect("player_dead", handle_game_over)

	update_score(0)
	next_wave()

	$EnemyAttackTimer.connect("timeout", pick_enemy_for_attack)
	$EnemyAttackTimer.stop()

	$EnemyFireTimer.connect("timeout", pick_enemy_for_fire)
	$EnemyFireTimer.stop()


func _process(_delta: float) -> void:
	var enemy_count = get_tree().get_nodes_in_group("enemies").size()

	if enemy_count == 0 and not spawning_wave:
		$WaveCompleteAudioPlayer.play()
		next_wave()


func _draw() -> void:
	pass
#	draw_line(Vector2(24, 0), Vector2(24, 128), Color(1, 1, 1, 0.5), 1)
#	draw_line(Vector2(104, 0), Vector2(104, 128), Color(1, 1, 1, 0.5), 1)


func handle_game_over() -> void:
	$GameOverAudioPlayer.play()
	$EnemyAttackTimer.stop()
	$EnemyFireTimer.stop()

	await get_tree().create_timer(1).timeout
	$HUD/GameOver.visible = true
	$HUD/AnyKeyToContinue.visible = true

	process_mode = PROCESS_MODE_DISABLED
	game_over.emit()


func next_wave() -> void:
	if GameState.current_wave == GameState.max_waves:
		return

	spawning_wave = true
	var wave = GameState.increment_wave()
	current_wave = config.waves[wave]
	var wave_enemies = current_wave.enemies

	var wave_string = "wave %s of 9"
	var wave_text = wave_string % wave if wave <= GameState.max_waves else "final wave!"
	var wave_text_label = BlinkingText.instantiate()
	wave_text_label.timeout = 2.6

	add_child(wave_text_label)

	wave_text_label.set_message(wave_text)
	var text_node: RichTextLabel = wave_text_label.get_node("Text")
	wave_text_label.position = Vector2(64 - text_node.get_content_width() / 2.0, 40)

	# Wait for the wave text to finish
	await wave_text_label.finished
	wave_text_label.queue_free()

	for y in range(wave_enemies.size()):
		for x in range(wave_enemies[y].size()):
			var enemy = wave_enemies[y][x]
			if enemy == 0:
				continue

			var enemy_instance = Enemy.instantiate()
			enemy_instance.id = enemy

			add_child(enemy_instance)

			var destinationX = (enemy_instance.sprite_size.size.x / 2) + ((x + 1) * 12) - 6
			var destinationY = (enemy_instance.sprite_size.size.y / 2) + ((y + 1) * 12)

			var spawn_position = Vector2(destinationX * 1.25 - 16, destinationY - 66)
			var enemy_destination = Vector2(destinationX, destinationY)

			enemy_instance.position = spawn_position
			enemy_instance.fly_in(enemy_destination, 0.8, x * 0.1)

	get_tree().create_timer(0.2) \
		.connect("timeout", func(): $WaveSpawnAudioPlayer.play())
	await get_tree().create_timer(1.2).timeout
	$EnemyAttackTimer.start(current_wave.attack_frequency)
	$EnemyFireTimer.start(current_wave.fire_frequency)

	spawning_wave = false


func update_score(score: int) -> void:
	$HUD/ScoreText.text = "score:%d" % score


func pick_enemy_for_attack() -> void:
	# We only trigger an attack 50% of the time
	if randf() < 0.5:
		return

	var enemies = get_tree().get_nodes_in_group("enemies")
	var pickable_enemies = enemies.filter(determine_pickable_enemies)
	pickable_enemies.sort_custom(sort_entities_by_position)

	var enemy = pick_random_enemy(pickable_enemies, 10)

	if enemy == null or enemy.id == Constants.EnemyType.Boss:
		return

	enemy.attack()


func pick_enemy_for_fire() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")

	var yellow_ships = enemies.filter(attack_ready_yellow_ship_filter)
	for enemy in yellow_ships:
		if randf() < 0.5:
			enemy.fire_spread(12)
			$EnemyFireTimer.start(current_wave.fire_frequency + randf_range(0, current_wave.fire_frequency))
			return

	var pickable_enemies = enemies.filter(determine_pickable_enemies)
	pickable_enemies.sort_custom(sort_entities_by_position)

	var enemy = pick_random_enemy(pickable_enemies, 10)

	if enemy == null:
		return

	match enemy.id:
		Constants.EnemyType.GreenAlien, Constants.EnemyType.SpinningShip:
			enemy.fire()
		Constants.EnemyType.RedFlameGuy:
			enemy.fire($Player.position)
		Constants.EnemyType.YellowShip:
			enemy.fire_spread(12)

	$EnemyFireTimer.start(current_wave.fire_frequency + randf_range(0, current_wave.fire_frequency))


func sort_entities_by_position(a: Area2D, b: Area2D) -> bool:
	if a.position.y < b.position.y:
		return true

	if a.position.y > b.position.y:
		return false

	if a.position.x < b.position.x:
		return true

	if a.position.x > b.position.x:
		return false

	return false


func determine_pickable_enemies(enemy: Area2D) -> bool:
	return enemy.state == Constants.EnemyState.Protect


func pick_random_enemy(enemies: Array[Node], elements_from_last: int = 10) -> Node:
	if enemies.size() == 0:
		return null

	var max_index = min(enemies.size(), elements_from_last)
	var random_index = randi_range(1, max_index)
	var enemy_index = enemies.size() - random_index

	return enemies[enemy_index]


func attack_ready_yellow_ship_filter(enemy) -> bool:
	return enemy.state == Constants.EnemyState.Protect and enemy.id == Constants.EnemyType.YellowShip
