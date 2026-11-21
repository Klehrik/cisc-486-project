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
var health = health_max:
	get():
		return health
	set(value):
		health = clamp(value, 0, health_max)

var hitboxes: Array[Hitbox] = []	## List of hitboxes that already hit this.

func _on_area_entered(area: Area3D) -> void:
	if area is Hitbox and area not in hitboxes:
		var hitbox := area as Hitbox
		if hitbox.is_active:
			hitboxes.append(hitbox)
			hitbox.hit.emit(hitbox, self)
			prehurt.emit(self, hitbox)
			health -= hitbox.damage
			hurt.emit(self, hitbox)
		
			# DEBUG
			print("Ow for ", hitbox.damage, " dmg; health: ", health, " / ", health_max)

func _physics_process(delta: float) -> void:
	if hitboxes:
		if not is_instance_valid(hitboxes.back()):
			hitboxes.pop_back()
