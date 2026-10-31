extends State

const speed := 2.5

var track_time 		 := 0.0
const track_time_max := 1.5	## Time the enemy can track after target is no longer visible (in seconds)

@onready var _owner: TestEnemy = owner

func on_enter() -> void:
	var navigation: Navigation = _owner.get_node("Navigation")
	if navigation:
		navigation.speed = speed
		
	print("Alert")
	_owner.get_node("Label3D").text = "!"
	_owner.add_child(PoI.new(0, 2.0))	# Pan camera to show alerted enemy for a bit

func on_process(delta: float) -> void:
	var target := _owner.target
	
	# Track target if visible
	var target_pos := _owner.target.global_position
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
		
	else:
		if not navigation.is_navigating:
			parent.switch("Suspicion")

func on_exit() -> void:
	_owner.target = null
