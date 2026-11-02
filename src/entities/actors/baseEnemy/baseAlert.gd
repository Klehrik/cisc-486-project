class_name BaseAlert
extends State

@export var speed 			:= 2.8	## Movement speed.
@export var rotation_speed 	:= 12.0	## [code]exp_decay_angle()[/code] rotation rate.
@export var track_time 		:= 1.5	## Time the enemy can track after target is no longer visible (in seconds).

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
	if _owner.vision.can_see_point(target_pos, true):
		track = track_time
	
	# Track accurately for a bit after target is no longer visible
	if track > 0:
		track -= delta
		
		# Rotate and move towards point
		_owner.target_last_seen = target_pos
		_owner.navigation.navigate_to_point(target_pos)
		
		# Alert nearby allies in view
		for ally: BaseEnemy in get_tree().get_nodes_in_group("Team 2"):
			if ally != self and _owner.vision.is_unobstructed(ally.global_position):
				ally.alert(target, target_pos)
		
	else:
		if not _owner.navigation.is_navigating:
			parent.switch("Search")
			return
