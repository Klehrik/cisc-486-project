class_name Player
extends CharacterBody3D

var move_speed := 3.0
var has_silent_movement := false

var last_move_dir := Vector3.RIGHT	## Normalized direction of last movement.
var wallhug_normal: Vector3			## Normal of the wall being hugged.

var pitch: Camera.CameraOrientation
var wallhug: Camera.CameraOrientation

func _ready() -> void:
	var camera := Camera.instance
	camera.add_target(self, 100)
	pitch = Camera.CameraOrientation.new(
		Vector3(deg_to_rad(-75.0),
				camera.base_orientation.rotation.y,
				camera.base_orientation.rotation.z)
	)
	wallhug = Camera.CameraOrientation.new(
		Vector3(deg_to_rad(-20.0), 0, 0),
		Vector3.UP * 2,
		0.5,
		5.0,
		true
	)
	Event.stepped_on_noisy.connect(_on_event_stepped_on_noisy)

func _physics_process(delta: float) -> void:
	handle_camera_pitch()

func handle_movement(speed_multiplier: float = 1.0) -> void:
	var input_vec := Input.get_vector("Left", "Right", "Up", "Down")
	var move_dir := Camera.instance.get_relative(Vector3(input_vec.x, 0, input_vec.y))
	if move_dir != Vector3.ZERO:
		last_move_dir = move_dir
	($Physics as Physics).move_vec = move_dir * move_speed * speed_multiplier

func handle_camera_pitch() -> void:
	var camera := Camera.instance
	if Input.is_action_pressed("Pitch"):
		camera.add_orientation(pitch)
	else:
		camera.remove_orientation(pitch)

func handle_camera_wallhug() -> bool:
	var camera := Camera.instance
	var space_state := get_world_3d().direct_space_state

	# Check if still touching wall (since `is_on_wall()` is inconsistent at that)
	var query := PhysicsRayQueryParameters3D.create(
		global_position,
		global_position + (-wallhug_normal * 0.35),
		collision_mask
	)
	var result := space_state.intersect_ray(query)
	if result:
		# Modify wallhug orientation when pitched
		if Input.is_action_pressed("Pitch"):
			wallhug.rotation.x = deg_to_rad(-40.0)
			wallhug.offset     = Vector3.UP * 4
			wallhug.dist_scale = 0.7
		else:
			wallhug.reset()
			
		# Rotate orientation to face wall
		wallhug.rotation.y = atan2(result.normal.x, result.normal.z)
		
		camera.add_orientation(wallhug, 1)
		return true
		
	else:
		camera.remove_orientation(wallhug)
		return false

## [code]true[/code] if touching wall with movement input
func is_pushing_against_wall() -> bool:
	if not is_on_wall():
		return false
	var input_vec := Input.get_vector("Left", "Right", "Up", "Down")
	return input_vec != Vector2.ZERO

func _on_hurtbox_body_entered(body: Node3D) -> void:
	# Temp
	await get_tree().process_frame
	get_tree().reload_current_scene()

func _on_event_stepped_on_noisy(entity: Node3D, sound_range: float) -> void:
	if has_silent_movement:
		return
	if entity != self:
		return
	if ($Physics as Physics).move_vec == Vector3.ZERO:
		return
	Event.noise.emit(global_position, sound_range)
