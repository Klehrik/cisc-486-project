class_name TestEnemy
extends CharacterBody3D

const rotation_speed := 6.0

var target: Node3D
var target_last_seen := Vector3.INF

func rotate_to_look_at(target: Vector3, delta: float) -> void:
	# TODO: need to move this and the other common enemy shit to its own thing
		# Reconsider if this many components are even needed
	var d := target - position
	var dest := atan2(-d.x, -d.z)
	rotation.y = Util.exp_decay_angle(rotation.y, dest, rotation_speed, delta)

func _on_vision_detected(target: Node3D) -> void:
	#print("Detected!")
	self.target = target

func _on_navigation_moved(direction: Vector3, delta: float) -> void:
	rotate_to_look_at(global_position + direction, delta)
