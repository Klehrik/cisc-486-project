class_name BaseAlert
extends State

@export var speed 			:= 2.8	## Movement speed.
@export var vision_mult		:= 1.5	## Vision range multiplier.
@export var rotation_speed 	:= 12.0	## [code]exp_decay_angle()[/code] rotation rate.
@export var track_time 		:= 1.5	## Time the enemy can track after target is no longer visible (in seconds).
@export var stay_away_dist	:= 1.5	## Minimum distance the enemy should stay away from the target (in metres).

var track: float

@onready var _owner: BaseEnemy = owner

func on_enter() -> void:
	_owner.navigation.speed = speed
	_owner.rotation_speed = rotation_speed
	
	# Temp
	_owner.get_node("Status").text = "!"
	_owner.add_child(PoI.new(0, 1.5))	# Pan camera to show alerted enemy for a bit

func on_process(delta: float) -> void:
	var target := _owner.target
	
	# Track target if visible
	var target_pos := target.global_position
	var can_see_point := _owner.vision.can_see_point(target_pos, vision_mult)
	if can_see_point:
		track = track_time
	
	# Track accurately for a bit after target is no longer visible
	if track > 0:
		track -= delta
		
		# Rotate and move towards point (maintain min dist from target if >0)
		# 	Rotate to face target manually if in view, otherwise follow move direction
		# 	This allows for maintaining eye contact while moving backwards
		_owner.target_last_seen = target_pos
		_owner.rotate_while_moving = true
		if can_see_point:
			_owner.rotate_to_look_at(target_pos, delta)
			_owner.rotate_while_moving = false
			if stay_away_dist > 0:
				var dir := (_owner.global_position - target_pos).normalized()
				target_pos += dir * stay_away_dist
		_owner.navigation.navigate_to_point(target_pos)
		
		# Notify nearby allies in view
		for ally: BaseEnemy in get_tree().get_nodes_in_group("Team 2"):
			if ally != self and _owner.vision.is_unobstructed(ally.global_position):
				ally.notify.emit(target, target_pos)
		
	else:
		if not _owner.navigation.is_navigating:
			parent.switch("Search")
			return

func on_exit() -> void:
	_owner.rotate_while_moving = true

func _on_base_enemy_notify(target: Node3D, last_seen_pos: Vector3 = Vector3.INF) -> void:
	if is_current_state:
		_owner.target = target
		_owner.target_last_seen = last_seen_pos
