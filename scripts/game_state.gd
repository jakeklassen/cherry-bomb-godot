extends Node


signal cherries_changed(old_value: int, new_value: int)
signal lives_changed(old_value: int, new_value: int)
signal score_changed(old_value: int, new_value: int)
signal player_dead


var current_lives: int = 4
var max_lives: int = 4
var current_cherries: int  = 0
var current_score: int = 0
var current_wave: int = 0
var max_waves: int = 9


func reset() -> void:
	current_cherries = 0
	current_lives = max_lives
	current_score = 0
	current_wave = 0


func increment_lives() -> int:
	if current_lives == max_lives:
		return max_lives

	var previous_lives = current_lives
	current_lives = current_lives + 1

	if previous_lives != current_lives:
		lives_changed.emit(previous_lives, current_lives)

	return current_lives


func decrement_lives() -> int:
	var previous_lives = current_lives
	current_lives = current_lives - 1

	if previous_lives != current_lives:
		lives_changed.emit(previous_lives, current_lives)

	if current_lives <= 0:
		player_dead.emit()
		return 0

	return current_lives


func increment_score(score: int) -> int:
	score_changed.emit(current_score, current_score + score)
	current_score += score

	return current_score


func increment_cherries():
	var previous_cherries = current_cherries
	var bonus_message = null

	# Once we reach 10 cherries, reset and grant a score bonus
	if current_cherries == 9:
		if current_lives < max_lives:
			increment_lives()
			bonus_message = "1UP!"
		else:
			increment_score(5000)
			bonus_message = "5000"

		current_cherries = 0
	else:
		current_cherries += 1

	cherries_changed.emit(previous_cherries, current_cherries)

	return {
		bonus_message = bonus_message,
		cherries = current_cherries,
	}


func increment_wave() -> int:
	if current_wave == max_waves:
		return max_waves

	current_wave += 1

	return current_wave
