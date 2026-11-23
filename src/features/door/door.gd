extends Area3D

const tween_t := 5.0

var is_open := false

func _ready() -> void:
	# Add these after so they don't mess with NavMap
	$Left.collision_layer  = 1
	$Right.collision_layer = 1

func _on_body_entered(body: Node3D) -> void:
	if is_open:
		return
	
	var p := body as Player		# Who else would it be at this point
	
	if not p.acquired_keycard:
		HUDPopup.add("[color=red]Access denied[/color]")
		return
	
	HUDPopup.add("[color=#0095e9]Access granted[/color]")
	is_open = true
	
	# Animation
	# I love tweens
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(1.0)
	
	var move_amount := 2.95	# Each door is 3m wide at base
	tween.tween_property($Left,  "position:x", $Left.position.x - move_amount, tween_t)
	tween.parallel()
	tween.tween_property($Right, "position:x", $Right.position.x + move_amount, tween_t)
	
	await tween.finished
	var poi := get_node_or_null("PoI")
	if poi:
		poi.queue_free()
