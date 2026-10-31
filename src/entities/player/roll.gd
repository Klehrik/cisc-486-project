extends State

const roll_speed 	:= 12.0
var roll_time 		:= 0.0
const roll_time_max := 0.5	## In seconds

@onready var _owner: Player = owner

func on_enter() -> void:
	roll_time = roll_time_max
	var physics: Physics = _owner.get_node("Physics")
	physics.move_vec = Vector3.ZERO
	physics.kb_vec += _owner.last_move_dir * roll_speed
	
	# Placeholder animation
	var mesh: MeshInstance3D = _owner.get_node("Mesh")
	mesh.look_at(mesh.global_position + _owner.last_move_dir)
	var tween := create_tween()
	tween.tween_property(mesh, "rotation:x", -PI * 2, roll_time_max)
	tween = create_tween()
	tween.tween_property(mesh, "position:y", mesh.position.y - 0.4, roll_time_max/2)
	tween.parallel()
	tween.tween_property(mesh, "scale:y", mesh.scale.y - 0.25, roll_time_max/2)
	tween.tween_property(mesh, "position:y", mesh.position.y, roll_time_max/2)
	tween.parallel()
	tween.tween_property(mesh, "scale:y", mesh.scale.y, roll_time_max/2)

func on_process(delta: float) -> void:
	roll_time -= delta
	if roll_time <= 0:
		parent.switch("Free")
