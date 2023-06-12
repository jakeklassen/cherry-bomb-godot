extends Node2D


@onready var timer = Timer.new()


func _ready() -> void:
	timer.autostart = true
	timer.wait_time = 1

	add_child(timer)

	timer.connect(
		"timeout",
		func(): get_parent().fire_spread(8)
	)


func _process(_delta: float) -> void:
	var parent = get_parent()

	if parent.position.y > 108:
		parent.velocity.y = 30
