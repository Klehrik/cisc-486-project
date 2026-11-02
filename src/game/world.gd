class_name World
extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug Reset"):
		get_tree().reload_current_scene()
		
	if Input.is_action_pressed("Left Mouse"):
		var vp := get_viewport()
		if vp:
			$Player.global_position = Camera.instance.project_position_to_ground(vp.get_mouse_position())
	
	if Input.is_action_just_pressed("Debug 1"):
		Event.sound.emit($Player.global_position, 10.0)
