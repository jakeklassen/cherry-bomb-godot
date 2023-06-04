@tool

extends Node2D

@export var message: String
@export var duration: float = -1
@onready var text_label = $Text

var format_string = "[blink colors=#5F574FFF,#C2C3C7FF,#FFF1E8FF sequence=0,0,0,0,0,0,0,0,0,0,0,1,1,2,2,1,1,0 duration=0.5][center][color=#5F574F]%s[/color][/center][/blink]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_label.text = format_string % message
	
	if duration > 0:
		get_tree().create_timer(duration).connect("timeout", queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
