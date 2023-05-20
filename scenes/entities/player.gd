extends Area2D

## Velocity in pixels per second
@export var speed: int = 60;

# Size of the game window.
var screen_size;

const BANK_LEFT_REGION = Rect2(8, 0, 8, 8);
const BANK_RIGHT_REGION = Rect2(24, 0, 8, 8);
const IDLE_REGION = Rect2(16, 0, 8, 8);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	print_debug(screen_size);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO;
	
	if Input.is_action_pressed("move_right"):
		velocity.x = 1;
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -1;

	if Input.is_action_pressed("move_up"):
		velocity.y = -1;
	
	if Input.is_action_pressed("move_down"):
		velocity.y = 1;
		
	$Sprite2D.set_region_rect(IDLE_REGION);

	if velocity.x > 0:
		$Sprite2D.set_region_rect(BANK_RIGHT_REGION);
	elif velocity.x < 0:
		$Sprite2D.set_region_rect(BANK_LEFT_REGION);

	position += velocity * speed * delta
	position.x = clamp(position.x, 4, screen_size.x - 4)
	position.y = clamp(position.y, 4, screen_size.y - 4)
