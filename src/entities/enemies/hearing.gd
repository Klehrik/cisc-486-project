class_name Hearing
extends Node3D

@export var strength := 1.0		## Multiplier for range of incoming sound events.
signal heard(pos: Vector3)		## Emitted when a noise is heard.

func _ready() -> void:
	Event.noise.connect(_on_event_noise)
	
func _on_event_noise(pos: Vector3, sound_range: float) -> void:
	if (global_position - pos).length() <= sound_range * strength:
		heard.emit(pos)
