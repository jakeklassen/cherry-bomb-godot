extends Node2D

var player_sighted := false

func _process(_delta: float) -> void:
	if player_sighted:
		queue_free()

	var player = get_tree().get_nodes_in_group("players").pop_front()
	if not player:
		return

	var parent = get_parent()

	if parent.position.y > player.position.y:
		player_sighted = true
		parent.direction.y = 0
		parent.direction.x = 1 if parent.position.x < player.position.x else -1
