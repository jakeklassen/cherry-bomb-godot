extends Area2D

@export var lives: int = 4
@export var max_lives: int = 4
@export var cherries: int  = 0
@export var score: int = 0
@export var wave: int = 0
@export var max_waves: int = 9

# highscore loading?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("quit"):
		# At some point show a menu and don't just kill the game
		get_tree().quit();
