class_name Hitbox
extends Area3D

signal hit(hurtbox: Hurtbox)	## Emitted when this hitbox enters a hurtbox.

var damage   := 0.0				## Damage of hitbox.
var kb_vec 	 := Vector3.ZERO	## Knockback vector of hitbox.
var lifetime := -1.0			## Lifetime of hitbox (in seconds). [br]If [code]-1[/code], will persist forever.

@onready var shape: CollisionShape3D = $CollisionShape3D

## Calling this will enable the hitbox; do it last. [br]
## [code]target[/code] is the position to face.
func init(pos: Vector3, target: Vector3, size: Vector3) -> void:
	# Set starting position and orientation
	global_position = pos
	look_at(target)
	
	# Modify collision shape
	shape.shape = shape.shape.duplicate()
	shape.shape.size = size
	
	# Offset shape -z so that an end aligns with starting position
	shape.position.z = -size.z / 2
	
	shape.disabled = false

func _physics_process(delta: float) -> void:
	if lifetime > 0:
		lifetime -= delta
		if lifetime <= 0:
			queue_free()
