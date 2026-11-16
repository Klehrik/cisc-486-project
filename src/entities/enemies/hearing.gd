class_name Hearing
extends Node3D

@export var strength := 1.0		## Multiplier for range of incoming sound events.
signal heard(pos: Vector3)		## Emitted when a noise is heard.

func _ready() -> void:
	Event.noise.connect(_on_event_noise)
	
func _on_event_noise(pos: Vector3, sound_range: float) -> void:
	# Get navigation path distance to noise position
	# 	Nearby enemies can hear from around short walls,
	# 	but not enemies in another area behind a long wall
	var map := get_world_3d().get_navigation_map()
	var path := NavigationServer3D.map_get_path(
		map,
		global_position,
		pos,
		true
	)
	var dist := 0.0
	for i in range(path.size() - 1):
		dist += path[i].distance_to(path[i + 1])
	
	if dist <= sound_range * strength:
		heard.emit(pos)
