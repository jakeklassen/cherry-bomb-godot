extends Node2D

signal completed

@export var particle_count: int = 30
@export var spark_count: int = 20

var particles: Array[Particle] = []
var sparks: Array[Particle] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Push this to the foreground
	z_index = 100

	add_child(Shockwave.new({
		color = Color.hex(Pico8.Pico8Color.Color7),
		radius = 3,
		target_radius = 25,
		speed = 105
	}))

	var flash = Particle.new()
	flash.age = 0
	flash.max_age = 0
	flash.radius = 12
	flash.color = Color.hex(Pico8.Pico8Color.Color7)
	flash.velocity = Vector2.ZERO
	add_child(flash)


	for i in particle_count:
		add_child(Particle.new())

	for i in spark_count:
		var spark = Particle.new()
		spark.spark = true
		spark.velocity = Vector2(randf_range(-120, 120), randf_range(-120, 120))
		add_child(spark)

	get_tree().create_timer(1).connect("timeout", complete)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func complete():
	completed.emit()
	queue_free()
