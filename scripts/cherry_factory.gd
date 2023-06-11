class_name CherryFactory

const CherryScene = preload("res://scenes/entities/cherry.tscn")


static func create(args) -> void:
	var cherry = CherryScene.instantiate()
	cherry.position = args.position

	args.root.call_deferred("add_child", cherry)
