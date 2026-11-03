extends Node3D

# Should be added as a child scene of other features.

@export var sound_range := 10.0	## Range of noise when entered (in meters).

var bodies: Array[Node3D] = []	## List of bodies currently in hitbox.

func _ready() -> void:
	$EditorVisual.visible = false
	
	# Adjust hitbox based on root scaling
	var _scale = scale
	scale = Vector3.ONE
	
	var hitbox: Area3D = $Hitbox
	hitbox.position = Vector3(_scale.x / 2, _scale.y / 2, -_scale.z / 2)
	
	var shape: CollisionShape3D = $Hitbox/CollisionShape3D
	shape.shape = shape.shape.duplicate()
	shape.shape.size = _scale

func _physics_process(delta: float) -> void:
	for body in bodies:
		Event.stepped_on_noisy.emit(body, sound_range)

func _on_hitbox_body_entered(body: Node3D) -> void:
	bodies.append(body)

func _on_hitbox_body_exited(body: Node3D) -> void:
	bodies.erase(body)
