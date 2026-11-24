class_name Pickup
extends Area3D

const rot_speed     := PI/3		## Rotations per second.
const y_speed_scale := 0.02
const y_offset 	    := Vector3.UP * 0.15

@onready var start_position := position

func _physics_process(delta: float) -> void:
	position = start_position + (cos(Game.frame * y_speed_scale) * y_offset)
	rotation.y += rot_speed * delta

func play_animation() -> void:
	SFX.play("Collect", global_position)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	var t := 0.5
	tween.tween_property(self, "position:y", position.y + 4.0, t)
	tween.tween_property(self, "scale:x", 0.0, t)
	tween.tween_property(self, "scale:z", 0.0, t)
	tween.tween_property(self, "scale:y", 2.0, t)
	await tween.finished
	queue_free()
