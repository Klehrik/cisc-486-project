extends State

@onready var _owner: Player = owner

func on_process(delta: float) -> void:
	_owner.handle_movement(0.35)
	_owner.handle_equipment_use()
	_owner.last_footstep = _owner.global_position
	
	if not _owner.handle_camera_wallhug():
		parent.pop()
