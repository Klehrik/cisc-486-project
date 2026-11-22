class_name HumanoidModel
extends Node3D

enum ArmPoses {
	NEUTRAL,	## Arms at sides.
	PISTOL,		## Two-handed pistol holding in front.
	RIFLE,		## Two-handed long weapon holding.
}

var facing := Vector3.RIGHT:	## Facing direction for limbs (normalized).
	get():
		return facing
	set(value):
		if value.length_squared() != 1.0:
			value = value.normalized()
		facing = value

var leg_target_dist_scale := 1.0	## Scaling value for limb target_max_distance.
var leg_target_pos_dist := 0.0		## z-offset of target marker positions.

var left_arm_offset: Vector3	## Offset from neutral in facing direction.
var right_arm_offset: Vector3	## Offset from neutral in facing direction.

@onready var left_leg: Limb  	 = $LeftLeg
@onready var right_leg: Limb 	 = $RightLeg
@onready var leg_targets: Node3D = $LegTargets

@onready var left_arm: Limb  	 = $LeftArm
@onready var right_arm: Limb 	 = $RightArm
@onready var left_arm_target: Marker3D  = $ArmTargets/LeftTarget
@onready var right_arm_target: Marker3D = $ArmTargets/RightTarget

@onready var left_leg_tmd  := left_leg.target_max_distance
@onready var right_leg_tmd := right_leg.target_max_distance
@onready var leg_targets_z := leg_targets.position.z
@onready var last_pos 	   := global_position

@onready var _owner: CharacterBody3D = owner

func _ready() -> void:
	set_arm_pose(ArmPoses.NEUTRAL)

func _physics_process(delta: float) -> void:
	_handle_legs()
	_handle_arms()

func set_arm_pose(pose: ArmPoses) -> void:
	match pose:
		ArmPoses.NEUTRAL:
			left_arm.rotation_dir  = 1.0
			right_arm.rotation_dir = 1.0
			left_arm_offset  = Vector3(-0.17, 0.28, -0.05)
			right_arm_offset = Vector3(0.17, 0.28, -0.05)
			
		ArmPoses.PISTOL:
			left_arm.rotation_dir  = -1.0
			right_arm.rotation_dir = -1.0
			left_arm_offset  = Vector3(-0.04, 0.5, -0.4)
			right_arm_offset = Vector3(0.04, 0.5, -0.4)
			
		ArmPoses.RIFLE:
			left_arm.rotation_dir  = -1.0
			right_arm.rotation_dir = -1.0

func _handle_legs() -> void:
	# Scale leg target position based on current motion vector
	# so that legs reset under character when not moving
	# and also move in the correct direction in general
	var last_move_dir := (global_position - last_pos).normalized()
	
	left_leg.target_max_distance  = left_leg_tmd  * leg_target_dist_scale
	right_leg.target_max_distance = right_leg_tmd * leg_target_dist_scale
	left_leg.cross  = facing
	right_leg.cross = facing
	leg_targets.global_position = _owner.global_position + last_move_dir * abs(leg_target_pos_dist)
	
	last_pos = global_position

func _handle_arms() -> void:
	var angle := atan2(-facing.z, facing.x) - PI/2.0
	left_arm_target.global_position  = global_position + left_arm_offset.rotated(Vector3.UP, angle)
	right_arm_target.global_position = global_position + right_arm_offset.rotated(Vector3.UP, angle)
