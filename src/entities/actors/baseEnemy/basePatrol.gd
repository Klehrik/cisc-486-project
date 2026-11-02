class_name BasePatrol
extends State

@export var speed 			:= 1.5	## Movement speed.
@export var rotation_speed 	:= 6.0	## [code]exp_decay_angle()[/code] rotation rate.
@export var linger_time 	:= 1.5	## Time spent at each path node (in seconds).

var linger: float

@onready var _owner: BaseEnemy = owner

func on_enter() -> void:
	linger = linger_time
	_owner.navigation.speed = speed
	_owner.rotation_speed = rotation_speed
	_owner.target = null
	
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

func _on_vision_detected(target: Node3D) -> void:
	if is_current_state:
		_owner.target = target
		_owner.target_last_seen = target.global_position
		parent.switch("Suspicion")

func _on_base_enemy_notify(target: Node3D, last_seen_pos: Vector3 = Vector3.INF) -> void:
	if is_current_state:
		_owner.target = target
		_owner.target_last_seen = last_seen_pos
		parent.switch("Suspicion")
