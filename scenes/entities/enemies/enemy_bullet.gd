extends Node2D

@export var velocity := Vector2(60, 60)
@export var direction := Vector2(0, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
