class_name StatusLabel
extends Node3D

enum Status {
	PATROL,
	SUSPICION,
	ALERT,
	SEARCH,
	STUNNED,
}

var label: WorldLabel

func _ready() -> void:
	label = WorldLabel.create()
	label.size = 1.5

func _physics_process(delta: float) -> void:
	label.position_3d = global_position

## Sets the status of this label.
func set_status(status: Status) -> void:
	match status:
		Status.PATROL:
			label.text = ""
			
		Status.SUSPICION:
			label.text  = "?"
			label.color = Color("fee761")
			
		Status.ALERT:
			label.text  = "!"
			label.color = Color("f77622")
			
		Status.SEARCH:
			label.text  = "?"
			label.color = Color("fee761")
			
		Status.STUNNED:
			label.text  = "~"
			label.color = Color("0095e9")

	# Popup animation
	label.scale.y = 0
	var tween := label.create_tween()
	tween.tween_property(label, "scale:y", 1, 0.2)

func _on_tree_exiting() -> void:
	label.queue_free()
