class_name BonusTextFactory

const BlinkingText = preload("res://scenes/effects/blinking_text.tscn")
const Mover = preload("res://scripts/components/mover.gd")

static func create(args) -> Node2D:
	assert(args.message != null, "BonusTextFactory: message is null")
	assert(args.position != null, "BonusTextFactory: position is null")

	var bonus_score_text = BlinkingText.instantiate()
	bonus_score_text.timeout = 2
	bonus_score_text.duration = 0.1
	bonus_score_text.colors = [Pico8.Colors.Color7, Pico8.Colors.Color8] as Array[Color]
	bonus_score_text.sequence = [0, 1] as Array[int]
	bonus_score_text.message = args.message
	bonus_score_text.position = args.position
	bonus_score_text.z_index = 1000

	var mover_node = Node2D.new()
	mover_node.set_script(Mover)
	mover_node.direction = Vector2(0, -1)
	mover_node.velocity = Vector2(15, 15)
	mover_node.parent = bonus_score_text
	bonus_score_text.add_child(mover_node)

	return bonus_score_text
