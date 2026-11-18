class_name Projectile
extends RayCast3D

var velocity: Vector3
var damage: float:		## Damage of projectile.
	get():
		return hitbox.damage
	set(value):
		hitbox.damage = value
var kb_vec: Vector3:	## Knockback vector of hitbox.
	get():
		return hitbox.kb_vec
	set(value):
		hitbox.kb_vec = value

@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	target_position = Vector3.ZERO

func set_team(team: int) -> void:
	match team:
		1:
			collision_mask = collision_mask | 1 << 2
			hitbox.collision_layer = 1 << 3
		2:
			collision_mask = collision_mask | 1 << 1
			hitbox.collision_layer = 1 << 4

func on_hit() -> void:
	$Destroy.start()
	process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	var d := velocity * delta
	position += d
	target_position = d
	
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
