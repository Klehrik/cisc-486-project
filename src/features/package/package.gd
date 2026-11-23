class_name Package
extends Pickup

var acquired := false

func _on_body_entered(body: Node3D) -> void:
	if acquired:
		return
	acquired = true
	
	(body as Player).acquired_package = true
	
	play_animation()
	Cutscene.package()
