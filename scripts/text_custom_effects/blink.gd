@tool
extends RichTextEffect
class_name RichTextBlink

# Syntax: [blink colors=#ffffff33,#aabbcc33,#ddeeff33 sequence=0,1,2 duration=1[/blink]

# Define the tag name.
var bbcode = "blink"

var next_frame_time = 0
var frame_rate = 1
var current_color_index = 0

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	
	var colors: Array = char_fx.env.get("colors", [])
	var sequence: Array = char_fx.env.get("sequence", [])
	# In seconds
	var duration: float = char_fx.env.get("duration", 0)
	
	frame_rate = duration / sequence.size()
	
	if char_fx.elapsed_time >= next_frame_time:
		next_frame_time = char_fx.elapsed_time + frame_rate
		current_color_index = (current_color_index + 1) % sequence.size()
		
	char_fx.color = colors[sequence[current_color_index]]

	return true
