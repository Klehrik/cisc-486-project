class_name Hurtbox
extends Area3D

signal prehurt(hurtbox: Hurtbox, hitbox: Hitbox)	## Emitted when a hitbox enters this hurtbox, before damage application.
signal hurt(hurtbox: Hurtbox, hitbox: Hitbox)		## Emitted when a hitbox enters this hurtbox, after damage application.

@export var health_max: float = 1.0:
	get():
		return health_max
	set(value):
		health_max = max(value, 0.0)
		if value > health:
			health = value
		health = min(health, health_max)
@export var recover_speed := 0.0	## Speed at which recoverable health is regained (in HP/s).
@export var recover_delay := 3.0	## Delay before health recovery (in seconds).
var health := health_max:
	get():
		return health
	set(value):
		health = clamp(value, 0, health_max)
var recoverable_health: float	## Remaining recoverable health. [br]Half of damage taken is added to this.
var recover_delay_value: float
var is_active := true	## Should check this before applying anything.

var hitboxes: Array[Hitbox] = []	## List of hitboxes that already hit this.

func _on_area_entered(area: Area3D) -> void:
	if not is_active:
		return
	if area is Hitbox and area not in hitboxes:
		var hitbox := area as Hitbox
		if hitbox.is_active:
			hitboxes.append(hitbox)
			hitbox.hit.emit(hitbox, self)
			prehurt.emit(self, hitbox)
			health -= hitbox.damage
			recoverable_health += hitbox.damage * 0.5
			recover_delay_value = recover_delay
			hurt.emit(self, hitbox)
			
			# DEBUG
			print("Ow for ", hitbox.damage, " dmg; health: ", health, " / ", health_max)

func _physics_process(delta: float) -> void:
	if hitboxes:
		if not is_instance_valid(hitboxes.back()):
			hitboxes.pop_back()
	
	# Recover health for last hit taken
	if health > 0:
		if recover_delay_value > 0:
			recover_delay_value -= delta
		else:
			if recover_speed > 0 and recoverable_health > 0:
				health 			   += recover_speed * delta
				recoverable_health -= recover_speed * delta
	
	# Entity fell out of the world
	if global_position.y <= -25.0:
		owner.queue_free()
