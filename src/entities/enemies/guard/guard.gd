class_name Guard
extends BaseEnemy

func _physics_process(delta: float) -> void:
	$Model.facing = -global_basis.z
