class_name GuardModel
extends HumanoidModel

@onready var __owner: Guard = owner

func _physics_process(delta: float) -> void:
	leg_target_dist_scale = 1.0 if __owner.navigation.is_navigating else 0.0
	leg_target_pos_dist   = leg_targets_z if __owner.navigation.is_navigating else 0.0
	super(delta)
