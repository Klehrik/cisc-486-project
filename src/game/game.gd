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
		Event.sound.emit($Player.global_position, 8.0)

func _physics_process(delta: float) -> void:
	frame += 1
