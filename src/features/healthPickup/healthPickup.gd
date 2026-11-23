class_name HealthPickup
extends Pickup

@export var amount := 2.5	## Amount of health recovered from this pickup.
var acquired := false

func _on_body_entered(body: Node3D) -> void:
	for hurtbox: Hurtbox in body.find_children("*", "Hurtbox"):
		# Do nothing at full health
		if hurtbox.health >= hurtbox.health_max:
			HUDPopup.add("[color=red]Already at full health[/color]")
			return
		
		hurtbox.health += amount
		HUDPopup.add("Recovered %s%% health" % int(amount / hurtbox.health_max * 100))
		break
		
	if acquired:
		return
	acquired = true

	play_animation()
