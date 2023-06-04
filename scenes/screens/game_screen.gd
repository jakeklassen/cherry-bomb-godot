extends Area2D

@export var lives: int = 4
@export var max_lives: int = 4
@export var cherries: int  = 0
@export var score: int = 0
@export var wave: int = 0
@export var max_waves: int = 9

@onready var config = get_node("/root/Config")
@onready var wave_text_label2 = $WaveText

var BlinkingText = preload("res://scenes/effects/blinking_text.tscn")

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

func next_wave() -> void:
	wave += 1
	var current_wave = config.waves[wave]

	var wave_string = "wave %s of 9"
	var wave_text = wave_string % wave
	var wave_text_label = BlinkingText.instantiate()
	wave_text_label.message = wave_text
	wave_text_label.duration = 2.6
	wave_text_label.position = Vector2(0, 40)

	get_tree().root.add_child(wave_text_label)

	await get_tree().create_timer(2.6).timeout

	for y in range(current_wave.size()):
		for x in range(current_wave[y].size()):
			var enemy = current_wave[y][x]
			if enemy == 0:
				continue

			var enemy_instance = enemy.instance()
			enemy_instance.position = Vector2(x * 32, y * 32)
			add_child(enemy_instance)
