class_name Hurtbox
extends Area3D

signal prehurt(hitbox: Hitbox)	## Emitted when a hitbox enters this hurtbox, before damage application.
signal hurt(hitbox: Hitbox)		## Emitted when a hitbox enters this hurtbox, after damage application.

@export var health_max: float = 1.0:
	get():
		return health_max
	set(value):
		health_max = value
		if value > health:
			health = value
var health = health_max:
	get():
		return health
	set(value):
		health = clamp(value, 0, health_max)

var hitboxes: Array[Hitbox] = []	## List of hitboxes that already hit this.

func _on_area_entered(area: Area3D) -> void:
	if area is Hitbox and area not in hitboxes:
		var hitbox := area as Hitbox
		hitboxes.append(hitbox)
		hitbox.hit.emit(self)
		prehurt.emit(hitbox)
		health -= hitbox.damage
		hurt.emit(hitbox)
		
		# DEBUG
		print("Ow for ", hitbox.damage, " dmg; health: ", health, " / ", health_max)

func _physics_process(delta: float) -> void:
	if hitboxes:
		if not is_instance_valid(hitboxes.back()):
			hitboxes.pop_back()
