extends Node2D

@export var velocity: Vector2 = Vector2(0, 60)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
