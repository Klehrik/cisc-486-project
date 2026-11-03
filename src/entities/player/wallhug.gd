extends State

@onready var _owner: Player = owner

func on_enter() -> void:
	_owner.has_silent_movement = true

func on_process(delta: float) -> void:
	_owner.handle_movement(0.35)
	
	if not _owner.handle_camera_wallhug():
		parent.switch("Free")

func on_exit() -> void:
	_owner.has_silent_movement = false
