extends State

const speed := 1.5

var linger: float
const linger_time := 1.5	## Time spent at each path node (in seconds)

@onready var _owner: TestEnemy = owner

func on_enter() -> void:
	linger = linger_time
	
	var navigation: Navigation = _owner.get_node("Navigation")
	if navigation:
		navigation.speed = speed
		
	print("Patrol")
	_owner.get_node("Label3D").text = ""

func on_process(delta: float) -> void:
	# Follow path
	var navigation: Navigation = _owner.get_node("Navigation")
	var path: Path 			   = _owner.get_node("Path")
	if navigation and path:
		if not navigation.is_navigating:
			if linger > 0:
				linger -= delta
			else:
				linger = linger_time
				var dest := path.get_next()
				navigation.navigate_to_point(dest)
	
	if _owner.target:
		parent.switch("Alert")
