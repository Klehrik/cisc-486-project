class_name BaseSearch
extends State

@export var speed 			:= 2.0	## Movement speed.
@export var rotation_speed 	:= 12.0	## [code]exp_decay_angle()[/code] rotation rate.
@export var search_radius 	:= 6.0	## Area to search around target last seen position (in metres).
@export var search_time 	:= 30.0	## Time spent in Search (in seconds).
@export var linger_time_min := 2.0	## Minimum time spent at each search spot (in seconds).
@export var linger_time_max := 5.0	## Maximum time spent at each search spot (in seconds).
@export var look_time_min 	:= 2.0	## Minimum time spent looking around in place at a search spot (in seconds).
@export var look_time_max 	:= 5.0	## Maximum time spent looking around in place at a search spot (in seconds).

var search: float
var linger: float
var look: float
var look_point: Vector3

@onready var _owner: BaseEnemy = owner

func on_enter() -> void:
	search = search_time
	linger = randf_range(linger_time_min, linger_time_max)
	_owner.navigation.speed = speed
	_owner.rotation_speed = rotation_speed
	_owner.target = null
		
	# Temp
	_owner.get_node("Status").text = "..?"

func on_process(delta: float) -> void:
	# Move to random spot in search radius
	if not _owner.navigation.is_navigating:
		if linger > 0:
			linger -= delta
			
			# Look around on the spot; pick a new direction periodically
			look -= delta
			if look <= 0:
				look = randf_range(look_time_min, look_time_max)
				look_point = _owner.global_position + Vector3.FORWARD.rotated(Vector3.UP, randf_range(-PI, PI))
			_owner.rotate_to_look_at(look_point, delta)
			
		else:
			linger = randf_range(linger_time_min, linger_time_max)
			var pos = _owner.target_last_seen + Vector3.FORWARD.rotated(Vector3.UP, randf_range(-PI, PI)) * randf_range(0, search_radius)
			var map := _owner.get_world_3d().get_navigation_map()
			var region_pos := NavigationServer3D.map_get_closest_point(map, pos)
			region_pos.y = 0	## NavMap floats above the ground a bit
			_owner.navigation.navigate_to_point(region_pos)
	
	search -= delta
	if search <= 0:
		_owner.navigation.stop()
		_owner.path.reset_to_nearest_node(_owner.global_position)
		parent.switch("Patrol")

func _on_vision_detected(target: Node3D) -> void:
	if is_current_state:
		_owner.target = target
		_owner.target_last_seen = target.global_position
		parent.switch("Suspicion")

func _on_hearing_heard(pos: Vector3) -> void:
	if is_current_state:
		_owner.target_last_seen = pos
		parent.switch("Suspicion")

func _on_base_enemy_notify(target: Node3D, last_seen_pos: Vector3 = Vector3.INF) -> void:
	if is_current_state:
		_owner.target = target
		_owner.target_last_seen = last_seen_pos
		parent.switch("Suspicion")
