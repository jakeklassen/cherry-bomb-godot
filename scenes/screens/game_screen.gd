extends Area2D

@export var lives: int = 4
@export var max_lives: int = 4
@export var cherries: int  = 0
@export var score: int = 0
@export var wave: int = 0
@export var max_waves: int = 9

@onready var config = get_node("/root/Config")

var BlinkingText = preload("res://scenes/effects/blinking_text.tscn")
var Enemy = preload("res://scenes/entities/enemies/enemy.tscn")

var spawning: bool = false

# highscore loading?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	get_tree().create_timer(1).connect("timeout", next_wave)
	next_wave()

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
	var current_wave = config.waves[wave]
	assert(current_wave != null, "Wave not found")
	var wave_enemies = current_wave.enemies

	var wave_string = "wave %s of 9"
	var wave_text = wave_string % wave
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

			var destinationX = 4 + ((x + 1) * 12) - 6
			var destinationY = 4 + ((y + 1) * 12)

			var spawn_position = Vector2(destinationX * 1.25 - 16, destinationY - 66)
			var enemy_destination = Vector2(destinationX, destinationY)
			var enemy_instance = Enemy.instantiate()
			enemy_instance.id = enemy
			enemy_instance.position = enemy_destination
			get_tree().root.add_child(enemy_instance)

	spawning = false

