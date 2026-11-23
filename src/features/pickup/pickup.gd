class_name Pickup
extends Area3D

@export var equipment_script: Script
var equipment: Equipment
var acquired := false

const rot_speed     := PI/3		## Rotations per second.
const y_speed_scale := 0.02
const y_offset 	    := Vector3.UP * 0.15

@onready var start_position := position

func _physics_process(delta: float) -> void:
	position = start_position + (cos(Game.frame * y_speed_scale) * y_offset)
	rotation.y += rot_speed * delta
	
	# Try to get equipment and spawn model
	if not equipment:
		equipment = equipment_script.new(1)
		if equipment and equipment.model:
			var m = equipment.model.instantiate()
			add_child(m)
			for do: DisplayOrigin in find_children("*", "DisplayOrigin"):
				m.position -= do.position
				break
			m.position.y += 0.5	# uh huh (i moved everything 0.5 up)

func _on_body_entered(body: Node3D) -> void:
	if acquired:
		return
	Event.pickup.emit(equipment, self)
	
## To be called by acquirer if successful.
func mark_acquired() -> void:
	if acquired:
		return
	acquired = true
	
	# Animation
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	var t := 0.5
	tween.tween_property(self, "position:y", position.y + 4.0, t)
	tween.tween_property(self, "scale:x", 0.0, t)
	tween.tween_property(self, "scale:z", 0.0, t)
	tween.tween_property(self, "scale:y", 2.0, t)
	await tween.finished
	queue_free()
