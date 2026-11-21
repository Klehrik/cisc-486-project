extends Node3D

@onready var left_leg: Limb  	 = $LeftLeg
@onready var right_leg: Limb 	 = $RightLeg
@onready var leg_targets: Node3D = $LegTargets

@onready var left_leg_tmd  := left_leg.target_max_distance
@onready var right_leg_tmd := right_leg.target_max_distance
@onready var leg_targets_z := leg_targets.position.z

@onready var _owner: Player = owner

func _physics_process(delta: float) -> void:
	# Scale leg target position based on current movement vector
	# so that legs reset under character when not moving
	var physics := _owner.physics
	var last_move_dir := _owner.last_move_dir
	var scaling := (physics.move_vec.length() / _owner.move_speed)
	
	left_leg.cross = last_move_dir
	left_leg.target_max_distance = scaling * left_leg_tmd
	right_leg.cross = last_move_dir
	right_leg.target_max_distance = scaling * right_leg_tmd
	leg_targets.position.z = scaling * leg_targets_z
