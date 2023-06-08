extends Area2D

@export var wave: int = 0
@export var max_waves: int = 9

@onready var config = get_node("/root/Config")
@onready var game_state = get_node("/root/GameState")

var BlinkingText = preload("res://scenes/effects/blinking_text.tscn")
var Enemy = preload("res://scenes/entities/enemies/enemy.tscn")
var EnemyBullet = preload("res://scenes/entities/enemies/enemy_bullet.tscn")

var spawning: bool = false
var current_wave = null

# highscore loading?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	get_tree().create_timer(1).connect("timeout", next_wave)
	game_state.connect("score_changed", func(_old_score: int, new_score: int): update_score(new_score))
	update_score(0)
	next_wave()

	$EnemyAttackTimer.connect("timeout", pick_enemy_for_attack)
	$EnemyAttackTimer.stop()

	$EnemyFireTimer.connect("timeout", pick_enemy_for_fire)
	$EnemyFireTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("quit"):
		# At some point show a menu and don't just kill the game
		get_tree().quit();

	var enemy_count = get_tree().get_nodes_in_group("enemies").size()

	if enemy_count == 0 and spawning == false:
		next_wave()

func next_wave() -> void:
	spawning = true
	wave += 1
	current_wave = config.waves[wave]
	assert(current_wave != null, "Wave not found")
	var wave_enemies = current_wave.enemies

	var wave_string = "wave %s of 9"
	var wave_text = wave_string % wave if wave <= max_waves else "final wave!"
	var wave_text_label = BlinkingText.instantiate()
	wave_text_label.timeout = 2.6
	wave_text_label.position = Vector2(0, 40)

	get_tree().root.add_child(wave_text_label)
	wave_text_label.set_message(wave_text)

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

			get_tree().root.add_child(enemy_instance)

			var destinationX = (enemy_instance.sprite_size.size.x / 2) + ((x + 1) * 12) - 6
			var destinationY = (enemy_instance.sprite_size.size.y / 2) + ((y + 1) * 12)

			var spawn_position = Vector2(destinationX * 1.25 - 16, destinationY - 66)
			var enemy_destination = Vector2(destinationX, destinationY)

			enemy_instance.position = spawn_position
			enemy_instance.fly_in(enemy_destination, 0.8, x * 0.1)

	spawning = false

	await get_tree().create_timer(1.2).timeout
	$EnemyAttackTimer.start(current_wave.attack_frequency)
	$EnemyFireTimer.start(current_wave.fire_frequency)

func update_score(score: int) -> void:
	$HUD/ScoreText.text = "score:%d" % score

func pick_enemy_for_attack() -> void:
	print("pick_enemy_for_attack")

func pick_enemy_for_fire() -> void:
	print("pick_enemy_for_fire")

	var enemies = get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if enemy.id != Constants.EnemyType.YellowShip and enemy.state != Constants.EnemyState.Protect:
			continue

		if randf() < 0.5:
			# FIRE SPREAD
			break;

	var pickable_enemies = enemies.filter(determine_pickable_enemies)
	pickable_enemies.sort_custom(sort_entities_by_position)

	var enemy = pick_random_enemy(pickable_enemies, 10)

	if enemy == null:
		return

	var bullet = EnemyBullet.instantiate()
	get_tree().root.add_child(bullet)
	bullet.position = enemy.position + Vector2(0, 2)

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
