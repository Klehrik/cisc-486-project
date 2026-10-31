extends State

const speed := 2.8

var track_time 		 := 0.0
const track_time_max := 1.5	## Time the enemy can track after target is no longer visible (in seconds)

@onready var _owner: TestEnemy = owner

func on_enter() -> void:
	var navigation: Navigation = _owner.get_node("Navigation")
	if navigation:
		navigation.speed = speed
		
	print("Alert")
	_owner.get_node("Label3D").text = "!"
	_owner.add_child(PoI.new(0, 1.5))	# Pan camera to show alerted enemy for a bit

func on_process(delta: float) -> void:
	var target := _owner.target
	
	# Track target if visible
	var target_pos := target.global_position
	var vision: Vision = _owner.get_node("Vision")
	if vision.can_see_point(target_pos, true):
		track_time = track_time_max
	
	# Track accurately for a bit after target is no longer visible
	var navigation: Navigation = _owner.get_node("Navigation")
	if track_time > 0:
		track_time -= delta
		
		_owner.target_last_seen = target_pos
		_owner.rotate_to_look_at(target_pos, delta)
	
		navigation.navigate_to_point(target_pos)
		
		# Alert nearby allies in view
		for ally: CharacterBody3D in get_tree().get_nodes_in_group("Team 2"):
			if ally != self and vision.unobstructed(ally.global_position):
				# TODO: needs refactoring into its own thing
				ally.target = target
				ally.target_last_seen = _owner.target_last_seen
				ally.get_node("Navigation").navigate_to_point(_owner.target_last_seen)
		
	else:
		if not navigation.is_navigating:
			parent.switch("Suspicion")
			return

func on_exit() -> void:
	_owner.target = null
