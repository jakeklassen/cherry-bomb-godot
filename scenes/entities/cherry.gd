extends Area2D

@export var direction := Vector2(0, 1)
@export var velocity := Vector2(30, 30)
@export var outline_colors: Array[Color]

var current_color_index := 0
var current_color: Color


func _ready() -> void:
	current_color = outline_colors[current_color_index]

	$Sprite2D.material.set_shader_parameter(
		"outline_color",
		current_color
	)

	$OutlineTimer.connect("timeout", swap_outline_color)


func _process(delta: float) -> void:
	position += direction * velocity * delta


func swap_outline_color() -> void:
	current_color_index += 1
	current_color = outline_colors[current_color_index % outline_colors.size()]

	$Sprite2D.material.set_shader_parameter(
		"outline_color",
		current_color
	)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
