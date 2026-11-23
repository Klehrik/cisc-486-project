extends Node3D

const tween_t 	  := 5.0
const move_amount := 2.95	# Each door is 3m wide at base

var is_open := false

func _ready() -> void:
	open()

func open() -> void:
	if is_open:
		return
	is_open = true
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(1.0)
	tween.tween_property($Left,  "position:x", $Left.position.x - move_amount, tween_t)
	tween.parallel()
	tween.tween_property($Right, "position:x", $Right.position.x + move_amount, tween_t)
	
func close() -> void:
	if not is_open:
		return
	is_open = false
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(1.0)
	tween.tween_property($Left,  "position:x", $Left.position.x + move_amount, tween_t)
	tween.parallel()
	tween.tween_property($Right, "position:x", $Right.position.x - move_amount, tween_t)
