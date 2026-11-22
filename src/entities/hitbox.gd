class_name Hitbox
extends Area3D

signal hit(hitbox: Hitbox, hurtbox: Hurtbox)	## Emitted when this hitbox enters a hurtbox, before damage application.

var damage    := 0.0:			## Damage of hitbox.
	get():
		return damage
	set(value):
		damage = max(value, 0.0)
var stun	  := 0.0:			## Stun buildup of hitbox.
	get():
		return stun
	set(value):
		stun = max(value, 0.0)
var kb_vec 	  := Vector3.ZERO	## Knockback vector of hitbox.
var lifetime  := -1.0			## Lifetime of hitbox (in seconds). [br]If [code]-1[/code], will persist forever.
var is_active := true			## Hurtboxes should check this before applying anything.

@onready var cube:   CollisionShape3D = $Cube
@onready var sphere: CollisionShape3D = $Sphere

## Calling this will enable the Cube hitbox. [br]
## [code]target[/code] is the position to face. [br]
## If [code]centered = false[/code], the starting end aligns with [code]pos[/code].
func set_orientation(pos: Vector3, target: Vector3, size: Vector3, centered: bool = true) -> void:
	# Set starting position and orientation
	global_position = pos
	look_at(target)
	
	# Modify collision shape
	cube.shape = cube.shape.duplicate()
	cube.shape.size = size
	
	# Offset shape -z so that an end aligns with starting position
	if not centered:
		cube.position.z = -size.z / 2
	
	cube.disabled = false
	
## Calling this will enable the Sphere hitbox.
func set_sphere(pos: Vector3, radius: float) -> void:
	global_position = pos
	
	# Modify collision shape
	sphere.shape = sphere.shape.duplicate()
	sphere.shape.radius = radius
	
	sphere.disabled = false

func _physics_process(delta: float) -> void:
	if lifetime > 0:
		lifetime -= delta
		if lifetime <= 0:
			queue_free()
