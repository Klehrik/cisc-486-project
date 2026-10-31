class_name World
extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug Reset"):
		get_tree().reload_current_scene()
