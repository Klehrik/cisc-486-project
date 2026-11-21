class_name Projectile
extends RayCast3D

var velocity: Vector3:	## The velocity of the projectile.
	get():
		return velocity
	set(value):
		# Force raycast update when setting velocity so that it
		# still triggers if the projectile is right beside a target
		velocity = value
		target_position = velocity * 1.0/Engine.physics_ticks_per_second
		force_raycast_update()
var damage: float:		## Damage of projectile.
	get():
		return hitbox.damage
	set(value):
		hitbox.damage = value
var stun: float:		## Stun buildup of projectile.
	get():
		return hitbox.stun
	set(value):
		hitbox.stun = value
var kb_vec: Vector3:	## Knockback vector of hitbox.
	get():
		return hitbox.kb_vec
	set(value):
		hitbox.kb_vec = value
var pierce := 0			## Number of targets the projectile can pierce.

@onready var hitbox: Hitbox = $Hitbox
@onready var col_shape: CollisionShape3D = $Hitbox/CollisionShape3D2
@onready var trail: Trail3D = $Trail

func _ready() -> void:
	target_position = Vector3.ZERO

## Team 1 - Player [br]Team 2 - Enemies
func set_team(team: int) -> void:
	match team:
		1:
			collision_mask = 1 | 1 << 2
			hitbox.collision_layer = 1 << 3
		2:
			collision_mask = 1 | 1 << 1
			hitbox.collision_layer = 1 << 4

## Scales the projectile hitbox radius and trail width.
func scale_projectile(scaling: float) -> void:
	var shape: SphereShape3D = col_shape.shape.duplicate()
	shape.radius *= scaling
	col_shape.shape = shape
	trail.width = trail.width * scaling

func on_hit() -> void:
	$Destroy.start()
	if pierce > 0:
		pierce -= 1
	else:
		hitbox.is_active = false
		process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	position += velocity * delta
	
	# The projectile may move fast enough to not have
	# Hitbox area collide and trigger with a target
	# As such, target collision is checked from the raycast too
	#	If there is a hit, move proj to hit position so the area triggers
	if is_colliding():
		position = get_collision_point()
		if get_collider().collision_layer & 1:
			on_hit()

func _on_hitbox_hit(hitbox: Hitbox, hurtbox: Hurtbox) -> void:
	on_hit()
