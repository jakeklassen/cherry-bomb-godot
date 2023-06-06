@tool

extends Area2D

@export var id: int = 0
@onready var config = get_node("/root/Config")

var Explosion = preload("res://scenes/effects/explosion.tscn")
var GreenAlienSpriteFrames = preload("res://resources/sprite_frames/green_alien.tres")
var RedFlameGuySpriteFrames = preload("res://resources/sprite_frames/red_flame_guy.tres")
var SpinningShipSpriteFrames = preload("res://resources/sprite_frames/spinning_ship.tres")

var health: int
var score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(id != 0, "Enemy id should be greater than 0")

	match id:
		1:
			$AnimatedSprite2D.set_sprite_frames(GreenAlienSpriteFrames)
			health = config.entities.enemies.green_alien.starting_health
			score = config.entities.enemies.green_alien.score
		2:
			$AnimatedSprite2D.set_sprite_frames(RedFlameGuySpriteFrames)
			health = config.entities.enemies.red_flame_guy.starting_health
			score = config.entities.enemies.red_flame_guy.score
		3:
			$AnimatedSprite2D.set_sprite_frames(SpinningShipSpriteFrames)
			health = config.entities.enemies.spinning_ship.starting_health
			score = config.entities.enemies.spinning_ship.score

	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage(damage: int) -> void:
	health -= damage

	if health <= 0:
		var explosion = Explosion.instantiate()
		explosion.position = position
		get_tree().root.add_child(explosion)

		queue_free()
	else:
		var shockwave = Shockwave.new({
			color = Color.hex(Pico8.Pico8Color.Color9),
			radius = 2,
			target_radius = 6,
			speed = 30,
			position = Vector2(0, 2)
		})

		add_child(shockwave)
