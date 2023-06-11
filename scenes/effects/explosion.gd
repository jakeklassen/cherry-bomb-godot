extends Node2D

signal completed

@export var particle_count: int = 30
@export var spark_count: int = 20
@export var is_blue: bool = false

var particles: Array[Particle] = []
var sparks: Array[Particle] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()
	# Push this to the foreground
	z_index = 100

	add_child(Shockwave.new({
		color = Pico8.Colors.Color7,
		radius = 3,
		target_radius = 25,
		speed = 105
	}))

	var flash = Particle.new()
	flash.age = 0
	flash.max_age = 0
	flash.radius = 12
	flash.color = Pico8.Colors.Color7
	flash.velocity = Vector2.ZERO
	add_child(flash)

	for i in particle_count:
		var particle = Particle.new()
		particle.is_blue = is_blue
		add_child(particle)

	for i in spark_count:
		var spark = Particle.new(0, 0, true)
		add_child(spark)

	get_tree().create_timer(1).connect("timeout", complete)


func _process(_delta: float) -> void:
	pass


func complete():
	completed.emit()
	queue_free()
