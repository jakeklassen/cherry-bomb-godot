extends Node2D

@onready var game_state = get_node("/root/GameState")
@onready var spritesheet = preload("res://assets/graphics/shmup.png")

var HeartFullRegion = Rect2(104, 0, 8, 8)
var HeartEmptyRegion = Rect2(112, 0, 8, 8)
var hearts: Array[Sprite2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(game_state.max_lives):
		var sprite = Sprite2D.new()
		sprite.position = Vector2i((i + 1) * 9 - 8, 1)
		sprite.offset = Vector2i(4, 4)
		sprite.texture = spritesheet
		sprite.region_enabled = true
		sprite.region_rect = HeartFullRegion if i < game_state.current_lives else HeartEmptyRegion
		hearts.append(sprite)

		add_child(sprite)

	game_state.connect("lives_changed", update_lives)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_lives(old_lives: int, new_lives: int) -> void:
	var difference = new_lives - old_lives

	if difference == 0:
		return

	if difference > 0: # Gained a life
		for heart in hearts:
			if heart.region_rect == HeartEmptyRegion:
				heart.region_rect = HeartFullRegion
				break
	elif difference < 0:
		for i in range(hearts.size() - 1, -1, -1):
			var heart = hearts[i]
			if heart.region_rect == HeartFullRegion:
				heart.region_rect = HeartEmptyRegion
				break
