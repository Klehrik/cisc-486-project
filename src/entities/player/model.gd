class_name PlayerModel
extends HumanoidModel

@onready var __owner: Player = owner

func _physics_process(delta: float) -> void:
	var physics := __owner.physics
	var scaling := physics.move_vec.length() / __owner.move_speed
	leg_target_pos_dist = leg_targets_z * scaling
	super(delta)
