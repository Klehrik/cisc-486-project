extends State

@onready var _owner: Player = owner

func on_process(delta: float) -> void:
	_owner.handle_movement(0.35)
	
	if not _owner.handle_camera_wallhug():
		parent.switch("Free")
