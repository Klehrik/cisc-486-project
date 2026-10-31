class_name Navigation
extends NavigationAgent3D

signal moved(direction: Vector3, delta: float)

@export var speed := 1.5

var is_navigating := false

@onready var _owner: CharacterBody3D = owner

func _physics_process(delta: float) -> void:
	var physics: Physics = _owner.get_node("Physics")
	if not physics:
		return
	
	# Move to target point
	var move_vec := Vector3.ZERO
	var next := get_next()
	if next != Vector3.INF:
		var move_dir := (next - _owner.global_position).normalized()
		physics.move_vec = move_dir * speed
		moved.emit(move_dir, delta)
	else:
		physics.move_vec = Vector3.ZERO
		is_navigating = false

func navigate_to_point(target: Vector3) -> void:
	target_position = target
	is_navigating = true

func get_next() -> Vector3:
	if not is_navigation_finished():
		var next := get_next_path_position()
		return Vector3(next.x, 0, next.z)	# The NavMesh is floating off the ground for some reason
	return Vector3.INF
