class_name Noisy
extends Node3D

# Should be added as a child scene of other features.

@export var sound_range := 8.0	## Range of noise when entered (in metres).
## TODO: Add sound resource export here too when the time comes

var bodies: Dictionary[Node3D, bool] = {}	## Dict of bodies currently in hitbox.

func _ready() -> void:
	$EditorVisual.visible = false
	
	# Adjust hitbox based on root scaling
	var _scale = scale
	scale = Vector3.ONE
	
	#$EditorVisual.scale = _scale
	#$EditorVisual.position = Vector3(_scale.x / 2, _scale.y / 2, -_scale.z / 2)
	
	var hitbox: Area3D = $Hitbox
	hitbox.position = Vector3(_scale.x / 2, _scale.y / 2, -_scale.z / 2)
	
	var shape: CollisionShape3D = $Hitbox/CollisionShape3D
	shape.shape = shape.shape.duplicate()
	shape.shape.size = _scale
	
	Event.footstep.connect(_on_event_footstep)

func _on_hitbox_body_entered(body: Node3D) -> void:
	bodies[body] = true

func _on_hitbox_body_exited(body: Node3D) -> void:
	bodies.erase(body)

func _on_event_footstep(entity: Node3D, pos: Vector3) -> void:
	if bodies.has(entity):
		Event.noise.emit(pos, sound_range)
		## TODO: Play sound
