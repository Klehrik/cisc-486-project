class_name Keycard
extends Pickup

var acquired := false

func _on_body_entered(body: Node3D) -> void:
	if acquired:
		return
	acquired = true
	
	(body as Player).acquired_keycard = true
	
	HUDPopup.add("Acquired [color=#0095e9]keycard[/color]")
	play_animation()
