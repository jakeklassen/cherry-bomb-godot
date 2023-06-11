extends Camera2D

# https://www.youtube.com/watch?v=4mll7LKIITM

@export var shake_amount := 0
@export var default_offset := offset


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	Global.camera = self
	randomize()


func _process(delta: float) -> void:
	offset = Vector2(
		randf_range(-1, 1) * shake_amount,
		randf_range(-1, 1) * shake_amount
	)


func shake(duration: float, amount: float) -> void:
	$Timer.wait_time = duration
	shake_amount = amount
	set_process(true)
	$Timer.start()


func _on_timer_timeout() -> void:
	set_process(false)
	create_tween() \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_IN_OUT) \
		.tween_property(self, "offset", default_offset, 0.1)
