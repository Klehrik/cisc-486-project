extends State

const speed := 1.5
const search_radius := 6.0	## Area to search around target last seen position (in metres)

var time: float
const time_max := 30.0	## Time spent in Suspicion (in seconds)

var linger: float
const linger_time := [2.0, 5.0]	## Time spent at each search spot (in seconds)

var facing: float
const facing_time := [1.0, 2.0]
var facing_point: Vector3

@onready var _owner: TestEnemy = owner

func on_enter() -> void:
	time = time_max
	linger = randf_range(linger_time[0], linger_time[1])
	
	var navigation: Navigation = _owner.get_node("Navigation")
	if navigation:
		navigation.speed = speed
		
	print("Suspicion")
	_owner.get_node("Label3D").text = "?"

func on_process(delta: float) -> void:
	# Move to random spot in search radius
	var navigation: Navigation = _owner.get_node("Navigation")
	if not navigation.is_navigating:
		if linger > 0:
			linger -= delta
			
			# Look around on the spot
			# Pick a new direction periodically
			facing -= delta
			if facing <= 0:
				facing = randf_range(facing_time[0], facing_time[1])
				facing_point = _owner.global_position + Vector3.FORWARD.rotated(Vector3.UP, randf_range(-PI, PI))
			_owner.rotate_to_look_at(facing_point, delta)
			
		else:
			linger = randf_range(linger_time[0], linger_time[1])
			var pos = _owner.target_last_seen + Vector3.FORWARD.rotated(Vector3.UP, randf_range(-PI, PI)) * randf_range(0, search_radius)
			var map := _owner.get_world_3d().get_navigation_map()
			var region_pos := NavigationServer3D.map_get_closest_point(map, pos)
			region_pos.y = 0
			navigation.navigate_to_point(region_pos)
	
	if _owner.target:
		parent.switch("Alert")
		return

	time -= delta
	if time <= 0:
		parent.switch("Patrol")
