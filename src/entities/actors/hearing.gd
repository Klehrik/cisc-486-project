class_name Hearing
extends Node3D

@export var strength := 1.0		## Multiplier for range of incoming sound events.
signal heard(pos: Vector3)		## Emitted when a noise is heard.

func _ready() -> void:
	Event.sound.connect(_on_event_sound)
	
func _on_event_sound(pos: Vector3, range: float) -> void:
	if (global_position - pos).length() <= range * strength:
		heard.emit(pos)
