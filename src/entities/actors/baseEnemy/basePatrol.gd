class_name BasePatrol
extends State

@export var speed 		:= 1.5
@export var linger_time := 1.5	## Time spent at each path node (in seconds)

var linger: float

@onready var _owner: BaseEnemy = owner

func on_enter() -> void:
	linger = linger_time
	_owner.navigation.speed = speed
	
	# Temp
	_owner.get_node("Status").text = ""

func on_process(delta: float) -> void:
	# Follow path
	if not _owner.navigation.is_navigating:
		if linger > 0:
			linger -= delta
		else:
			linger = linger_time
			var dest := _owner.path.get_next()
			_owner.navigation.navigate_to_point(dest)
