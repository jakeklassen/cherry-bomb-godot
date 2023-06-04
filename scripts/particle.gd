extends Node2D

class_name Particle

enum Bias { Blue, Red }

var age: float
var max_age: float
var color: Color
var radius: float
var isBlue: bool
var spark: bool
var velocity: Vector2

func _init(x: float = 0, y: float = 0) -> void:
	age = randf_range(0, 0.066)
	max_age = 0.333 + randf_range(0, 0.333)
	color = Color.hex(Pico8.Pico8Color.Color7)
	radius = 1 + randi_range(0, 4)
	isBlue = false
	spark = false
	position = Vector2(x, y)
	velocity = Vector2(randf_range(-90, 90), randf_range(-90, 90))

func _process(delta: float) -> void:
	age += delta
	velocity *= 0.85

	if age >= max_age:
		radius -= 0.5

		if radius <= 0:
			queue_free()
			return

	position += velocity * delta
	color = determine_particle_color_from_age()

	queue_redraw()

func _draw() -> void:
	if spark == true:
		draw_rect(Rect2(position.x, position.y, 1, 1), Color.hex(Pico8.Pico8Color.Color7))
	else:
		draw_circle(position.floor(), floori(radius), color)
#	draw_arc(position, floori(radius), 0, TAU, 32, color)

func determine_particle_color_from_age() -> Color:
	if (isBlue == false):
		if age > 0.5:
			return Color.hex(Pico8.Pico8Color.Color5)
		elif age > 0.4:
			return Color.hex(Pico8.Pico8Color.Color2)
		elif age > 0.33:
			return Color.hex(Pico8.Pico8Color.Color8)
		elif age > 0.233:
			return Color.hex(Pico8.Pico8Color.Color9)
		elif age > 0.166:
			return Color.hex(Pico8.Pico8Color.Color10)

	return Color.hex(Pico8.Pico8Color.Color7)
