class_name Separation
extends Area3D

## Used to separate entities so they don't occupy the same position

signal collision(push: Vector3)	## [code]push[/code] is the difference between self and other body.

func _physics_process(delta: float) -> void:
	for area: Area3D in get_overlapping_areas():
		collision.emit(global_position - area.global_position)
