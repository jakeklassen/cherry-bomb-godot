extends Area2D

## Velocity in pixels per second
@export var speed := Vector2(60, 60);
@export var Bullet: PackedScene

@onready var config = get_node("/root/Config")
@onready var game_state = get_node("/root/GameState")

const Explosion = preload("res://scenes/effects/explosion.tscn")
const ShootSound = preload("res://assets/audio/shoot.wav")
const DeathSound = preload("res://assets/audio/player-death.wav")

# Size of the game window.
@onready var screen_size = get_viewport_rect().size

# Location in the spritesheet for the bank left sprite
const BANK_LEFT_REGION = Rect2(8, 0, 8, 8)
# Location in the spritesheet for the bank right sprite
const BANK_RIGHT_REGION = Rect2(24, 0, 8, 8)
# Location in the spritesheet for the idle sprite
const IDLE_REGION = Rect2(16, 0, 8, 8)

var bullet_timer := Timer.new()
var state := Constants.PlayerState.Alive
var direction := Vector2.ZERO


func _ready() -> void:
	add_child(bullet_timer)
	bullet_timer.one_shot = true
	bullet_timer.wait_time = 0.1333
	bullet_timer.start()


func _process(delta: float) -> void:
	direction = Vector2.ZERO;
	process_input()

	$Sprite2D.set_region_rect(IDLE_REGION);

	if direction.x > 0:
		$Sprite2D.set_region_rect(BANK_RIGHT_REGION)
	elif direction.x < 0:
		$Sprite2D.set_region_rect(BANK_LEFT_REGION)

	position += direction * speed * delta
	position.x = clamp(position.x, 4, screen_size.x - 4)
	position.y = clamp(position.y, 4, screen_size.y - 4)


func _on_area_entered(area: Area2D) -> void:
	var is_enemy_projectile = area.is_in_group("enemy_projectiles")
	var is_enemy = area.is_in_group("enemies")
	var is_pickup = area.is_in_group("pickups")

	if is_pickup:
		area.queue_free()
		$PickupAudioPlayer.play()
		var result = game_state.increment_cherries()

		if result.bonus_message != null:
			var bonus_text = BonusTextFactory.create({
				message = result.bonus_message,
				position = area.position - Vector2(4, 4),
			})

			get_parent().add_child(bonus_text)

		return

	if is_enemy or is_enemy_projectile:
		if state != Constants.PlayerState.Alive:
			return

		Global.camera.shake(0.4, 4)

		if is_enemy_projectile:
			area.queue_free()

		$DeathAudioPlayer.play()

		ExplosionFactory.player({
			position = position,
			root = get_tree().root,
		})

		visible = false
		state = Constants.PlayerState.Respawning
		var lives = game_state.decrement_lives()
		if lives == 0:
			return

		# While the explosion is active, the player is invisible and invincible?
		# await explosion.completed

		position = config.entities.player.spawn_position
		visible = true
		state = Constants.PlayerState.Invincible

		# Flash the player sprite to indicate invincibility.
		var tween = create_tween().set_loops(10)
		tween.tween_property(self, "modulate:a", 0, 0.1)
		tween.tween_property(self, "modulate:a", 1, 0.1)
		tween.connect("finished", invulnerability_over)


func invulnerability_over() -> void:
	state = Constants.PlayerState.Alive

	# We need to check if we're overlapping with any areas of interest,
	# because we ignored some messages while invulnerable.
	var overlapping_areas = get_overlapping_areas()
	for area2d in overlapping_areas:
		_on_area_entered(area2d)


func process_input() -> void:
	if Input.is_action_pressed("move_right"):
		direction.x = 1

	if Input.is_action_pressed("move_left"):
		direction.x = -1

	if Input.is_action_pressed("move_up"):
		direction.y = -1

	if Input.is_action_pressed("move_down"):
		direction.y = 1

	if Input.is_action_pressed("fire") and bullet_timer.is_stopped():
		bullet_timer.start()
		$ShotAudioPlayer.play()

		var bullet = Bullet.instantiate()
		bullet.position = position + Vector2(0, -4)
		owner.add_child(bullet)
