class_name Game
extends Node3D

static var frame := 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug Reset"):
		get_tree().reload_current_scene()
		
	if Input.is_action_pressed("Left Mouse"):
		var vp := get_viewport()
		if vp:
			$Player.global_position = Camera.instance.project_position_to_ground(vp.get_mouse_position())
	
	if Input.is_action_just_pressed("Debug 1"):
		Event.noise.emit($Player.global_position, 8.0)
		
	if Input.is_action_just_pressed("Debug 2"):
		# Spawn enemy hitbox
		var vp := get_viewport()
		if vp:
			var hitbox: Hitbox = Scene.instantiate_global(Scene.hitbox)
			hitbox.set_orientation(
				Camera.instance.project_position_to_ground(vp.get_mouse_position()),
				$Player.global_position,
				Vector3(0.5, 0.5, 2),
				false
			)
			hitbox.collision_layer = 1 << 4
			hitbox.damage = 1.0
			hitbox.kb_vec = -hitbox.global_basis.z
			hitbox.lifetime = 2.0

func _physics_process(delta: float) -> void:
	frame += 1
