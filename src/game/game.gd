class_name Game
extends Node3D

static var frame := 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug Reset"):
		get_tree().reload_current_scene()
		
	if Input.is_action_pressed("Left Mouse"):
		pass
		#var vp := get_viewport()
		#if vp:
		#	$Player.global_position = Camera.instance.project_position_to_ground(vp.get_mouse_position())
	
	if Input.is_action_just_pressed("Debug 1"):
		Event.noise.emit($Player.global_position, 9.0)
		
	if Input.is_action_just_pressed("Debug 2"):
		# Spawn hitbox
		var vp := get_viewport()
		if vp:
			var hitbox: Hitbox = Scene.instantiate_global(Scene.hitbox)
			hitbox.set_orientation(
				Camera.instance.project_position_to_ground(vp.get_mouse_position()),
				$Player.global_position,
				Vector3(0.5, 0.5, 2),
				false
			)
			hitbox.collision_layer = 1 << 3 | 1 << 4	# Team 1 and Team 2 attacks respectively
			hitbox.damage = 1.0
			hitbox.kb_vec = -hitbox.global_basis.z
			hitbox.lifetime = 2.0
		
	if Input.is_action_just_pressed("Debug 3"):
		# Spawn enemy projectile
		var vp := get_viewport()
		if vp:
			var p: Projectile = Scene.instantiate_global(Scene.projectile)
			p.global_position = Camera.instance.project_position_to_ground(vp.get_mouse_position()) + (Vector3.UP * 0.5)
			var dir := (Util.vector_zero_y($Player.global_position) - Util.vector_zero_y(p.global_position)).normalized()
			p.velocity = dir * 50
			p.damage = 1.0
			p.kb_vec = dir * 2.5
			p.set_team(2)

func _physics_process(delta: float) -> void:
	frame += 1
