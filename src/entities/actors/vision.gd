class_name Vision
extends Marker3D

signal detected(target: Node3D)	## Emitted when a target is detected.

@export var fov   	:= 90.0:	## Total vision cone angle (in degrees).
	set(value):
		fov = value
		_fov_dot_product = cos(deg_to_rad(value/2))
@export var range 	:= 10.0		## Maximum vision range (in metres).
@export var group 	:= "Team 1"	## Scene group to scan for.
@export_flags_3d_physics var collision_mask: int = 1	## Obstructions collision mask

var _fov_dot_product := cos(deg_to_rad(45.0))

func _physics_process(delta: float) -> void:
	# Scan for targets within view
	var targets := get_tree().get_nodes_in_group(group)
	for t in targets:
		if can_see_point(t.global_position):
			detected.emit(t)
			return

## [code]true[/code] if the point is visible [br](within vision cone AND unobstructed)
func can_see_point(pos: Vector3, ignore_distance: bool = false) -> bool:
	return is_within_cone(pos, ignore_distance) and is_unobstructed(pos)

## [code]true[/code] if the point is within the vision cone
func is_within_cone(pos: Vector3, ignore_distance: bool = false) -> bool:
	var vec := pos - global_position
	if !ignore_distance and vec.length() > range:
		return false
	var facing := -global_transform.basis.z.normalized()
	var dot    := facing.dot(vec.normalized())
	if dot < _fov_dot_product:
		return false
	return true

## [code]true[/code] if the point is unobstructed from this position
func is_unobstructed(pos: Vector3) -> bool:
	var space_state := get_world_3d().direct_space_state
	var y_offset	:= Vector3.UP * 0.2
	var query 		:= PhysicsRayQueryParameters3D.create(global_position + y_offset, pos + y_offset, collision_mask)
	return space_state.intersect_ray(query).is_empty()
