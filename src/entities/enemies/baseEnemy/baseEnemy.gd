class_name BaseEnemy
extends CharacterBody3D

signal notify(target: Node3D, last_seen_pos: Vector3)	## Emitted through Alerted allies. [br][code]last_seen_pos[/code] should have a default of [code]Vector3.INF[/code].

var rotation_speed: float			## [code]exp_decay_angle()[/code] rotation rate.
var target: Node3D					## The target being tracked.
var target_last_seen := Vector3.INF	## The last seen position of the target.

@onready var physics: Physics 			= find_children("*", "Physics").get(0)
@onready var vision: Vision 			= find_children("*", "Vision").get(0)
@onready var navigation: Navigation 	= find_children("*", "Navigation").get(0)
@onready var stateMachine: StateMachine = find_children("*", "StateMachine").get(0)
@onready var path: Path 				= find_children("*", "Path").get(0)

func _ready() -> void:
	assert(physics, 	 "Entity does not have a Physics component.")
	assert(vision, 		 "Entity does not have a Vision component.")
	assert(navigation, 	 "Entity does not have a Navigation component.")
	assert(stateMachine, "Entity does not have a StateMachine component.")
	assert(path, 		 "Entity does not have a Path component.")

## Rotate to face a point [br]Should be called every frame while rotating
func rotate_to_look_at(pos: Vector3, delta: float) -> void:
	var d := pos - position
	var dest := atan2(-d.x, -d.z)
	rotation.y = Util.exp_decay_angle(rotation.y, dest, rotation_speed, delta)

func _on_navigation_moved(direction: Vector3, delta: float) -> void:
	rotate_to_look_at(global_position + direction, delta)
