class_name HUDPopup
extends Node2D

const tween_y  := 8.0
const tween_ty := 3.0
const tween_ta := 0.5

func start() -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", position.y - tween_y, tween_ty)
	tween.parallel().tween_property(self, "modulate:a", 1.0, tween_ta)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate:a", 0.0, tween_ta)
	await tween.finished
	queue_free()

static func add(text: String) -> void:
	var p := Scene.instantiate_global(Scene.popup, "Screen")
	p.position = Vector2(160, 160)
	p.get_node("Text").text = text
	p.start()
