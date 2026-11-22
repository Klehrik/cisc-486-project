class_name Arms
extends Node3D

## UNUSED; part of HumanoidModel now (ts so scuffed)
## Handles manipulation of arms to some poses.

enum Poses {
	NEUTRAL,
	PISTOL,
	RIFLE,
}

var left_arm_offset: Vector3	## Offset from neutral in facing direction.
var right_arm_offset: Vector3	## Offset from neutral in facing direction.

@onready var left_target: Marker3D	= $LeftTarget
@onready var right_target: Marker3D = $RightTarget
@onready var model: HumanoidModel 	= get_parent()

func _ready() -> void:
	set_pose(Poses.PISTOL)

func _physics_process(delta: float) -> void:
	var angle := atan2(-model.facing.z, model.facing.x) - PI/2.0
	left_target.global_position  = global_position + left_arm_offset.rotated(Vector3.UP, angle)
	right_target.global_position = global_position + right_arm_offset.rotated(Vector3.UP, angle)

func set_pose(pose: Poses) -> void:
	match pose:
		Poses.NEUTRAL:
			left_arm_offset  = Vector3(-0.2, 0.3, -0.05)
			right_arm_offset = Vector3(0.2, 0.3, -0.05)
			
		Poses.PISTOL:
			left_arm_offset  = Vector3(-0.04, 0.5, -0.35)
			right_arm_offset = Vector3(0.04, 0.5, -0.35)
			
		Poses.RIFLE:
			pass
