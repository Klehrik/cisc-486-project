class_name UseOrigin
extends Marker3D

@export var follow: UseOrigin	## Another UseOrigin to follow.

var target: Vector3					## Target position for equipment use.
@onready var parent: Node3D = owner	## The owner of this UseOrigin.

func _physics_process(delta: float) -> void:
	if follow:
		global_position = follow.global_position
