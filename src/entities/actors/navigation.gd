class_name Navigation
extends NavigationAgent3D

# Path Height is >0 to compensate for the NavigationRegion mesh floating above the ground

signal moved(direction: Vector3, delta: float)	## Emitted every frame while navigating

@export var speed := 1.5	## Modified by states
@export_flags_3d_navigation var _navigation_layers: int

var is_navigating := false

@onready var _owner: CharacterBody3D = owner
@onready var physics: Physics = owner.find_children("*", "Physics").get(0)

func _ready() -> void:
	navigation_layers = _navigation_layers

func _physics_process(delta: float) -> void:
	if not physics:
		assert(false, "Entity does not have Physics component.")
	
	# Move to target point
	var next := get_next()
	if next != Vector3.INF:
		var move_dir := (next - _owner.global_position).normalized()
		physics.move_vec = move_dir * speed
		moved.emit(move_dir, delta)
	else:
		physics.move_vec = Vector3.ZERO
		is_navigating = false

## Begins navigating to a point.
func navigate_to_point(pos: Vector3) -> void:
	if pos == target_position:
		return
	target_position = pos
	is_navigating = true

## Returns the next path point while navigating, [br]or [code]Vector3.INF[/code] if not.
func get_next() -> Vector3:
	if not is_navigation_finished():
		return get_next_path_position()
	return Vector3.INF
