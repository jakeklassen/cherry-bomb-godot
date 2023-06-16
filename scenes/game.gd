extends Node2D


enum GamePhase {
	GameOver,
	GameWon,
	Playing,
	TitleScreen,
	Uninitialized
}


const GameplayScreen = preload("res://scenes/screens/game_screen.tscn")
const TitleScreen = preload("res://scenes/screens/title_screen.tscn")

var state := GamePhase.Uninitialized


func _ready() -> void:
	var master_sound = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_sound, false)

	if state == GamePhase.Uninitialized:
		state = GamePhase.TitleScreen
		get_tree().root.call_deferred("add_child", TitleScreen.instantiate())


func _process(_delta: float) -> void:
	if Input.is_action_pressed("quit"):
		# At some point show a menu and don't just kill the game
		get_tree().quit();

	if Input.is_anything_pressed() and state == GamePhase.TitleScreen and $AnyKeyPressedTimer.is_stopped():
		$AnyKeyPressedTimer.start()
		var current_screen = get_node("/root/TitleScreen")
		if current_screen == null:
			return

		current_screen.queue_free()
		state = GamePhase.Playing
		GameState.reset()

		await get_tree().create_timer(0.2).timeout

		var next_screen = GameplayScreen.instantiate()
		next_screen.connect("game_over", game_over)
		get_tree().root.call_deferred("add_child", next_screen)

	if Input.is_anything_pressed() and state == GamePhase.GameOver and $AnyKeyPressedTimer.is_stopped():
		$AnyKeyPressedTimer.start()
		var current_screen = get_node("/root/GameScreen")
		current_screen.queue_free()
		state = GamePhase.TitleScreen

		await get_tree().create_timer(0.2).timeout

		var next_screen = TitleScreen.instantiate()
		get_tree().root.call_deferred("add_child", next_screen)


func game_over() -> void:
	state = GamePhase.GameOver
