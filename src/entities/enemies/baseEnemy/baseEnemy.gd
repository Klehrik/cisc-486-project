class_name BaseEnemy
extends CharacterBody3D

signal notify(target: Node3D, last_seen_pos: Vector3)	## Emitted through Alerted allies. [br][code]last_seen_pos[/code] should have a default of [code]Vector3.INF[/code].

var rotation_speed: float			## [code]exp_decay_angle()[/code] rotation rate.
var target: Node3D					## The target being tracked.
var target_last_seen := Vector3.INF	## The last seen position of the target.
var rotate_while_moving := true		## If [code]true[/code], rotate in navigation direction.
var alerted_once := false			## [code]true[/code] if the enemy has been alerted before. [br]Resets on going back to Patrol.

var stun_time: float				## Remaining stun time (in seconds).
@export var stun_threshold := 1.0	## Required level of [code]stun_time[/code] to enter Stunned state.
@export var stun_multiplier := 1.0	## Amount of [code]stun_time[/code] added based on incoming attack stun value.

@onready var physics: Physics 			 = find_children("*", "Physics").get(0)
@onready var vision: Vision 			 = find_children("*", "Vision").get(0)
@onready var navigation: Navigation 	 = find_children("*", "Navigation").get(0)
@onready var state_machine: StateMachine = find_children("*", "StateMachine").get(0)
@onready var path: Path 				 = find_children("*", "Path").get(0)
@onready var status_label: StatusLabel 	 = find_children("*", "StatusLabel").get(0)
@onready var speech: Speech 			 = find_children("*", "Speech").get(0)

func _ready() -> void:
	assert(physics, 	  "Entity does not have a Physics component.")
	assert(vision, 		  "Entity does not have a Vision component.")
	assert(navigation, 	  "Entity does not have a Navigation component.")
	assert(state_machine, "Entity does not have a StateMachine component.")
	assert(path, 		  "Entity does not have a Path component.")
	assert(status_label,  "Entity does not have a StatusLabel component.")
	assert(speech, 		  "Entity does not have a Speech component.")

## Rotate to face a point [br]Should be called every frame while rotating
func rotate_to_look_at(pos: Vector3, delta: float) -> void:
	var d := pos - position
	var dest := atan2(-d.x, -d.z)
	rotation.y = Util.exp_decay_angle(rotation.y, dest, rotation_speed, delta)

func _on_navigation_moved(direction: Vector3, delta: float) -> void:
	if rotate_while_moving:
		rotate_to_look_at(global_position + direction, delta)

func _on_hurtbox_hurt(hurtbox: Hurtbox, hitbox: Hitbox) -> void:
	# Apply knockback
	physics.kb_vec += hitbox.kb_vec
	
	# Add stun time
	stun_time += hitbox.stun * stun_multiplier
	if stun_time >= stun_threshold:
		
		# Kinda messy; might want to have each state handle this themselves
		if state_machine.current == $StateMachine/Patrol:
			state_machine.switch("Suspicion")
			
		state_machine.push("Stunned")
	
	if hurtbox.health <= 0:
		queue_free()
