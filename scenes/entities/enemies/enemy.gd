@tool

extends Area2D

@export var id := Constants.EnemyType.Empty
@export var direction := Vector2(0, 0)
@export var velocity := Vector2(60, 60)
@onready var config = get_node("/root/Config")
@onready var game_state = get_node("/root/GameState")

const BlinkingText = preload("res://scenes/effects/blinking_text.tscn")
const EnemyBullet = preload("res://scenes/entities/enemies/enemy_bullet.tscn")
const GreenAlienSpriteFrames = preload("res://resources/sprite_frames/green_alien.tres")
const RedFlameGuySpriteFrames = preload("res://resources/sprite_frames/red_flame_guy.tres")
const SpinningShipSpriteFrames = preload("res://resources/sprite_frames/spinning_ship.tres")
const YellowShipSpriteFrames = preload("res://resources/sprite_frames/yellow_ship.tres")
const BossSpriteFrames = preload("res://resources/sprite_frames/boss.tres")
const LateralHunterAttack = preload("res://scripts/enemy_attack_patterns/lateral_hunter.gd")
const WaveAttack = preload("res://scripts/enemy_attack_patterns/wave.gd")
const Mover = preload("res://scripts/components/mover.gd")

var health: int
var score: int
var invulnerable := true
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
			velocity = Vector2(0, 75)
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
			velocity = Vector2(0, 10)
		Constants.EnemyType.Boss:
			$AnimatedSprite2D.set_sprite_frames(BossSpriteFrames)
			health = config.entities.enemies.boss.starting_health
			score = config.entities.enemies.boss.score
			sprite_size = Rect2(0, 0, 32, 24)

	$AnimatedSprite2D.play("default")


func _process(delta: float) -> void:
	position += direction * velocity * delta


func take_damage(damage: int) -> void:
	health = health - damage if not invulnerable else health

	if health <= 0:
		$DeathAudioPlayer.play()
		ExplosionFactory.enemy({ position = position, root = get_parent() })

		var score_factor = 2 if state == Constants.EnemyState.Attack else 1
		game_state.increment_score(score_factor * score)

		if score_factor == 2:
			var bonus_score_text = BonusTextFactory.create({
				message = str(score_factor * score),
				position = position - Vector2(4, 4),
			})

			get_parent().add_child(bonus_score_text)

		var cherry_chance = 0.2 if state == Constants.EnemyState.Attack else 0.1
		if randf() < cherry_chance:
			CherryFactory.create({ position = position, root = get_parent() })

		queue_free()
	else:
		$HitAudioPlayer.play()
		var shockwave = Shockwave.new({
			color = Pico8.Colors.Color9,
			radius = 2,
			target_radius = 6,
			speed = 30,
			position = Vector2(0, 2)
		})

		# Flash sprite with material shader
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


func attack() -> void:
	state = Constants.EnemyState.Attack

	$AnimatedSprite2D.speed_scale = 3 if id == Constants.EnemyType.SpinningShip else 2

	if id in [Constants.EnemyType.GreenAlien, Constants.EnemyType.RedFlameGuy]:
		await shake().finished
	else:
		await get_tree().create_timer(1).timeout

	direction = Vector2(0, 1)

	if id in [Constants.EnemyType.GreenAlien, Constants.EnemyType.RedFlameGuy]:
		var attack_pattern_node = Node2D.new()
		attack_pattern_node.set_script(WaveAttack)
		add_child(attack_pattern_node)

	if id == Constants.EnemyType.SpinningShip:
		var attack_pattern_node = Node2D.new()
		attack_pattern_node.set_script(LateralHunterAttack)
		add_child(attack_pattern_node)


func shake() -> Tween:
	var shake_tween = create_tween().set_loops(10)
	shake_tween.tween_property(self, "position:x", 2, 0.1).as_relative()
	shake_tween.tween_property(self, "position:x", -2, 0.1).as_relative()

	return shake_tween


func start_wave_pattern() -> void:
	var direction_x = 1 if randf() < 0.5 else -1

	if position.x < 24:
		direction_x = 1
	elif position.x > 104:
		direction_x = -1

	var start_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	start_tween.tween_property(self, "position:x", direction_x * 8, 0.6)

	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_loops()
	tween.tween_property(self, "position:x", direction_x * 20, 0.8) \
		.as_relative()
	tween.tween_property(self, "position:x", -direction_x * 20, 0.8) \
		.as_relative()


func fire(target = null) -> void:
	var bullet = EnemyBullet.instantiate()
	get_tree().root.add_child(bullet)
	$ShotAudioPlayer.play()

	bullet.position = position + Vector2(0, 2)
	bullet.direction = Vector2(0, 1)

	if target is Vector2:
		bullet.direction = (target - position).normalized()


func fire_spread(count: int) -> void:
	var time = Time.get_ticks_msec()
	var step = 2.0 * PI / count
	var radius = Vector2(4, 0)

	for i in range(count):
		var bullet = EnemyBullet.instantiate()

		get_tree().root.add_child(bullet)

		# bullet.transform = self.transform.translated(Vector2(0, 2))
		bullet.position = position + radius.rotated(time / 2.0 + step * i)
		bullet.direction = (bullet.position - position).normalized()
		bullet.velocity = Vector2(40, 40)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
