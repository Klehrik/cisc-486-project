class_name Speech
extends Node3D

var label: WorldLabel

func _ready() -> void:
	label = WorldLabel.create()

func _physics_process(delta: float) -> void:
	label.position_3d = global_position

## Sets the new text for this label.
func talk(text: String, duration: float = 3.0) -> void:
	label.text = text
	
	# Popup animation
	label.scale.y = 0
	var tween := label.create_tween()
	tween.tween_property(label, "scale:y", 1, 0.2)
	tween.tween_interval(duration)
	tween.tween_property(label, "scale:y", 0, 0.2)
