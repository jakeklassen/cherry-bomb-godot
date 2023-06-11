@tool

extends Node2D

@export var colors: Array[Color] = [
	Pico8.Colors.Color5,
	Pico8.Colors.Color6,
	Pico8.Colors.Color7,
]
@export var sequence: Array[int] = [0,0,0,0,0,0,0,0,0,0,0,1,1,2,2,1,1,0]
@export var duration: float = 0.5
@export var message: String = ""
@export var timeout: float = 0

signal finished

var format_string = "[blink colors={colors} sequence={sequence} duration={duration}][center][color=5F574F]{message}[/color][/center][/blink]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Text.text = format_string.format({
		colors = colors_to_html(colors),
		duration = duration,
		message = message,
		sequence = sequence_to_str(sequence)
	})

	if timeout > 0:
		get_tree().create_timer(timeout).connect("timeout", finish)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()


func finish() -> void:
	finished.emit()
	queue_free()


func set_message(new_message: String) -> void:
	$Text.text = format_string.format({
		colors = colors_to_html(colors),
		duration = duration,
		message = new_message,
		sequence = sequence_to_str(sequence)
	})


func set_colors(new_colors: Array[Color]) -> void:
	colors = new_colors


func set_sequence(new_sequence: Array[int]) -> void:
	sequence = new_sequence


func colors_to_html(to_convert: Array[Color]) -> String:
	return to_convert.reduce(func(acc, color): return acc + "," + color.to_html(), "")


func sequence_to_str(to_convert: Array[int]) -> String:
	return to_convert.reduce(func(acc, num): return acc + "," + str(num), "")
