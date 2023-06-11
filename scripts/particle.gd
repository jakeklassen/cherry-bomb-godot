extends Node2D

class_name Particle

enum Bias { Blue, Red }

var age: float
var max_age: float
var color: Color
var radius: float
var is_blue: bool
var spark: bool
var direction: Vector2
var velocity: Vector2


func _init(x: float = 0, y: float = 0, is_spark: bool = false) -> void:
	age = randf_range(0, 0.066)
	max_age = 0.3 + randf_range(0, 0.3)
	color = Pico8.Colors.Color7
	radius = 1 + randi_range(0, 4)
	is_blue = false
	spark = is_spark
	direction = Vector2(
		sign(randf_range(-1, 1)),
		sign(randf_range(-1, 1))
	).normalized()
	position = Vector2(x, y)
	velocity = Vector2(randf(), randf()) * 140

	if is_spark:
		velocity = Vector2(randf(), randf()) * 300


func _ready() -> void:
	create_tween().set_trans(Tween.TRANS_CIRC) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(self, "velocity", Vector2.ZERO, (max_age - age) / 2)


func _process(delta: float) -> void:
	age += delta

	if age >= max_age:
		radius -= 0.5

		if radius <= 0:
			queue_free()
			return

	position += direction * velocity * delta
	color = determine_particle_color_from_age()

	queue_redraw()


func _draw() -> void:
	if spark == true:
		draw_rect(Rect2(position.x, position.y, 1, 1), Pico8.Colors.Color7)
	else:
		draw_circle(position.floor(), floori(radius), color)
#	draw_arc(position, floori(radius), 0, TAU, 32, color)


func determine_particle_color_from_age() -> Color:
	if is_blue == false:
		if age > 0.5:
			return Pico8.Colors.Color5
		elif age > 0.4:
			return Pico8.Colors.Color2
		elif age > 0.33:
			return Pico8.Colors.Color8
		elif age > 0.233:
			return Pico8.Colors.Color9
		elif age > 0.166:
			return Pico8.Colors.Color10
	elif is_blue == true:
		if age > 0.5:
			return Pico8.Colors.Color1
		elif age > 0.4:
			return Pico8.Colors.Color1
		elif age > 0.33:
			return Pico8.Colors.Color13
		elif age > 0.233:
			return Pico8.Colors.Color12
		elif age > 0.166:
			return Pico8.Colors.Color6

	return Pico8.Colors.Color7
