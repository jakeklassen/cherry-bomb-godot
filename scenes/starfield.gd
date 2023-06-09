#@tool

extends Node2D

@export var count: int = 100;

var stars = [];
var velocities = [20, 30, 60];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in count:
		var star = {
			color = Pico8.Colors.Color7,
			position = Vector2(randi_range(1, 127), randi_range(1, 127)),
			speed = velocities.pick_random(),
		}

		if star.speed < 30:
			star.color = Pico8.Colors.Color1;
		elif star.speed < 60:
			star.color = Pico8.Colors.Color13;

		stars.push_back(star);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for star in stars:
		star.position.y += star.speed * delta;

		if star.position.y > 128:
			star.position.y = -1;
			star.position.x = randi_range(1, 127);

	queue_redraw();

func _draw() -> void:
	for star in stars:
		draw_rect(Rect2(star.position.x, star.position.y, 1, 1), star.color, true);
