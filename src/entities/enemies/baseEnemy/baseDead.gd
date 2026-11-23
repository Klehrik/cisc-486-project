class_name BaseDead
extends State

const tween_time := 1.0
const flicker_frames := 4	## Frames alternating visible/non-visible.

@onready var _owner: BaseEnemy = owner

func on_enter() -> void:
	var tween := _owner.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	var model: Node3D = _owner.get_node_or_null("Model")
	if model:
		# im so done	random bullshit go
		tween.tween_property(model, "rotation:x", PI/2, tween_time)
		await tween.finished
	_owner.queue_free()

func on_process(delta: float) -> void:
	_owner.visible = true
	if (Game.frame % (flicker_frames * 2)) < flicker_frames:
		_owner.visible = false
