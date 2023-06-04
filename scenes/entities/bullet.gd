extends Area2D

@export var velocity = Vector2(0, 120)

var direction = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * direction * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	velocity = Vector2.ZERO
	z_index = 100
	$Sprite2D.texture = null
	
	var flash = Particle.new()
	flash.age = 0
	flash.max_age = 0
	flash.radius = 12
	flash.color = Color.hex(Pico8.Pico8Color.Color7)
	flash.velocity = Vector2.ZERO
	area.add_child(flash)
	
	for i in 30:
		add_child(Particle.new())
		
	for i in 20:
		var spark = Particle.new()
		spark.spark = true
		spark.velocity = Vector2(randf_range(-120, 120), randf_range(-120, 120))
		add_child(spark)

	await get_tree().create_timer(1).connect("timeout", queue_free)
#	queue_free()
