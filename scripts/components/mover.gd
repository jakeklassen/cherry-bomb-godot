extends Node2D

@export var direction := Vector2(0, 0)
@export var velocity := Vector2(0, 0)
@export var parent: Node2D


func _process(delta: float) -> void:
	parent.position += direction * velocity * delta
