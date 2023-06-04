extends Node2D

class_name Shockwave

var radius: float
var target_radius: float
var speed: float
var color: Color

func _init(args) -> void:
	radius = args.radius
	target_radius = args.target_radius
	speed = args.speed
	color = args.color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	radius += speed * delta;

	if radius >= target_radius:
		queue_free()

	queue_redraw()

func _draw() -> void:
	draw_arc(position.floor(), floori(radius), 0, TAU, 32, color)
