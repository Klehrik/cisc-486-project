class_name BaseSuspicion
extends State

@export var speed 			:= 2.0	## Movement speed.
@export var rotation_speed 	:= 12.0	## [code]exp_decay_angle()[/code] rotation rate.
@export var suspicion_time 	:= 0.5	## Maximum time spent in Suspicion (in seconds) before going full Alert.
@export var track_time 		:= 1.0	## Time the enemy can track after target is no longer visible (in seconds).

var suspicion: float
var track: float

@onready var _owner: BaseEnemy = owner

func on_enter() -> void:
	suspicion = 0.0
	_owner.navigation.speed = speed
	_owner.rotation_speed = rotation_speed
		
	# Temp
	_owner.get_node("Status").text = "?"

func on_process(delta: float) -> void:
	var target := _owner.target
	
	# Track target if visible
	var target_pos := target.global_position
	if _owner.vision.can_see_point(target_pos, true):
		track = track_time
		
		# Alert once target is directly seen for long enough
		suspicion += delta
		if suspicion >= suspicion_time:
			parent.switch("Alert")
			return
		
	# Track accurately for a bit after target is no longer visible
	if track > 0:
		track -= delta
		_owner.target_last_seen = target_pos
	
	# Start Searching once last seen position is reached
	_owner.navigation.navigate_to_point(_owner.target_last_seen)
	if _owner.navigation.get_next() == Vector3.INF:
		parent.switch("Search")
		return

func _on_base_enemy_notify(target: Node3D, last_seen_pos: Vector3 = Vector3.INF) -> void:
	if is_current_state:
		_owner.target = target
		_owner.target_last_seen = last_seen_pos
