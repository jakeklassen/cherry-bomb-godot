extends Node2D

## This pattern is used to move the enemy from side to side like a sine wave.
## This script is attached to the "enemy" scene.

func _ready() -> void:
	var direction_x = 1 if randf() < 0.5 else -1

	var parent = get_parent()

	if parent.position.x < 24:
		direction_x = 1
	elif parent.position.x > 104:
		direction_x = -1

	var start_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	start_tween.tween_property(parent, "position:x", direction_x * 8, 0.6)

	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_loops()
	tween.tween_property(parent, "position:x", direction_x * 20, 0.8) \
		.as_relative()
	tween.tween_property(parent, "position:x", -direction_x * 20, 0.8) \
		.as_relative()
