@tool

extends Area2D

@export var id: Constants.EnemyType = Constants.EnemyType.Empty
@onready var config = get_node("/root/Config")
@onready var game_state = get_node("/root/GameState")

var Explosion = preload("res://scenes/effects/explosion.tscn")
var GreenAlienSpriteFrames = preload("res://resources/sprite_frames/green_alien.tres")
var RedFlameGuySpriteFrames = preload("res://resources/sprite_frames/red_flame_guy.tres")
var SpinningShipSpriteFrames = preload("res://resources/sprite_frames/spinning_ship.tres")
var YellowShipSpriteFrames = preload("res://resources/sprite_frames/yellow_ship.tres")
var BossSpriteFrames = preload("res://resources/sprite_frames/boss.tres")

var health: int
var score: int
var invulnerable: bool = true
var sprite_size: Rect2
var state: Constants.EnemyState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(id != 0, "Enemy id should be greater than 0")

	match id:
		Constants.EnemyType.GreenAlien:
			$AnimatedSprite2D.set_sprite_frames(GreenAlienSpriteFrames)
			health = config.entities.enemies.green_alien.starting_health
			score = config.entities.enemies.green_alien.score
			sprite_size = Rect2(0, 0, 8, 8)
		Constants.EnemyType.RedFlameGuy:
			$AnimatedSprite2D.set_sprite_frames(RedFlameGuySpriteFrames)
			health = config.entities.enemies.red_flame_guy.starting_health
			score = config.entities.enemies.red_flame_guy.score
			sprite_size = Rect2(0, 0, 8, 8)
		Constants.EnemyType.SpinningShip:
			$AnimatedSprite2D.set_sprite_frames(SpinningShipSpriteFrames)
			health = config.entities.enemies.spinning_ship.starting_health
			score = config.entities.enemies.spinning_ship.score
			sprite_size = Rect2(0, 0, 8, 8)
		Constants.EnemyType.YellowShip:
			$AnimatedSprite2D.set_sprite_frames(YellowShipSpriteFrames)
			health = config.entities.enemies.yellow_ship.starting_health
			score = config.entities.enemies.yellow_ship.score
			sprite_size = Rect2(0, 0, 16, 16)
		Constants.EnemyType.Boss:
			$AnimatedSprite2D.set_sprite_frames(BossSpriteFrames)
			health = config.entities.enemies.boss.starting_health
			score = config.entities.enemies.boss.score
			sprite_size = Rect2(0, 0, 32, 24)

	$AnimatedSprite2D.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func take_damage(damage: int) -> void:
	health = health - damage if invulnerable == false else health

	if health <= 0:
		var explosion = Explosion.instantiate()
		explosion.position = position
		get_tree().root.add_child(explosion)
		game_state.increment_score(score)

		queue_free()
	else:
		var shockwave = Shockwave.new({
			color = Color.hex(Pico8.Pico8Color.Color9),
			radius = 2,
			target_radius = 6,
			speed = 30,
			position = Vector2(0, 2)
		})

		$AnimatedSprite2D.material.set_shader_parameter("active", true)
		get_tree().create_timer(0.1) \
			.connect(
				"timeout",
				func(): $AnimatedSprite2D.material.set_shader_parameter("active", false)
			)

		add_child(shockwave)

func fly_in(to: Vector2, duration: float, delay: float) -> void:
	state = Constants.EnemyState.FlyIn

	var tween = create_tween() \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)

	tween.tween_property(self, "position", to, duration) \
		.set_delay(delay) \
		.finished.connect(protect)

func protect() -> void:
	invulnerable = false
	state = Constants.EnemyState.Protect
