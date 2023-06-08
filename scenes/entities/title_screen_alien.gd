extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Infinite tween
	var tween = create_tween().set_ease(Tween.EASE_IN).set_loops()

	tween.tween_property(self, "position:y", -7, 1).as_relative() \
		.set_delay(0.5)

	tween.tween_property(self, "position:y", 7, 1).as_relative() \
		.set_delay(1) \
		.finished.connect(reset_x)

func reset_x() -> void:
	position.x = 30 + randi_range(0, 60)
