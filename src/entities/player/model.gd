extends Node3D

var facing := Vector3.RIGHT	## Facing direction for legs.

@onready var left_leg: Limb  	 = $LeftLeg
@onready var right_leg: Limb 	 = $RightLeg
@onready var leg_targets: Node3D = $LegTargets

@onready var left_leg_tmd  := left_leg.target_max_distance
@onready var right_leg_tmd := right_leg.target_max_distance
@onready var leg_targets_z := leg_targets.position.z
@onready var last_pos 	   := global_position

@onready var _owner: Player = owner

func _physics_process(delta: float) -> void:
	# Scale leg target position based on current movement vector
	# so that legs reset under character when not moving
	var physics := _owner.physics
	var last_move_dir := (global_position - last_pos).normalized()
	var scaling := (physics.move_vec.length() / _owner.move_speed)
	
	left_leg.target_max_distance  = scaling * left_leg_tmd
	right_leg.target_max_distance = scaling * right_leg_tmd
	left_leg.cross  = facing
	right_leg.cross = facing
	leg_targets.global_position = _owner.global_position + last_move_dir * abs(leg_targets_z)

	last_pos = global_position
