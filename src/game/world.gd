class_name World
extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug Reset"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("Left Mouse"):
		$Player.global_position = Camera.instance.project_position_to_ground(get_viewport().get_mouse_position())
