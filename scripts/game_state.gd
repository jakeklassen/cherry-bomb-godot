extends Node

signal lives_changed(old_value: int, new_value: int)
signal score_changed(old_value: int, new_value: int)

var current_lives: int = 4
var max_lives: int = 4
var current_cherries: int  = 0
var current_score: int = 0
var current_wave: int = 0
var max_waves: int = 9

func increment_lives() -> int:
	var previous_lives = current_lives
	current_lives = current_lives - 1 if current_lives > 0 else 0

	if previous_lives != current_lives:
		lives_changed.emit(previous_lives, current_lives)

	return current_lives

func increment_score(score: int) -> int:
	score_changed.emit(current_score, current_score + score)
	current_score += score

	return current_score

func increment_cherries() -> int:
	# Once we reach 10 cherries, reset and grant a score bonus
	if current_cherries == 9:
		increment_score(500)
		current_cherries = 0
	else:
		current_cherries += 1

	return current_cherries

func increment_wave() -> int:
	if current_wave == max_waves:
		return max_waves

	current_wave += 1

	return current_wave
