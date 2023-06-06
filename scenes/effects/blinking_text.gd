@tool

extends Node2D

@export var timeout: float = 0
@export var duration: float = 0.5

signal finished

var format_string = "[blink colors=#5F574FFF,#C2C3C7FF,#FFF1E8FF sequence=0,0,0,0,0,0,0,0,0,0,0,1,1,2,2,1,1,0 duration=%f][center][color=#5F574F]%s[/color][/center][/blink]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Text.text = format_string % [duration, ""]
	
	if timeout > 0:
		get_tree().create_timer(timeout).connect("timeout", func(): finished.emit())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func set_message(new_message: String) -> void:
	$Text.text = format_string % [duration, new_message]
