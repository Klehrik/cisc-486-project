extends State

var wallhug_value: float
const wallhug_max := 0.5	## Time (in seconds) to push against wall for wallhug

@onready var _owner: Player = owner

func on_process(delta: float) -> void:
	_owner.handle_movement()
	
	# Roll check
	if Input.is_action_just_pressed("Roll"):
		parent.switch("Roll")
		return
	
	# Wallhug check
	if _owner.is_pushing_against_wall():
		wallhug_value += delta
		if wallhug_value >= wallhug_max:
			_owner.wallhug_normal = _owner.get_wall_normal()
			parent.switch("Wallhug")
	else:
		wallhug_value = 0.0
