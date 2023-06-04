extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("quit"):
		# At some point show a menu and don't just kill the game
		get_tree().quit();

	# https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html 
	if Input.is_anything_pressed():
		var current_screen = self.name

		if current_screen == "TitleScreen":
			# Delay a little to avoid the abrupt sound cut off
			await get_tree().create_timer(0.15).timeout
			get_tree().change_scene_to_file("res://scenes/screens/game_screen.tscn")
