extends Area3D

func _on_body_entered(body: Node3D) -> void:
	# You have one (1) job
	var p := body as Player
	if p.acquired_package:
		Cutscene.end()
		queue_free()
