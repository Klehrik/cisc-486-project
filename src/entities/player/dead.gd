extends State

const tween_time := 1.0
const flicker_frames := 4	## Frames alternating visible/non-visible.

var do_flickering := true

@onready var _owner: Player = owner

func on_push() -> void:
	_owner.physics.move_vec = Vector3.ZERO
	
	var tween := _owner.create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	var model: Node3D = _owner.get_node_or_null("Model")
	if model:
		# im so done	random bullshit go
		tween.tween_property(model, "rotation:x", PI/2, tween_time)
		await tween.finished
	do_flickering = false
	Cutscene.player_death()

func on_process(delta: float) -> void:
	_owner.visible = true
	if do_flickering and (Game.frame % (flicker_frames * 2)) < flicker_frames:
		_owner.visible = false
