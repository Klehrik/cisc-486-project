class_name Hurtbox
extends Area3D

signal hurt(hitbox: Hitbox)	## Emitted when a hitbox enters this hurtbox.

var hitboxes: Array[Hitbox] = []	## List of hitboxes that already hit this.

func _on_area_entered(area: Area3D) -> void:
	if area is Hitbox and area not in hitboxes:
		hitboxes.append(area)
		area.hit.emit(self)
		hurt.emit(area)

func _physics_process(delta: float) -> void:
	if hitboxes:
		if not is_instance_valid(hitboxes.back()):
			hitboxes.pop_back()
